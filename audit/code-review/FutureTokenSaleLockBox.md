# FutureTokenSaleLockBox

Source file [../../contracts/FutureTokenSaleLockBox.sol](../../contracts/FutureTokenSaleLockBox.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Future Token Sale Lock Box
//
// Copyright (c) 2017 Simple Token.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Next 2 Ok
import "./SafeMath.sol";
import "./Owned.sol";

/**
   @title TokenSaleInterface
   @dev Provides interface for calling TokenSale.endTime
*/
// BK Ok
contract TokenSaleInterface {
    // BK Ok
    function endTime() public view returns (uint256);
}

/**
   @title TokenInterface
   @dev Provides interface for calling SimpleToken.transfer
*/
// BK Ok
contract TokenInterface {
    // BK Ok
    function transfer(address _to, uint256 _value) public returns (bool);
}

/**
   @title FutureTokenSaleLockBox
   @notice Holds tokens reserved for future token sales. Tokens cannot be transferred for at least six months.
*/
// BK Ok
contract FutureTokenSaleLockBox is Owned {
    // BK Ok
    using SafeMath for uint256;

    // To enable transfers of tokens held by this contract
    // BK Ok
    TokenInterface public simpleToken;

    // To determine earliest unlock date (six months) after which tokens held by this contract can be transferred
    // BK Ok
    TokenSaleInterface public tokenSale;

    // The unlock date is initially six months after tokenSale.endTime, but may be extended
    // BK Ok
    uint256 public unlockDate;

    // BK Next 2 OK - Events
    event UnlockDateExtended(uint256 _newDate);
    event TokensTransferred(address indexed _to, uint256 _value);

    /**
       @dev Constructor
       @param _simpleToken SimpleToken contract
       @param _tokenSale TokenSale contract
    */
    // BK Ok - Constructor
    function FutureTokenSaleLockBox(TokenInterface _simpleToken, TokenSaleInterface _tokenSale)
             Owned()
             public
    {
        // BK Next 2 Ok
        require(address(_simpleToken) != address(0));
        require(address(_tokenSale)   != address(0));

        // BK Ok
        simpleToken = _simpleToken;
        // BK Ok
        tokenSale   = _tokenSale;
        // BK Ok
        uint256 endTime = tokenSale.endTime();

        // BK Ok
        require(endTime > 0);

        // BK Ok
        unlockDate  = endTime.add(26 weeks);
    }

    /**
       @dev Limits execution to after unlock date
    */
    // BK Ok
    modifier onlyAfterUnlockDate() {
        // BK Ok
        require(hasUnlockDatePassed() == true);
        // BK Ok
        _;
    }

    /**
       @dev Provides current time
    */
    // BK Ok - View function
    function currentTime() public view returns (uint256) {
        // BK Ok
        return now;
    }

    /**
       @dev Determines whether unlock date has passed
    */
    // BK Ok - View function
    function hasUnlockDatePassed() public view returns (bool) {
        // BK Ok
        return currentTime() >= unlockDate;
    }

    /**
       @dev Extends unlock date
       @param _newDate new unlock date
    */
    // BK Ok - Only owner can execute
    function extendUnlockDate(uint256 _newDate) public onlyOwner returns (bool) {
        // BK Ok
        require(_newDate > unlockDate);

        // BK Ok
        unlockDate = _newDate;
        // BK Ok - Log event
        UnlockDateExtended(_newDate);

        // BK Ok
        return true;
    }

    /**
       @dev Transfers tokens held by this contract
       @param _to account to which to transfer tokens
       @param _value value of tokens to transfer
    */
    // BK Ok - Only owner can execute, after the unlock date
    function transfer(address _to, uint256 _value) public onlyOwner onlyAfterUnlockDate returns (bool) {
        // BK Ok
        require(simpleToken.transfer(_to, _value));

        // BK Ok - Log event
        TokensTransferred(_to, _value);

        // BK Ok
        return true;
    }
}

```
