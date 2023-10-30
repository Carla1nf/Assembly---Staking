// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract ProxyContract {
    uint public unlockTime;
    uint[] public allNumbers;

    mapping (uint => uint) public amountPerID;

    address payable public owner;
    address implementationContract;

    mapping (address => uint) balance;

    constructor(address newImp) {
        implementationContract = newImp;
    }

    function callImplementation(uint newNumber) public payable {
        (bool success, bytes memory data) = implementationContract.delegatecall(
        abi.encodeWithSignature("updateNumber(uint256)", newNumber));
        require(success, "Not");

    }


    function callImplementation2(uint[] memory newNumber) public payable {

        (bool success, bytes memory data) = implementationContract.delegatecall(
        abi.encodeWithSignature("updateArray(uint256[])", newNumber));
        require(success, "Not");

    }

        function callImplementation3(uint id, uint newNumber) public payable {

        (bool success, bytes memory data) = implementationContract.delegatecall(
        abi.encodeWithSignature("updateMapping(uint256,uint256)", id, newNumber));
        require(success, "Not");
        
    }
  
  function getMappingSlot(uint num, uint slot) public pure returns(bytes32 hash) {
       assembly {
    
        mstore(0, num)
        mstore(32, slot)
        hash := keccak256(0, 64)
    } 
}


    

}
