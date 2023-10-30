pragma solidity ^0.8.0;

contract StakingAssembly {
    
    address payable public owner;
    address public token;
    
    mapping (address => uint) public balance;

    constructor(address _token) {
        assembly {
          sstore(1, _token)
        }
    }

    function stake(uint amount) public {
      
        bytes4 functionSelector = bytes4(keccak256("transferFrom(address,address,uint256)"));
        address thisContract = address(this);
        address _token = token;

        assembly {
        mstore(0, functionSelector)
        mstore(add(0, 0x04), caller())  // First argument: from
        mstore(add(0, 0x24), thisContract)    // Second argument: to
        mstore(add(0, 0x44), amount) // Third argument: value
        
        let success := call(230000, _token, 0, 0, 0x64, 0, 0)
        if eq(success, 0) {
            revert(0, 0)
        }
          let data := mload(0x64)
          mstore(data, caller())
          mstore(add(data, 32), 2)
          let hash := keccak256(data, add(data, 64))
          sstore(hash, amount)

        }
    }

}