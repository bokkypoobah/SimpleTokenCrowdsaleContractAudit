# Pausable

Source file [../../contracts/OpenZepplin/Pausable.sol](../../contracts/OpenZepplin/Pausable.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;


// BK Ok
import "./Ownable.sol";


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
// BK Ok
contract Pausable is Ownable {

  // BK Next 2 Ok
  event Pause();
  event Unpause();

  // BK Ok
  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  // BK Ok
  modifier whenNotPaused() {
    // BK Ok
    require(!paused);
    // BK Ok
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  // BK Ok
  modifier whenPaused() {
    // BK Ok
    require(paused);
    // BK Ok
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  // BK Ok - Only owner can execute
  function pause() public onlyOwner whenNotPaused {
    // BK Ok
    paused = true;
    // BK Ok - Log event
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  // BK Ok - Only owner can execute
  function unpause() public onlyOwner whenPaused {
    // BK Ok
    paused = false;
    // BK Ok - Log event
    Unpause();
  }
}

```
