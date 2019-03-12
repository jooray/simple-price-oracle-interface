pragma solidity ^0.4.21;

import "../PriceOracleInterface.sol";
import "../UsingOracle.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract SimpleOracle is PriceOracleInterface, Ownable {

  uint256 currentPriceForQuery = 0;
  uint256 lastPrice = 0;
  uint256 lastPriceUpdate = 0;

  event QueryRequested(uint256 payment, address contractToCallBack);

  // return wei price per oracle query
  function getPriceForQuery() public returns (uint256) {
    return currentPriceForQuery;
  }

  // query the price and callback contractToCallBack.oracleCallback(price, timestamp)
  // see UsingOracle interface
  function query(address contractToCallBack) payable public {
    require(msg.value >= currentPriceForQuery);
    emit QueryRequested(msg.value, contractToCallBack);
    owner.transfer(address(this).balance);
  }

  function getLastPrice() view public returns(uint256 price, uint256 priceUpdate) {
    return (lastPrice, lastPriceUpdate);
  }

  // Thse functions can only be called by the owner of the contract

  function callbackPrice(uint256 price, uint256 timestamp, address contractToCallBack) public onlyOwner() {
      UsingOracle oracle = UsingOracle(contractToCallBack);
      lastPrice = price;
      lastPriceUpdate = timestamp;
      oracle.oracleCallback(price, timestamp);
  }

  function setPriceForQuery(uint256 priceForQuery) onlyOwner() public {
    currentPriceForQuery = priceForQuery;
  }

}
