pragma solidity ^0.8.0;

contract StakingAssembly {
    
    address payable public owner;
    address public token;
    bool isOpen;

    mapping (address => uint) public balance;

    constructor(address _token) {
        assembly {
          sstore(0x00, caller())
          sstore(0x01, _token)
        }
    }

    modifier onlyOwner() {
    assembly {
      switch eq(caller(), sload(0x00))
      case 0 { revert(0, 0) }
    }
    _;
    }

    modifier onlyOpen() {
      assembly {
        switch eq(sload(0x02), 1)
        case 0 {revert(0,0)}
      }
      _;
    }

    function stake(uint amount) public onlyOpen() {
      
        bytes4 functionSelector = bytes4(keccak256("transferFrom(address,address,uint256)"));
        address thisContract = address(this);
        address _token = token;

        assembly {
       // ----------------------------------
       // Transfer tokens from caller to this contract
        mstore(0, functionSelector)
        mstore(add(0, 0x04), caller())  
        mstore(add(0, 0x24), thisContract)   
        mstore(add(0, 0x44), amount) 
        
        let success := call(230000, sload(0x01), 0, 0, 0x64, 0, 0)
        if eq(success, 0) {
            revert(0, 0)
        }

        // -------------------------------------------

        // Update balance mapping ----
          let data := mload(0x64)
          mstore(data, caller())
          mstore(add(data, 32), 2)
          let hash := keccak256(data, add(data, 64))
          sstore(hash, amount)
        // ---------------------------
        }
    }

    function changeStatus(bool _isOpen) public onlyOwner {
      assembly {
        sstore(0x02, _isOpen)
      }
    }

}