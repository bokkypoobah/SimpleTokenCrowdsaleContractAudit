# Pausable

Source file [../../contracts/Pausable.sol](../../contracts/Pausable.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Pausable Contract Implementation
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
//
// Based on the Pausable contract by the OpenZeppelin team.
// Copyright (c) 2016 Smart Contract Solutions, Inc.
// https://github.com/OpenZeppelin/zeppelin-solidity
// The MIT License.
// ----------------------------------------------------------------------------


// BK Ok
import "./OpsManaged.sol";


// BK Ok
contract Pausable is OpsManaged {

  // BK Next 2 Ok - Events
  event Pause();
  event Unpause();

  // BK Ok
  bool public paused = false;


  // BK Ok
  modifier whenNotPaused() {
    // BK Ok
    require(!paused);
    // BK Ok
    _;
  }


  // BK Ok
  modifier whenPaused() {
    // BK Ok
    require(paused);
    // BK Ok
    _;
  }


  // BK Ok - Only the admin can execute
  function pause() public onlyAdmin whenNotPaused {
    // BK Ok
    paused = true;

    // BK Ok - Log event
    Pause();
  }


  // BK Ok - Only the admin can execute
  function unpause() public onlyAdmin whenPaused {
    // BK Ok
    paused = false;

    // BK Ok - Log event
    Unpause();
  }
}

```
