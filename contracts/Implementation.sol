pragma solidity ^0.8.9;

import "./Lock.sol";

contract ImplementationContract {
    uint public storage1;
    uint[] public storage2;

    mapping (uint => uint) public storage3;

    function updateNumber(uint newNumber) public {
        storage1 = newNumber;
    }

    function updateArray(uint[] memory newArray) public {
        storage2 = newArray;
    }

    function updateMapping(uint256 id, uint256 amount) public {
        storage3[id] = amount;
    }

}
