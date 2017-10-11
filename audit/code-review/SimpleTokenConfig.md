# SimpleTokenConfig

Source file [../../contracts/SimpleTokenConfig.sol](../../contracts/SimpleTokenConfig.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

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

    // BK Next 3 Ok
    string  public constant TOKEN_SYMBOL   = "ST";
    string  public constant TOKEN_NAME     = "Simple Token";
    uint8   public constant TOKEN_DECIMALS = 18;

    // BK Next 2 Ok
    uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
    uint256 public constant TOKENS_MAX     = 800000000 * DECIMALSFACTOR;
}

```
