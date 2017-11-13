# Trustee

Source file [../../contracts/Trustee.sol](../../contracts/Trustee.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Token Trustee Implementation
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Next 2 Ok
import './SimpleToken.sol';
import './OpsManaged.sol';

// BK Ok
import './SafeMath.sol';


//
// Implements a simple trustee which can release tokens based on
// an explicit call from the owner.
//

//
// Permissions, according to the ST key management specification.
//
//                                Owner    Admin   Ops   Revoke
// grantAllocation                           x      x
// revokeAllocation                                        x
// processAllocation                                x
// reclaimTokens                             x
// setRevokeAddress                 x                      x
//

// BK Ok
contract Trustee is OpsManaged {

    // BK Ok
    using SafeMath for uint256;


    // BK Ok
    SimpleToken public tokenContract;

    // BK Next block Ok
    struct Allocation {
        uint256 amountGranted;
        uint256 amountTransferred;
        bool    revokable;
    }

    // The trustee has a special 'revoke' key which is allowed to revoke allocations.
    // BK Ok
    address public revokeAddress;

    // Total number of tokens that are currently allocated.
    // This does not include tokens that have been processed (sent to an address) already or
    // the ones in the trustee's account that have not been allocated yet.
    // BK Ok
    uint256 public totalLocked;

    // BK Ok
    mapping (address => Allocation) public allocations;


    //
    // Events
    //
    // BK Next 5 Ok
    event AllocationGranted(address indexed _from, address indexed _account, uint256 _amount, bool _revokable);
    event AllocationRevoked(address indexed _from, address indexed _account, uint256 _amountRevoked);
    event AllocationProcessed(address indexed _from, address indexed _account, uint256 _amount);
    event RevokeAddressChanged(address indexed _newAddress);
    event TokensReclaimed(uint256 _amount);


    // BK Ok - Constructor
    function Trustee(SimpleToken _tokenContract) public
        OpsManaged()
    {
        // BK Ok
        require(address(_tokenContract) != address(0));

        // BK Ok
        tokenContract = _tokenContract;
    }


    // BK Ok
    modifier onlyOwnerOrRevoke() {
        // BK Ok
        require(isOwner(msg.sender) || isRevoke(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok
    modifier onlyRevoke() {
        // BK Ok
        require(isRevoke(msg.sender));
        // BK Ok
        _;
    }


    // BK Ok - Private
    function isRevoke(address _address) private view returns (bool) {
        // BK Ok
        return (revokeAddress != address(0) && _address == revokeAddress);
    }


    // Owner and revoke can change the revoke address. Address can also be set to 0 to 'disable' it.
    // BK Ok - Only owner or revoke account can execute
    function setRevokeAddress(address _revokeAddress) external onlyOwnerOrRevoke returns (bool) {
        // BK Next 3 Ok
        require(_revokeAddress != owner);
        require(!isAdmin(_revokeAddress));
        require(!isOps(_revokeAddress));

        // BK Ok
        revokeAddress = _revokeAddress;

        // BK Ok - Log event
        RevokeAddressChanged(_revokeAddress);

        // BK Ok
        return true;
    }


    // Allows admin or ops to create new allocations for a specific account.
    // BK Ok - Only admin or ops can execute
    function grantAllocation(address _account, uint256 _amount, bool _revokable) public onlyAdminOrOps returns (bool) {
        // BK Next 3 Ok
        require(_account != address(0));
        require(_account != address(this));
        require(_amount > 0);

        // Can't create an allocation if there is already one for this account.
        // BK Ok
        require(allocations[_account].amountGranted == 0);

        // BK Ok - But admin can execute
        if (isOps(msg.sender)) {
            // Once the token contract is finalized, the ops key should not be able to grant allocations any longer.
            // Before finalized, it is used by the TokenSale contract to allocate pre-sales.
            // BK Ok
            require(!tokenContract.finalized());
        }

        // BK Ok
        totalLocked = totalLocked.add(_amount);
        // BK Ok
        require(totalLocked <= tokenContract.balanceOf(address(this)));

        // BK Next block Ok
        allocations[_account] = Allocation({
            amountGranted     : _amount,
            amountTransferred : 0,
            revokable         : _revokable
        });

        // BK Ok - Log event
        AllocationGranted(msg.sender, _account, _amount, _revokable);

        // BK Ok
        return true;
    }


    // Allows the revoke key to revoke allocations, if revoke is allowed.
    // BK Ok - Only revoke account can execute this
    function revokeAllocation(address _account) external onlyRevoke returns (bool) {
        // BK Ok
        require(_account != address(0));

        // BK Ok
        Allocation memory allocation = allocations[_account];

        // BK Ok
        require(allocation.revokable);

        // BK Ok
        uint256 ownerRefund = allocation.amountGranted.sub(allocation.amountTransferred);

        // BK Ok
        delete allocations[_account];

        // BK Ok
        totalLocked = totalLocked.sub(ownerRefund);

        // BK Ok - Log event
        AllocationRevoked(msg.sender, _account, ownerRefund);

        // BK Ok
        return true;
    }


    // Push model which allows ops to transfer tokens to the beneficiary.
    // The exact amount to transfer is calculated based on agreements with
    // the beneficiaries. Here we only restrict that the total amount transfered cannot
    // exceed what has been granted.
    // BK Ok - Only ops can execute
    function processAllocation(address _account, uint256 _amount) external onlyOps returns (bool) {
        // BK Next 2 Ok
        require(_account != address(0));
        require(_amount > 0);

        // BK Ok
        Allocation storage allocation = allocations[_account];

        // BK Ok
        require(allocation.amountGranted > 0);

        // BK Ok
        uint256 transferable = allocation.amountGranted.sub(allocation.amountTransferred);

        // BK Ok
        if (transferable < _amount) {
            // BK Ok
            return false;
        }

        // BK Ok
        allocation.amountTransferred = allocation.amountTransferred.add(_amount);

        // Note that transfer will fail if the token contract has not been finalized yet.
        // BK Ok
        require(tokenContract.transfer(_account, _amount));

        // BK Ok
        totalLocked = totalLocked.sub(_amount);

        // BK Ok - Log event
        AllocationProcessed(msg.sender, _account, _amount);

        // BK Ok
        return true;
    }


    // Allows the admin to claim back all tokens that are not currently allocated.
    // Note that the trustee should be able to move tokens even before the token is
    // finalized because SimpleToken allows sending back to owner specifically.
    // BK Ok - Only admin can execute
    function reclaimTokens() external onlyAdmin returns (bool) {
        // BK Ok
        uint256 ownBalance = tokenContract.balanceOf(address(this));

        // If balance <= amount locked, there is nothing to reclaim.
        // BK Ok
        require(ownBalance > totalLocked);

        // BK Ok
        uint256 amountReclaimed = ownBalance.sub(totalLocked);

        // BK Next 2 Ok
        address tokenOwner = tokenContract.owner();
        require(tokenOwner != address(0));

        // BK Ok
        require(tokenContract.transfer(tokenOwner, amountReclaimed));

        // BK Ok - Log event
        TokensReclaimed(amountReclaimed);

        // BK Ok
        return true;
    }
}

```
