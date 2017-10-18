# Owned

Source file [../../contracts/Owned.sol](../../contracts/Owned.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Basic Ownership Implementation
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


//
// Implements basic ownership with 2-step transfers.
//
// BK Ok
contract Owned {

    // BK Ok
    address public owner;
    // BK Ok
    address public proposedOwner;

    // BK Next 2 Ok - Events
    event OwnershipTransferInitiated(address indexed _proposedOwner);
    event OwnershipTransferCompleted(address indexed _newOwner);


    // BK Ok - Constructor
    function Owned() public {
        // BK Ok
        owner = msg.sender;
    }


    // BK Ok
    modifier onlyOwner() {
        // BK Ok
        require(isOwner(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok - View function
    function isOwner(address _address) internal view returns (bool) {
        // BK Ok
        return (_address == owner);
    }


    // BK Ok - Only owner can execute
    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
        // BK Ok
        proposedOwner = _proposedOwner;

        // BK Ok - Log event
        OwnershipTransferInitiated(_proposedOwner);

        // BK Ok
        return true;
    }


    // BK Ok - Only proposed owner can execute
    function completeOwnershipTransfer() public returns (bool) {
        // BK Ok
        require(msg.sender == proposedOwner);

        // BK Ok
        owner = proposedOwner;
        // BK Ok
        proposedOwner = address(0);

        // BK Ok - Log event
        OwnershipTransferCompleted(owner);

        // BK Ok
        return true;
    }
}



```
