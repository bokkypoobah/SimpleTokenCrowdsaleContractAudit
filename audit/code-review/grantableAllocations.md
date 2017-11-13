# grantableAllocations

Source file [../../contracts/grantableAllocations.sol](../../contracts/grantableAllocations.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Grantable Allocations for Trustee
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Ok
import "./Owned.sol";

/**
   @title TrusteeInterface
   @dev Provides interface for calling Trustee.adminAddress and Trustee.grantAllocation
*/
// BK Ok
contract TrusteeInterface {
    // BK Ok
    function setAdminAddress(address _adminAddress) external returns (bool);
    // BK Ok
    function adminAddress() public view returns (address);
    // BK Ok
    function grantAllocation(address _grantee, uint256 _amount, bool _revokable) external returns (bool);
}

/*
   @title GrantableAllocations
   @notice Allocations to be granted by Trustee
*/
// BK Ok
contract GrantableAllocations is Owned {

	// mapping of all gran allocations
	// BK Ok
	mapping(address => GrantableAllocation) public grantableAllocations;

	// array of addresses of all grantees
	// BK Ok
	address[] public grantees;

	// status of grantable allocations
	// BK Ok
	Status public status;

	// Trustee contract
	// BK Ok
	TrusteeInterface trusteeContract;

	// Trustee admin
	// BK Ok
	address public trusteeAdmin;

	// Maximum accounts to avoid hitting the block gas limit in GrantableAllocations.grantGrantableAllocations
	// BK Ok
	uint8 public constant MAX_GRANTEES = 35;

	// enum grantableAllocations status
	//   Unlocked  - unlocked and unadded
	//   Locked    - locked and unadded
	//   Completed - locked and completed
	// BK Ok
	enum Status { Unlocked, Locked, Completed }

	// struct GrantableAllocation
	// BK Ok
	struct GrantableAllocation {
	    // BK Ok
		uint256 amount;
		// BK Ok
		bool    revokable;
	}

	// events
	// BK Next 3 Ok - Events
	event GrantableAllocationAdded(address indexed _grantee, uint256 _amount, bool _revokable);
	event GrantableAllocationGranted(address indexed _grantee, uint256 _amount, bool _revokable);
	event Locked();

    /**
       @dev Constructor
       @param _trusteeContract Trustee contract
    */
    // BK Ok - Constructor
	function GrantableAllocations(TrusteeInterface _trusteeContract)
			 Owned()
			 public
	{
	    // BK Ok
		require(address(_trusteeContract) != address(0));

        // BK Ok
		trusteeContract = _trusteeContract;
	}

    /**
       @dev Limits execution to when status is Unlocked
    */
    // BK Ok
	modifier onlyIfUnlocked() {
	    // BK Ok
		require(status == Status.Unlocked);
		// BK Ok
		_;
	}

    /**
       @dev Limits execution to when status is Locked
    */
    // BK Ok
	modifier onlyIfLocked() {
	    // BK Ok
		require(status == Status.Locked);
		// BK Ok
		_;
	}

    /**
       @dev Adds a grantable allocation
       @param _grantee grantee
       @param _amount amount of tokens
       @param _revokable revokable
    */
    // BK Ok - Only owner can execute
	function addGrantableAllocation(address _grantee, uint256 _amount, bool _revokable) public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Next 3 Ok
		require(_grantee != address(0));
		require(_amount > 0);
        require(grantees.length < MAX_GRANTEES);

        // BK Ok
		GrantableAllocation storage allocation = grantableAllocations[_grantee];

        // BK Ok
		require(allocation.amount == 0);
		
		// BK Ok
		allocation.amount = _amount;
		// BK Ok
		allocation.revokable = _revokable;
		// BK Ok
		grantees.push(_grantee);

        // BK Ok - Log event
		GrantableAllocationAdded(_grantee, _amount, _revokable);

        // BK Ok
		return true;
	}

    /**
       @dev Returns addresses of grantees
    */
    // BK Ok - View function
	function getGrantees() public view returns (address[]) {
	    // BK Ok
		return grantees;
	}

    /**
       @dev Returns number of grantees
    */
    // BK Ok - View function
	function getGranteesSize() public view returns (uint256) {
	    // BK Ok
		return grantees.length;
	}

    /**
       @dev Sets status to Locked so that no new grantable allocations can be added
    */
    // BK Ok
	function lock() public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Ok
		require(grantees.length > 0);

        // BK Ok
		status = Status.Locked;

		// on locking the grantable allocations the owner is transferred
		// to admin of trustee contract
		// Store admin to revert after grantable allocations are added
		// BK Ok
		trusteeAdmin = trusteeContract.adminAddress();
		// BK Ok
		initiateOwnershipTransfer(trusteeContract.adminAddress());

        // BK Ok - Log event
		Locked();

        // BK Ok
		return true;
	}

    /**
       @dev Submits grantable allocations to Trustee for granting
       if locked (which implies that it has not previously been granted)
    */
    // BK Ok - Only owner can execute
	function grantGrantableAllocations() public onlyOwner onlyIfLocked returns (bool) {
		// Confirm that admin address for Trustee has been changed
		// BK Ok
		require(trusteeContract.adminAddress() == address(this));

        // BK Ok
		for (uint256 i = 0; i < grantees.length; i++) {
		    // BK Ok
			GrantableAllocation storage allocation = grantableAllocations[grantees[i]];
			
			// Trustee.grantAllocation throws--false is not returned
			// BK Ok
			require(trusteeContract.grantAllocation(grantees[i], allocation.amount, allocation.revokable));

            // BK Ok - Log event
			GrantableAllocationGranted(grantees[i], allocation.amount, allocation.revokable);
		}

		// Revert admin address
		// BK Ok
		trusteeContract.setAdminAddress(trusteeAdmin);

        // BK Ok
		status = Status.Completed;

        // BK Ok
		return true;
	}
}
```
