# SimpleToken

Source file [../../contracts/SimpleToken.sol](../../contracts/SimpleToken.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token Contract
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Next 3 Ok
import "./ERC20Token.sol";
import "./SimpleTokenConfig.sol";
import "./OpsManaged.sol";


//
// SimpleToken is a standard ERC20 token with some additional functionality:
// - It has a concept of finalize
// - Before finalize, nobody can transfer tokens except:
//     - Owner and operations can transfer tokens
//     - Anybody can send back tokens to owner
// - After finalize, no restrictions on token transfers
//

//
// Permissions, according to the ST key management specification.
//
//                                    Owner    Admin   Ops
// transfer (before finalize)           x               x
// transferForm (before finalize)       x               x
// finalize                                      x
//

// BK Ok
contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig {

    // BK Ok
    bool public finalized;


    // Events
    // BK Ok - Event
    event Finalized();


    // BK Ok - Constructor
    function SimpleToken() public
        ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX)
        OpsManaged()
    {
        // BK Ok
        finalized = false;
    }


    // Implementation of the standard transfer method that takes into account the finalize flag.
    // BK Ok
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // BK Ok
        checkTransferAllowed(msg.sender, _to);

        // BK Ok
        return super.transfer(_to, _value);
    }


    // Implementation of the standard transferFrom method that takes into account the finalize flag.
    // BK Ok
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // BK Ok
        checkTransferAllowed(msg.sender, _to);

        // BK Ok
        return super.transferFrom(_from, _to, _value);
    }


    // BK Ok - Private
    function checkTransferAllowed(address _sender, address _to) private view {
        // BK Ok
        if (finalized) {
            // Everybody should be ok to transfer once the token is finalized.
            // BK Ok
            return;
        }

        // Owner and Ops are allowed to transfer tokens before the sale is finalized.
        // This allows the tokens to move from the TokenSale contract to a beneficiary.
        // We also allow someone to send tokens back to the owner. This is useful among other
        // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
        // BK Ok
        require(isOwnerOrOps(_sender) || _to == owner);
    }


    // Finalize method marks the point where token transfers are finally allowed for everybody.
    // BK Ok - Only admin can execute
    function finalize() external onlyAdmin returns (bool success) {
        // BK Ok
        require(!finalized);

        // BK Ok
        finalized = true;

        // BK Ok - Log event
        Finalized();

        // BK Ok
        return true;
    }
}

```
