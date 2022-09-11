// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract FLTask
{
    // task proposer account
    address _proposer;

    struct Validator {
        address account;
        // validator has uploaded valid weights
        bool uploaded;
        // validator public key
        // PubKey pub_key;
    }

    // account => Validator
    mapping(address => Validator) _validators;

    struct Aggregator {
        address account;
        // aggregator has uploaded aggregated weights
        bool uploaded;
        // aggregator public key
        // PubKey pub_key;
    }

    // account => Aggregator
    mapping(address => Aggregator) _aggregators;

    // split pubkey(64bytes) into two parts(32+32bytes), try to save gas?    
    struct PubKey {
        // part 1
        bytes32 pub_key_p1;
        // part 2
        bytes32 pub_key_p2;
    }

    struct Round {
        // round id(rnd)
        uint id;
        // aggregate condition
        uint valid_weight_goal;
        // aggregated condition
        uint aggregated_weight_goal;
        // valid client weights
        string[] client_weights;
        // aggregated weights
        string[] aggregated_weights;
        // weights => count
        mapping(string => uint) aggregated_weights_count;
    }

    uint _round_id;
    // current round infomation
    Round _round;
    // record round infomation in event
    event RoundEvent(uint indexed id, address actor, string[] client_weights);

    // state: 1: model collecting state, 2: model aggregating state
    uint _state;
    // tell aggregator time to aggregate client weights
    event AggregateEvent(uint indexed id);
    // tell validator time to transfer aggregated model
    event ValidateEvent(uint indexed id, string);

    // modifier onlyValidator {
    //     require(validators[msg.sender].account == msg.sender);
    //     _;
    // }

    // modifier onlyUploadedValidator {
    //     require(validators[msg.sender].account == msg.sender);
    //     require(validators[msg.sender].uploaded == false);
    //     _;
    // }
    constructor() {
        _proposer = msg.sender;
    }

    // validator set valid client weights
    function set_client_weights(string[] memory client_weights) public {
        // model collecting state
        require(_state == 1);
        // validator & no upload
        require(_validators[msg.sender].account == msg.sender);
        require(_validators[msg.sender].uploaded == false);

        for(uint i = 0; i < client_weights.length; i++) {
            _round.client_weights.push(client_weights[i]);
        }
        // record Round information
        emit RoundEvent(_round_id, msg.sender, client_weights);
        // if reach aggregate goal, trigger event
        if(_round.client_weights.length >= _round.valid_weight_goal) {
            // trun to model aggregating state
            _state = 2;
            emit AggregateEvent(_round_id);
        }
    }

    // aggregator set aggregated weights
    function set_aggregated_weights(string memory aggregated_weight) public {
        // model aggregating state
        require(_state == 2);
        // aggregator & no upload
        require(_aggregators[msg.sender].account == msg.sender);
        require(_aggregators[msg.sender].uploaded == false);

        _round.aggregated_weights.push(aggregated_weight);
        // if exist same weights, count + 1
        // may consider use SafeMath to avoid overflow
        _round.aggregated_weights_count[aggregated_weight] += 1;
        // if reach aggregated goal, trigger event
        // return the most one
        if(_round.aggregated_weights.length >= _round.aggregated_weight_goal) {
            uint most_count = 0;
            string memory most_weight = "";
            for(uint i = 0; i < _round.aggregated_weights.length; i++) {
                string memory _aggregated_weight = _round.aggregated_weights[i];
                uint count = _round.aggregated_weights_count[_aggregated_weight];
                if(most_count < count) {
                    most_count = count;
                    most_weight = _aggregated_weight;
                }
            }
            // trun to model collecting state
            _state = 1;
            emit ValidateEvent(_round_id, most_weight);
        }
    }

    // validator get aggregated weights --> test
    function get_aggregated_weights() public view returns(string[] memory) {
        return _round.aggregated_weights;
    }

    // aggregator get valid client weights --> test
    function get_valid_weights() public view returns(string[] memory) {
        return _round.client_weights;
    }
}