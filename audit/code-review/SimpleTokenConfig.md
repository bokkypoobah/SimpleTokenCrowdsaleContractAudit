# SimpleTokenConfig

Source file [../../contracts/SimpleTokenConfig.sol](../../contracts/SimpleTokenConfig.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Token Configuration
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Ok
contract SimpleTokenConfig {

    // BK Ok
    string  public constant TOKEN_SYMBOL   = "ST";
    // BK Ok
    string  public constant TOKEN_NAME     = "Simple Token";
    // BK Ok
    uint8   public constant TOKEN_DECIMALS = 18;

    // BK Ok
    uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
    // BK Ok
    uint256 public constant TOKENS_MAX     = 800000000 * DECIMALSFACTOR;
}

```
