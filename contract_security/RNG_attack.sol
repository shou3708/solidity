pragma solidity ^0.4.24;

contract game{

    event win(address);

    function get_random() public view returns(uint){
        bytes32 ramdon = keccak256(abi.encodePacked(now,blockhash(block.number-1)));
        return uint(ramdon) % 1000;
    }

    function play() public payable {
        require(msg.value == 0.01 ether);
        if(get_random()>=500){
            msg.sender.transfer(0.02 ether);
            emit win(msg.sender);
        }
    }

    function () public payable{
        require(msg.value == 0.05 ether);
    }
    
    constructor () public payable{
        require(msg.value == 0.05 ether);
    }
}
