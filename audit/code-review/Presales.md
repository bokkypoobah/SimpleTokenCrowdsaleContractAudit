# Presales

Source file [../../contracts/Presales.sol](../../contracts/Presales.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Presales for TokenSale
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Ok
import "./Owned.sol";

/**
   @title TokenSaleInterface
   @dev Provides interface for calling TokenSale.adminAddress and TokenSale.addPresale
*/
// BK Ok
contract TokenSaleInterface {
    // BK Next 3 Ok
    function setAdminAddress(address _adminAddress) external returns (bool);
    function adminAddress() public view returns (address);
    function addPresale(address _account, uint256 _baseTokens, uint256 _bonusTokens) external returns (bool);
}

/*
   @title Presales
   @notice Presales to be added to TokenSale
*/
// BK Ok
contract Presales is Owned {

	// mapping of all presales
	// BK Ok
	mapping(address => Presale) public presales;

	// array of addresses of all accounts
    // BK Ok
	address[] public accounts;

	// status of presales
    // BK Ok
	Status public status;

	// TokenSale contract
    // BK Ok
	TokenSaleInterface public tokenSale;

	// TokenSale admin
    // BK Ok
	address public tokenSaleAdmin;

	// Maximum accounts to avoid hitting the block gas limit in Presales.process
    // BK Ok
	uint8 public constant MAX_ACCOUNTS = 35;

	// enum presales status
	//   Unlocked  - unlocked and unadded
	//   Locked    - locked and unadded
	//   Completed - locked and completed
    // BK Ok
	enum Status { Unlocked, Locked, Completed }

	// struct Presale
    // BK Following block Ok
	struct Presale {
		uint256 baseTokens;
		uint256 bonusTokens;
	}

	// events
	// BK Next 3 Ok
	event PresaleAdded(address indexed _account, uint256 _baseTokens, uint256 _bonusTokens);
	event PresaleAddedToTokenSale(address indexed _account, uint256 _baseTokens, uint256 _bonusTokens);
	event Locked();

    /**
       @dev Constructor
       @param _tokenSale TokenSale contract
    */
    // BK Ok - Constructor
	function Presales(TokenSaleInterface _tokenSale)
			 Owned()
			 public
	{
	    // BK Ok
		require(address(_tokenSale) != address(0));

        // BK Ok
		tokenSale = _tokenSale;
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
       @dev Adds a presale
       @param _account account
       @param _baseTokens base tokens of tokens
       @param _bonusTokens base tokens of tokens
    */
    // BK Ok - Only owner can execute
	function addPresale(address _account, uint256 _baseTokens, uint256 _bonusTokens) public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Next 4 Ok
		require(_account != address(0));
        require(_baseTokens > 0);
        require(_bonusTokens < _baseTokens);
        require(accounts.length < MAX_ACCOUNTS);

        // BK Ok
		Presale storage presale = presales[_account];

        // BK Ok
		require(presale.baseTokens == 0);
		
		// BK Next 3 Ok
		presale.baseTokens = _baseTokens;
		presale.bonusTokens = _bonusTokens;
		accounts.push(_account);

        // BK Ok - Log event
		PresaleAdded(_account, _baseTokens, _bonusTokens);

        // BK Ok
		return true;
	}

    /**
       @dev Returns addresses of accounts
    */
    // BK Ok - View function
	function getAccounts() public view returns (address[]) {
	    // BK Ok
		return accounts;
	}

    /**
       @dev Returns number of accounts
    */
    // BK Ok - View function
	function getAccountsSize() public view returns (uint256) {
	    // BK Ok
		return accounts.length;
	}

    /**
       @dev Sets status to Locked so that no new presales can be added
    */
    // BK Ok - Only owner can execute
	function lock() public onlyOwner onlyIfUnlocked returns (bool) {
	    // BK Ok
		require(accounts.length > 0);

        // BK Ok
		status = Status.Locked;

		// on locking the presales the owner is transferred
		// to admin of TokenSale contract
		// Store admin to revert after presales are added
		// BK Ok
		tokenSaleAdmin = tokenSale.adminAddress();
		// BK Ok
		initiateOwnershipTransfer(tokenSaleAdmin);

        // BK Ok - Log event
		Locked();

        // BK Ok
		return true;
	}

    /**
       @dev Submits presales to TokenSale for adding
       if locked (which implies that it has not previously been added)
    */
    // BK Ok - Only owner can execute
	function process() public onlyOwner onlyIfLocked returns (bool) {
		// Confirm that admin address for TokenSale has been changed
		// BK Ok
		require(tokenSale.adminAddress() == address(this));

        // BK Ok
		for (uint256 i = 0; i < accounts.length; i++) {
		    // BK Ok
			Presale storage presale = presales[accounts[i]];

			// TokenSale.addPresale (and Trustee.grantAllocation) throws;
			// false is not returned
			// BK Ok
			require(tokenSale.addPresale(accounts[i], presale.baseTokens, presale.bonusTokens));

            // BK Ok = Log event
			PresaleAddedToTokenSale(accounts[i], presale.baseTokens, presale.bonusTokens);
		}

		// Revert admin address
		// BK Ok
		tokenSale.setAdminAddress(tokenSaleAdmin);

        // BK Ok
		status = Status.Completed;

        // BK Ok
		return true;
	}
}
```
