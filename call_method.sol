pragma solidity ^0.4.24;

contract class22{
    
    uint256 public integer_1 = 1;
    uint256 public integer_2 = 2;
    string public string_1;

    event setNumber(string _from);
  // 事件  事件名稱  你要紀錄的東西
    
    //pure 不讀鏈上資料 不改鏈上資料     計算東西...
    function function_1(uint a,uint b) public pure returns(uint256){
        return a + 2*b;
    }
    
    //view 讀鏈上資料 不改鏈上資料   getName...
    function function_2() public view returns(uint256){
        return integer_1 + integer_2;
    }

    //修改鏈上資料    setName...
    function function_3(string x) public returns(string){
        string_1 = x;
        emit setNumber(string_1);
        return string_1;
    }
    //實作事件12/29 第23堂課
    
    //修改鏈上資料
    function class(string x) public returns(string){
        string_1 = x;
        return string_1;
    }
    
    //實作各式方法還有建構式

    uint public abc = 0;

    function me1() public 
    {
        abc++;
    }
    function me2() public 
    {
        abc--;
    }
    constructor() public //建構視為合約一部屬上去就優先執行的方法，且沒有回傳值
    {
        abc= 10;
    }

}
   