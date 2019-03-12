pragma solidity ^0.4.21;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./UsingOracle.sol";

contract UsingMultipleOracles is UsingOracle, Ownable {
    address[] allowedOracles;

    function authenticatedOracleCallback(uint256 price, uint256 oracleTimestamp, string pairName) private;

  // oracleTimeStamp is a timestamp of the price given by the oracle. Helps
  // prevent a miner holding off a signed transaction to use it later
    function oracleCallback(uint256 price, uint256 oracleTimestamp, string pairName) public {
        require(msg.sender != address(0));
        bool found = false;
        for (uint256 i = 0; i < allowedOracles.length; i++) {
            if (msg.sender == allowedOracles[i]) {
                found = true;
                break;
            }
        }
        require(found);

        // make sure timestamp is not from the future
        require(oracleTimestamp <= block.timestamp); // solium-disable-line security/no-block-members

        authenticatedOracleCallback(price, oracleTimestamp);

    }

    function allowOracle(address _oracle) onlyOwner() public {
        allowedOracles.push(_oracle);
    }

    function disallowOracle(address _oracle) onlyOwner() public {
        assert(_oracle != address(0));
        for (uint256 i = 0; i < allowedOracles.length; i++) {
            if (_oracle == allowedOracles[i]) {
                allowedOracles[i] = allowedOracles[allowedOracles.length - 1];
                allowedOracles.length -= 1;
            }
        }
    }

    // all these oracles should support OracleInterface
    function getAllowedOracles() view public returns (address[]) {
        return allowedOracles;
    }



}
