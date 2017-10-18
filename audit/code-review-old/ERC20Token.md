# ERC20Token

Source file [../../contracts/ERC20Token.sol](../../contracts/ERC20Token.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// ----------------------------------------------------------------------------
// Simple Token - Standard ERC20 Token Implementation
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Ok
import "./ERC20Interface.sol";

// BK Next 2 Ok
import "./OpenZepplin/Ownable.sol";
import "./OpenZepplin/SafeMath.sol";


//
// Standard ERC20 implementation, with ownership.
//
// BK Ok
contract ERC20Token is ERC20Interface, Ownable {

    // BK Ok
    using SafeMath for uint256;

    // BK Next 3 Ok
    string public symbol;
    string public name;
    uint8  public decimals;

    // BK Next 2 Ok
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;


    // BK Ok - Constructor
    function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply)
        Ownable()
    {
        // BK Next 3 Ok
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
        // BK Next 2 Ok
        totalSupply = _totalSupply;
        balances[owner] = _totalSupply;
        // BK NOTE - New finalised ERC20 - `A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created`
    }


    // BK Ok - Constant function
    function balanceOf(address _owner) constant returns (uint256 balance) {
        // BK Ok
        return balances[_owner];
    }


    // BK Ok
    function transfer(address _to, uint256 _value) returns (bool success) {
        // BK NOTE - New finalised ERC20 - `Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.`
        // BK NOTE - The following check can be removed as the .sub(...) and .add(...) will enforce the necessary checks
        if (_value == 0 || balances[msg.sender]  < _value || (balances[_to] + _value <= balances[_to])) {
           return false;
        }

        // BK Ok
        balances[msg.sender] = balances[msg.sender].sub(_value);
        // BK Ok
        balances[_to] = balances[_to].add(_value);

        // BK Ok - Log event
        Transfer(msg.sender, _to, _value);

        // BK Ok
        return true;
    }


    // BK Ok
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        // BK NOTE - New finalised ERC20 - `Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.`
        // BK NOTE - The following check can be removed as the .sub(...) and .add(...) will enforce the necessary checks
        if (_value == 0 || balances[_from] < _value || (balances[_to] + _value <= balances[_to])) {
           return false;
        }

        // BK NOTE - The following check can be removed as the .sub(...) and .add(...) will enforce the necessary checks
        if (_value > allowed[_from][msg.sender]) {
           return false;
        }

        // BK Ok
        balances[_from] = balances[_from].sub(_value);
        // BK Ok
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        // BK Ok
        balances[_to] = balances[_to].add(_value);

        // BK Ok - Log event
        Transfer(_from, _to, _value);

        // BK Ok
        return true;
     }


     // BK Ok - Constant function
     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
         // BK Ok
         return allowed[_owner][_spender];
     }

     // BK Ok
     function approve(address _spender, uint256 _value) returns (bool success) {

         // Guard for potential race condition
         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
         // BK NOTE - See the comment in https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
         // BK NOTE - > THOUGH The contract itself shouldn't enforce it
         if (_value > 0 && allowed[msg.sender][_spender] > 0) {
            return false;
         }

         // BK Ok
         allowed[msg.sender][_spender] = _value;

         // BK Ok
         Approval(msg.sender, _spender, _value);

         // BK Ok
         return true;
     }
}

```
