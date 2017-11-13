# ProcessableAllocations

Source file [../../contracts/ProcessableAllocations.sol](../../contracts/ProcessableAllocations.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Processable Allocations for Trustee
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
   @dev Provides interface for calling Trustee.adminAddress and Trustee.processAllocation
*/
// BK Ok
contract TrusteeInterface {
    // BK Ok
    function adminAddress() public view returns (address);
    // BK Ok
    function processAllocation(address _grantee, uint256 _amount) external returns (bool);
}

/*
   @title ProcessableAllocations
   @notice Allocations to be processed by Trustee
*/
// BK Ok
contract ProcessableAllocations is Owned {

	// mapping of all processable allocations
	// BK Ok
	mapping(address => ProcessableAllocation) public processableAllocations;

	// array of addresses of all grantees
	// BK Ok
	address[] public grantees;

	// status of processable allocations
	// BK Ok
	Status public status;

	// Trustee contract
	// BK Ok
	TrusteeInterface trusteeContract;

	// Maximum accounts to avoid hitting the block gas limit in
	// ProcessableAllocations.processProcessableAllocations
	// BK Ok
	uint8 public constant MAX_GRANTEES = 35;

	// enum processableAllocations status
	//   Unlocked  - unlocked and unprocessed
	//   Locked    - locked and unprocessed
	//   Processed - locked and processed
	//   Failed    - locked and processed with failure
	// BK Ok
	enum Status { Unlocked, Locked, Processed, Failed }

	// struct ProcessableAllocation
	// BK Ok
	struct ProcessableAllocation {
	    // BK Ok
		uint256 amount;
		// processing status :
		//   0 - unprocessed
		//   1 - successfully processed
		//  -1 - failed to process
		// BK Ok
		int8    processingStatus;
	}

	// events
	// BK Next 3 Ok - Events
	event ProcessableAllocationAdded(address indexed _grantee, uint256 _amount);
	event ProcessableAllocationProcessed(address indexed _grantee, uint256 _amount,
		bool _processingStatus);
	event Locked();

    /**
       @dev Constructor
       @param _trusteeContract Trustee contract
    */
    // BK Ok - Constructor
	function ProcessableAllocations(TrusteeInterface _trusteeContract)
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
       @dev Adds a processable allocation
       @param _grantee grantee
       @param _amount amount of tokens
    */
    // BK Ok - Only owner can execute
	function addProcessableAllocation(address _grantee, uint256 _amount) public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Ok
		require(_grantee != address(0));
		// BK Ok
		require(_amount > 0);
		// BK Ok
        require(grantees.length < MAX_GRANTEES);

        // BK Ok
		ProcessableAllocation storage allocation = processableAllocations[_grantee];

        // BK Ok
		require(allocation.amount == 0);
		
		// BK Ok
		allocation.amount = _amount;
		// BK Ok
		grantees.push(_grantee);

        // BK Ok - Log event
		ProcessableAllocationAdded(_grantee, _amount);

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
       @dev Sets status to Locked so that no new processable allocations can be added
    */
    // BK Ok - Only owner can execute
	function lock() public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Ok
		require(grantees.length > 0);

        // BK Ok
		status = Status.Locked;

		// on locking the processable allocations the owner is transferred
		// to admin of trustee contract
		// BK Ok
		initiateOwnershipTransfer(trusteeContract.adminAddress());

        // BK Ok - Log event
		Locked();

        // BK Ok
		return true;
	}

    /**
       @dev Submits processable allocations to Trustee for processing
       if locked (which implies that it has not previously been processed)
    */
    // BK Ok - Only owner can execute
	function processProcessableAllocations() public onlyOwner onlyIfLocked returns (bool) {
	    // BK NOTE - Can run out of gas if the array is too large
	    // BK Ok
		for (uint256 i = 0; i < grantees.length; i++) {
		    // BK Ok
			ProcessableAllocation storage allocation = processableAllocations[grantees[i]];
			
			// BK Ok
			require(allocation.processingStatus == 0);
			
			// BK Ok
			bool ok = trusteeContract.processAllocation(grantees[i], allocation.amount);
			// BK Ok
			allocation.processingStatus = (ok) ? int8(1) : -1;
			// BK Ok
			if (!ok) status = Status.Failed;

            // BK - Log event
			ProcessableAllocationProcessed(grantees[i], allocation.amount, ok);
		}

        // BK Ok
		if (status != Status.Failed) {
		    // BK Ok
			status = Status.Processed;
			// BK Ok
			return true;
		// BK Ok
		} else {
		    // BK Ok
			return false;
		}
	}
}
```
