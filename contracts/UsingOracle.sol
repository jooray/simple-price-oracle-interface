pragma solidity ^0.4.21;

interface UsingOracle {
  // oracleTimeStamp is a timestamp of the price given by the oracle. Helps
  // prevent a miner holding off a signed transaction to use it later
    function oracleCallback(uint256 price, uint256 oracleTimestamp, string pairName) external;

}
