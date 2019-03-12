pragma solidity ^0.4.21;

interface PriceOracleInterface {

    // return wei price per oracle query
    function getPriceForQuery() external returns (uint256);

    // return pair name
    function getPairName() external view returns(string);

    // query the price and callback contractToCallBack.oracleCallback(price, timestamp)
    // see UsingOracle interface
    function query(address contractToCallBack) payable external;

}
