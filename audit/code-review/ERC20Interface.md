# ERC20Interface

Source file [../../contracts/ERC20Interface.sol](../../contracts/ERC20Interface.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token Standard ERC20 Interface
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Based on the 'final' ERC20 token standard as specified at:
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------

// BK Ok
contract ERC20Interface {

    // BK Ok - Event
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // BK Ok - Event
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // BK Ok
    function name() public view returns (string);
    // BK Ok
    function symbol() public view returns (string);
    // BK Ok
    function decimals() public view returns (uint8);
    // BK Ok
    function totalSupply() public view returns (uint256);

    // BK Ok
    function balanceOf(address _owner) public view returns (uint256 balance);
    // BK Ok
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // BK Ok
    function transfer(address _to, uint256 _value) public returns (bool success);
    // BK Ok
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    // BK Ok
    function approve(address _spender, uint256 _value) public returns (bool success);
}

```
