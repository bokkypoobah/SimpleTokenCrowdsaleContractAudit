pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Token Sale Configuration
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


import "./SimpleTokenConfig.sol";


contract TokenSaleConfig is SimpleTokenConfig {

    uint256 public constant PHASE1_START_TIME         = 1508987805; // Thu 26 Oct 2017 03:16:45 UTC
    uint256 public constant PHASE2_START_TIME         = 1508987835; // Thu 26 Oct 2017 03:17:15 UTC
    uint256 public constant END_TIME                  = 1508987895; // Thu 26 Oct 2017 03:18:15 UTC
    uint256 public constant CONTRIBUTION_MIN          = 0.1 ether;
    uint256 public constant CONTRIBUTION_MAX          = 100000.0 ether;

    // This is the maximum number of tokens each individual account is allowed to
    // buy during Phase 1 of the token sale (whitelisted phase)
    // Calculated based on 300 USD/ETH * 10 ETH / 0.1667 USD / token = ~17,996
    uint256 public constant PHASE1_ACCOUNT_TOKENS_MAX = 18000     * DECIMALSFACTOR;

    uint256 public constant TOKENS_SALE               = 240000000 * DECIMALSFACTOR;
    uint256 public constant TOKENS_FOUNDERS           = 80000000  * DECIMALSFACTOR;
    uint256 public constant TOKENS_ADVISORS           = 80000000  * DECIMALSFACTOR;
    uint256 public constant TOKENS_EARLY_INVESTORS    = 22441966  * DECIMALSFACTOR;
    uint256 public constant TOKENS_ACCELERATOR_MAX    = 257558034 * DECIMALSFACTOR;
    uint256 public constant TOKENS_FUTURE             = 120000000 * DECIMALSFACTOR;

    // We use a default for when the contract is deployed but this can be changed afterwards
    // by calling the setTokensPerKEther function
    // For the public sale, tokens are priced at 0.1667 USD/token.
    // So if we have 300 USD/ETH -> 300,000 USD/KETH / 0.1667 USD/token = ~1,799,640
    uint256 public constant TOKENS_PER_KETHER         = 1800000;
}