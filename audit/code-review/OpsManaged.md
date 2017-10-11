# OpsManaged

Source file [../../contracts/OpsManaged.sol](../../contracts/OpsManaged.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// ----------------------------------------------------------------------------
// Simple Token - Operations Privileges
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Ok
import "./OpenZepplin/Ownable.sol";


//
// Implements a simple 2 level access permission for owner and operations
//
// BK Ok
contract OpsManaged is Ownable {

   // BK Ok
   address public operationsAddress;


   // Events
   // BK Ok - Event
   event OperationsAddressChanged(address indexed _newAddress);


   // BK Ok - Constructor
   function OpsManaged()
      Ownable()
   {
   }


   // The owner is allowed to change the operations address.
   // Can also be set to 0 to disable operations.
   // BK Ok - Only owner can execute this
   function setOperationsAddress(address _address) external onlyOwner returns (bool) {
      // BK Ok
      require(_address != owner);

      // BK Ok
      operationsAddress = _address;

      // BK Ok - Log event
      OperationsAddressChanged(_address);

      // BK Ok
      return true;
   }


   // BK Ok
   modifier onlyOwnerOrOps() {
      // BK Ok
      require(isOwnerOrOps(msg.sender) == true);
      // BK Ok
      _;
   }


   // BK Ok - Constant function
   function isOps(address _address) public constant returns (bool) {
      // BK Ok
      return (operationsAddress != address(0) && _address == operationsAddress);
   }


   // BK Ok - Constant function
   function isOwnerOrOps(address _address) public constant returns (bool) {
      // BK Ok
      return (_address == owner || isOps(_address) == true);
   }
}



```
