# ERC20Interface

Source file [../../contracts/ERC20Interface.sol](../../contracts/ERC20Interface.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// ----------------------------------------------------------------------------
// Simple Token Standard ERC20 Interface
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK NOTE - Final standard at https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
// Original ERC20 Standard Interface as specified at:
// https://github.com/ethereum/EIPs/issues/20
// ----------------------------------------------------------------------------

// BK Ok
contract ERC20Interface {

    // BK Ok
    uint256 public totalSupply;

    // BK Ok
    function balanceOf(address _owner) constant returns (uint256 balance);
    // BK Ok
    function transfer(address _to, uint256 _value) returns (bool success);
    // BK Ok
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    // BK Ok
    function approve(address _spender, uint256 _value) returns (bool success);
    // BK Ok
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    // BK Ok - Event
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // BK Ok - Event
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

```
