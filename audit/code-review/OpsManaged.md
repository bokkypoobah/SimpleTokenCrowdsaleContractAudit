# OpsManaged

Source file [../../contracts/OpsManaged.sol](../../contracts/OpsManaged.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Admin / Ops Permission Model
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Ok
import "./Owned.sol";


//
// Implements a more advanced ownership and permission model based on owner,
// admin and ops per Simple Token key management specification.
//
// BK Ok
contract OpsManaged is Owned {

    // BK Ok
    address public opsAddress;
    // BK Ok
    address public adminAddress;

    // BK Ok
    event AdminAddressChanged(address indexed _newAddress);
    // BK Ok
    event OpsAddressChanged(address indexed _newAddress);


    // BK Ok - Constructor
    function OpsManaged() public
        Owned()
    {
    }


    // BK Ok
    modifier onlyAdmin() {
        require(isAdmin(msg.sender));
        _;
    }


    // BK Ok
    modifier onlyAdminOrOps() {
        // BK Ok
        require(isAdmin(msg.sender) || isOps(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok
    modifier onlyOwnerOrAdmin() {
        // BK Ok
        require(isOwner(msg.sender) || isAdmin(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok
    modifier onlyOps() {
        // BK Ok
        require(isOps(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok - View function
    function isAdmin(address _address) internal view returns (bool) {
        // BK Ok
        return (adminAddress != address(0) && _address == adminAddress);
    }


    // BK Ok - View function
    function isOps(address _address) internal view returns (bool) {
        // BK Ok
        return (opsAddress != address(0) && _address == opsAddress);
    }


    // BK Ok - View function
    function isOwnerOrOps(address _address) internal view returns (bool) {
        // BK Ok
        return (isOwner(_address) || isOps(_address));
    }


    // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
    // BK Ok - Only owner or admin can execute
    function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
        // BK Ok
        require(_adminAddress != owner);
        // BK Ok
        require(_adminAddress != address(this));
        // BK Ok
        require(!isOps(_adminAddress));

        // BK Ok
        adminAddress = _adminAddress;

        // BK Ok - Log event
        AdminAddressChanged(_adminAddress);

        // BK Ok
        return true;
    }


    // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
    // BK Ok - Only owner or admin can execute
    function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
        // BK Ok
        require(_opsAddress != owner);
        // BK Ok
        require(_opsAddress != address(this));
        // BK Ok
        require(!isAdmin(_opsAddress));

        // BK Ok
        opsAddress = _opsAddress;

        // BK Ok - Log event
        OpsAddressChanged(_opsAddress);

        // BK Ok
        return true;
    }
}



```
