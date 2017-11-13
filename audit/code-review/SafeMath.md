# SafeMath

Source file [../../contracts/SafeMath.sol](../../contracts/SafeMath.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// SafeMath Library Implementation
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
//
// Based on the SafeMath library by the OpenZeppelin team.
// Copyright (c) 2016 Smart Contract Solutions, Inc.
// https://github.com/OpenZeppelin/zeppelin-solidity
// The MIT License.
// ----------------------------------------------------------------------------


// BK Ok
library SafeMath {

    // BK Ok
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // BK Ok
        uint256 c = a * b;

        // BK Ok
        assert(a == 0 || c / a == b);

        // BK Ok
        return c;
    }


    // BK Ok
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity automatically throws when dividing by 0
        // BK Ok
        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        // BK Ok
        return c;
    }


    // BK Ok
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        // BK Ok
        assert(b <= a);

        // BK Ok
        return a - b;
    }


    // BK Ok
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        // BK Ok
        uint256 c = a + b;

        // BK Ok
        assert(c >= a);

        // BK Ok
        return c;
    }
}

```
