// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
A player needs to send 10 Ether and wins if the block.timestamp % 15 == 0.
*/

contract Roulette {
    uint public pastBlockTime;

    constructor() payable {}

    function spin() external payable {
        require(msg.value == 10 ether); // 假設一遊戲限制最多投入10ETH
        require(block.timestamp != pastBlockTime); // 限制此block只有這筆交易
        

        pastBlockTime = block.timestamp;

        if (block.timestamp % 15 == 0) {
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}