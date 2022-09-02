pragma solidity ^0.4.24;
contract payable{    
    mapping(address=>uint) public balances;

    uint public abc = 0;

    //function () public{
    //    abc++;

        //不能對此合約發送以太
    //}
    // function () public payable{

         //可以對此合約發送以太(有無payalbe)
   //  }
    
    function sendEther()public payable{
        balances[msg.sender] += msg.value;
    }

    function sendEtherNoPayable()public
    {
        balances[msg.sender] += msg.value;
    }

    function returntest() public returns(address){
        abc = runrun();
        return msg.sender;
    }
    function runrun() public returns(uint){     //無名方法

        uint a = 0;
        uint b = 5;
        return a + b + abc;
    }

 
    
}
