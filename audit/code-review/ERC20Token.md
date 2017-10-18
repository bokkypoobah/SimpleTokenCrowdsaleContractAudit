# ERC20Token

Source file [../../contracts/ERC20Token.sol](../../contracts/ERC20Token.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Simple Token - Standard ERC20 Token Implementation
//
// Copyright (c) 2017 Simple Token and Enuma Technologies.
// http://www.simpletoken.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Next 3 Ok
import "./ERC20Interface.sol";
import "./Owned.sol";
import "./SafeMath.sol";


//
// Standard ERC20 implementation, with ownership.
//
// BK Ok
contract ERC20Token is ERC20Interface, Owned {

    // BK Ok
    using SafeMath for uint256;

    // BK Next 4 Ok
    string  private tokenName;
    string  private tokenSymbol;
    uint8   private tokenDecimals;
    uint256 private tokenTotalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;


    function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) public
        Owned()
    {
        tokenSymbol      = _symbol;
        tokenName        = _name;
        tokenDecimals    = _decimals;
        tokenTotalSupply = _totalSupply;
        balances[owner]  = _totalSupply;

        // According to the ERC20 standard, a token contract which creates new tokens should trigger
        // a Transfer event and transfers of 0 values must also fire the event.
        Transfer(0x0, owner, _totalSupply);
    }


    // BK Ok - View only
    function name() public view returns (string) {
        // BK Ok
        return tokenName;
    }


    // BK Ok - View only
    function symbol() public view returns (string) {
        // BK Ok
        return tokenSymbol;
    }


    // BK Ok - View only
    function decimals() public view returns (uint8) {
        // BK Ok
        return tokenDecimals;
    }


    // BK Ok - View only
    function totalSupply() public view returns (uint256) {
        // BK Ok
        return tokenTotalSupply;
    }


    // BK Ok - View only
    function balanceOf(address _owner) public view returns (uint256) {
        // BK Ok
        return balances[_owner];
    }


    // BK Ok - View only
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        // BK Ok
        return allowed[_owner][_spender];
    }


    // BK Ok
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // According to the EIP20 spec, "transfers of 0 values MUST be treated as normal
        // transfers and fire the Transfer event".
        // Also, should throw if not enough balance. This is taken care of by SafeMath.
        // BK NOTE - Can save gas after Byzantium changes with the statement `require(balances[msg.sender] >= _value);`
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
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // BK NOTE - Can save gas after Byzantium change with the statement `require(balances[_from] >= _value);`
        // BK NOTE - and `require(allowed[_from][msg.sender] >= _value);`
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


    // BK Ok
    function approve(address _spender, uint256 _value) public returns (bool success) {

        // BK Ok
        allowed[msg.sender][_spender] = _value;

        // BK Ok - Log event
        Approval(msg.sender, _spender, _value);

        // BK Ok
        return true;
    }
}

```
