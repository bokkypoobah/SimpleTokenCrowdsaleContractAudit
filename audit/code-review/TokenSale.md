# TokenSale

Source file [../../contracts/TokenSale.sol](../../contracts/TokenSale.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Token Sale Implementation
//
// Copyright (c) 2017 OpenST Ltd.
// https://simpletoken.org/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Next 6 Ok
import "./SimpleToken.sol";
import "./Trustee.sol";
import "./TokenSaleConfig.sol";
import "./OpsManaged.sol";
import "./Pausable.sol";
import "./SafeMath.sol";


//
// Implementation of the 1st token sale for Simple Token
//
// * Lifecycle *
// Initialization sequence should be as follow:
//    1. Deploy SimpleToken contract
//    2. Deploy Trustee contract
//    3. Deploy TokenSale contract
//    4. Set operationsAddress of SimpleToken contract to TokenSale contract
//    5. Set operationsAddress of Trustee contract to TokenSale contract
//    6. Set operationsAddress of TokenSale contract to some address
//    7. Transfer tokens from owner to TokenSale contract
//    8. Transfer tokens from owner to Trustee contract
//    9. Initialize TokenSale contract
//
// Pre-sale sequence:
//    - Set tokensPerKEther
//    - Set phase1AccountTokensMax
//    - Add presales
//    - Add allocations for founders, advisors, etc.
//    - Update whitelist
//
// After-sale sequence:
//    1. Finalize the TokenSale contract
//    2. Finalize the SimpleToken contract
//    3. Set operationsAddress of TokenSale contract to 0
//    4. Set operationsAddress of SimpleToken contract to 0
//    5. Set operationsAddress of Trustee contract to some address
//
// Anytime
//    - Add/Remove allocations
//

//
// Permissions, according to the ST key management specification.
//
//                                Owner    Admin   Ops
// initialize                       x
// changeWallet                              x
// updateWhitelist                                  x
// setTokensPerKEther                        x
// setPhase1AccountTokensMax                 x
// addPresale                                x
// pause / unpause                           x
// reclaimTokens                             x
// finalize                                  x
//

// BK Ok
contract TokenSale is OpsManaged, Pausable, TokenSaleConfig { // Pausable is also Owned

    // BK Ok
    using SafeMath for uint256;

    // We keep track of whether the sale has been finalized, at which point
    // no additional contributions will be permitted.
    // BK Ok
    bool public finalized;

    // The sale end time is initially defined by the END_TIME constant but it
    // may get extended if the sale is paused.
    // BK Ok
    uint256 public endTime;
    // BK Ok
    uint256 public pausedTime;

    // Number of tokens per 1000 ETH. See TokenSaleConfig for details.
    // BK Ok
    uint256 public tokensPerKEther;

    // Keeps track of the maximum amount of tokens that an account is allowed to purchase in phase 1.
    // BK Ok
    uint256 public phase1AccountTokensMax;

    // Address where the funds collected during the sale will be forwarded.
    // BK Ok
    address public wallet;

    // Token contract that the sale contract will interact with.
    // BK Ok
    SimpleToken public tokenContract;

    // Trustee contract to hold on token balances. The following token pools will be held by trustee:
    //    - Founders
    //    - Advisors
    //    - Early investors
    //    - Presales
    // BK Ok
    Trustee public trusteeContract;

    // Total amount of tokens sold during presale + public sale. Excludes pre-sale bonuses.
    // BK Ok
    uint256 public totalTokensSold;

    // Total amount of tokens given as bonus during presale. Will influence accelerator token balance.
    // BK Next 2 Ok
    uint256 public totalPresaleBase;
    uint256 public totalPresaleBonus;

    // Map of addresses that have been whitelisted in advance (and passed KYC).
    // The whitelist value indicates what phase (1 or 2) the address has been whitelisted for.
    // Addresses whitelisted for phase 1 can also contribute during phase 2.
    // BK Ok
    mapping(address => uint8) public whitelist;


    //
    // EVENTS
    //
    // BK Next 9 Ok
    event Initialized();
    event PresaleAdded(address indexed _account, uint256 _baseTokens, uint256 _bonusTokens);
    event WhitelistUpdated(address indexed _account, uint8 _phase);
    event TokensPurchased(address indexed _beneficiary, uint256 _cost, uint256 _tokens, uint256 _totalSold);
    event TokensPerKEtherUpdated(uint256 _amount);
    event Phase1AccountTokensMaxUpdated(uint256 _tokens);
    event WalletChanged(address _newWallet);
    event TokensReclaimed(uint256 _amount);
    event UnsoldTokensBurnt(uint256 _amount);
    event Finalized();


    // BK Ok - Constructor
    function TokenSale(SimpleToken _tokenContract, Trustee _trusteeContract, address _wallet) public
        OpsManaged()
    {
        // BK Next 3 Ok
        require(address(_tokenContract) != address(0));
        require(address(_trusteeContract) != address(0));
        require(_wallet != address(0));

        // BK Next 3 Ok
        require(PHASE1_START_TIME >= currentTime());
        require(PHASE2_START_TIME > PHASE1_START_TIME);
        require(END_TIME > PHASE2_START_TIME);
        require(TOKENS_PER_KETHER > 0);
        require(PHASE1_ACCOUNT_TOKENS_MAX > 0);

        // Basic check that the constants add up to TOKENS_MAX
        // BK Ok
        uint256 partialAllocations = TOKENS_FOUNDERS.add(TOKENS_ADVISORS).add(TOKENS_EARLY_BACKERS);
        // BK Ok
        require(partialAllocations.add(TOKENS_SALE).add(TOKENS_ACCELERATOR).add(TOKENS_FUTURE) == TOKENS_MAX);

        // BK Next 6 Ok
        wallet                 = _wallet;
        pausedTime             = 0;
        endTime                = END_TIME;
        finalized              = false;
        tokensPerKEther        = TOKENS_PER_KETHER;
        phase1AccountTokensMax = PHASE1_ACCOUNT_TOKENS_MAX;

        // BK Next 2 Ok
        tokenContract   = _tokenContract;
        trusteeContract = _trusteeContract;
    }


    // Initialize is called to check some configuration parameters.
    // It expects that a certain amount of tokens have already been assigned to the sale contract address.
    // BK Ok - Only owner can execute
    function initialize() external onlyOwner returns (bool) {
        // BK Next 3 Ok
        require(totalTokensSold == 0);
        require(totalPresaleBase == 0);
        require(totalPresaleBonus == 0);

        // BK Ok
        uint256 ownBalance = tokenContract.balanceOf(address(this));
        // BK Ok
        require(ownBalance == TOKENS_SALE);

        // Simple check to confirm that tokens are present
        // BK Ok
        uint256 trusteeBalance = tokenContract.balanceOf(address(trusteeContract));
        // BK Ok
        require(trusteeBalance >= TOKENS_FUTURE);

        // BK Ok - Log event
        Initialized();

        // BK Ok
        return true;
    }


    // Allows the admin to change the wallet where ETH contributions are sent.
    // BK Ok - Only admin can execute
    function changeWallet(address _wallet) external onlyAdmin returns (bool) {
        // BK Next 4 Ok
        require(_wallet != address(0));
        require(_wallet != address(this));
        require(_wallet != address(trusteeContract));
        require(_wallet != address(tokenContract));

        // BK Ok
        wallet = _wallet;

        // BK Ok - Log event
        WalletChanged(wallet);

        // BK Ok
        return true;
    }



   //
   // TIME
   //

    // BK Ok
    function currentTime() public view returns (uint256 _currentTime) {
        // BK Ok
        return now;
    }


    // BK Ok
    modifier onlyBeforeSale() {
        // BK Ok
        require(hasSaleEnded() == false);
        // BK Ok
        require(currentTime() < PHASE1_START_TIME);
        // BK Ok
       _;
    }


    // BK Ok
    modifier onlyDuringSale() {
        // BK Ok
        require(hasSaleEnded() == false && currentTime() >= PHASE1_START_TIME);
        // BK Ok
        _;
    }

    // BK Ok
    modifier onlyAfterSale() {
        // require finalized is stronger than hasSaleEnded
        // BK Ok
        require(finalized);
        // BK Ok
        _;
    }


    // BK Ok - View only
    function hasSaleEnded() private view returns (bool) {
        // if sold out or finalized, sale has ended
        // BK Ok
        if (totalTokensSold >= TOKENS_SALE || finalized) {
            // BK Ok
            return true;
        // else if sale is not paused (pausedTime = 0) 
        // and endtime has past, then sale has ended
        // BK Ok
        } else if (pausedTime == 0 && currentTime() >= endTime) {
            // BK Ok
            return true;
        // otherwise it is not past and not paused; or paused
        // and as such not ended
        // BK Ok
        } else {
            // BK Ok
            return false;
        }
    }



    //
    // WHITELIST
    //

    // Allows ops to add accounts to the whitelist.
    // Only those accounts will be allowed to contribute during the sale.
    // _phase = 1: Can contribute during phases 1 and 2 of the sale.
    // _phase = 2: Can contribute during phase 2 of the sale only.
    // _phase = 0: Cannot contribute at all (not whitelisted).
    // BK Ok - Only ops can execute
    function updateWhitelist(address _account, uint8 _phase) external onlyOps returns (bool) {
        // BK Ok
        require(_account != address(0));
        // BK Ok
        require(_phase <= 2);
        // BK Ok
        require(!hasSaleEnded());

        // BK Ok
        whitelist[_account] = _phase;

        // BK Ok - Log event
        WhitelistUpdated(_account, _phase);

        // BK Ok
        return true;
    }



    //
    // PURCHASES / CONTRIBUTIONS
    //

    // Allows the admin to set the price for tokens sold during phases 1 and 2 of the sale.
    // BK Ok - Only admin can execute before start
    function setTokensPerKEther(uint256 _tokensPerKEther) external onlyAdmin onlyBeforeSale returns (bool) {
        // BK Ok
        require(_tokensPerKEther > 0);

        // BK Ok
        tokensPerKEther = _tokensPerKEther;

        // BK Ok - Log event
        TokensPerKEtherUpdated(_tokensPerKEther);

        // BK Ok
        return true;
    }


    // Allows the admin to set the maximum amount of tokens that an account can buy during phase 1 of the sale.
    // BK Ok - Only admin can execute before start
    function setPhase1AccountTokensMax(uint256 _tokens) external onlyAdmin onlyBeforeSale returns (bool) {
        // BK Ok
        require(_tokens > 0);

        // BK Ok
        phase1AccountTokensMax = _tokens;

        // BK Ok - Log event
        Phase1AccountTokensMaxUpdated(_tokens);

        // BK Ok
        return true;
    }


    // BK Ok - Anyone can call when not paused during the sale, payable
    function () external payable whenNotPaused onlyDuringSale {
        // BK Ok
        buyTokens();
    }


    // This is the main function to process incoming ETH contributions.
    // BK Ok - Anyone can call when not paused during the sale, payable
    function buyTokens() public payable whenNotPaused onlyDuringSale returns (bool) {
        // BK Next 3 Ok
        require(msg.value >= CONTRIBUTION_MIN);
        require(msg.value <= CONTRIBUTION_MAX);
        require(totalTokensSold < TOKENS_SALE);

        // All accounts need to be whitelisted to purchase.
        // BK Next 2 Ok
        uint8 whitelistedPhase = whitelist[msg.sender];
        require(whitelistedPhase > 0);

        // BK Ok
        uint256 tokensMax = TOKENS_SALE.sub(totalTokensSold);

        // BK Ok
        if (currentTime() < PHASE2_START_TIME) {
            // We are in phase 1 of the sale
            // BK Ok
            require(whitelistedPhase == 1);

            // BK Ok
            uint256 accountBalance = tokenContract.balanceOf(msg.sender);

            // Can only purchase up to a maximum per account.
            // Calculate how much of that amount is still available.
            // BK Ok
            uint256 phase1Balance = phase1AccountTokensMax.sub(accountBalance);

            // BK Ok
            if (phase1Balance < tokensMax) {
                // BK Ok
                tokensMax = phase1Balance;
            }
        }

        // BK Ok
        require(tokensMax > 0);

        // BK Next 2 Ok
        uint256 tokensBought = msg.value.mul(tokensPerKEther).div(PURCHASE_DIVIDER);
        require(tokensBought > 0);

        // BK Next 2 Ok
        uint256 cost = msg.value;
        uint256 refund = 0;

        // BK Ok - Only the last contribution in each phase will possibly execute this
        if (tokensBought > tokensMax) {
            // Not enough tokens available for full contribution, we will do partial.
            // BK Ok
            tokensBought = tokensMax;

            // Calculate actual cost for partial amount of tokens.
            // BK Ok
            cost = tokensBought.mul(PURCHASE_DIVIDER).div(tokensPerKEther);

            // Calculate refund for contributor.
            // BK Ok
            refund = msg.value.sub(cost);
        }

        // BK Ok
        totalTokensSold = totalTokensSold.add(tokensBought);

        // Transfer tokens to the account
        // BK Ok
        require(tokenContract.transfer(msg.sender, tokensBought));

        // Issue a ETH refund for any unused portion of the funds.
        // BK Ok - Only the last contribution in each phase will possibly execute this
        if (refund > 0) {
            // BK Ok - Could be a malicious wallet, but gas limited and will throw exceptions on errors
            msg.sender.transfer(refund);
        }

        // Transfer the contribution to the wallet
        // BK Ok
        wallet.transfer(msg.value.sub(refund));

        // BK Ok - Log event
        TokensPurchased(msg.sender, cost, tokensBought, totalTokensSold);

        // If all tokens available for sale have been sold out, finalize the sale automatically.
        // BK Ok
        if (totalTokensSold == TOKENS_SALE) {
            // BK Ok
            finalizeInternal();
        }

        return true;
    }


    //
    // PRESALES
    //

    // Allows the admin to record pre-sales, before the public sale starts. Presale base tokens come out of the
    // main sale pool (the 30% allocation) while bonus tokens come from the remaining token pool.
    // BK Ok - Only admin can execute before start
    function addPresale(address _account, uint256 _baseTokens, uint256 _bonusTokens) external onlyAdmin onlyBeforeSale returns (bool) {
        // BK Ok
        require(_account != address(0));

        // Presales may have 0 bonus tokens but need to have a base amount of tokens sold.
        // BK Next 2 Ok
        require(_baseTokens > 0);
        require(_bonusTokens < _baseTokens);

        // We do not count bonus tokens as part of the sale cap.
        // BK Ok
        totalTokensSold = totalTokensSold.add(_baseTokens);
        // BK Ok
        require(totalTokensSold <= TOKENS_SALE);

        // BK Ok
        uint256 ownBalance = tokenContract.balanceOf(address(this));
        // BK Ok
        require(_baseTokens <= ownBalance);

        // BK Next 2 Ok
        totalPresaleBase  = totalPresaleBase.add(_baseTokens);
        totalPresaleBonus = totalPresaleBonus.add(_bonusTokens);

        // Move base tokens to the trustee
        // BK Ok
        require(tokenContract.transfer(address(trusteeContract), _baseTokens));

        // Presale allocations are marked as locked, they cannot be removed by the owner.
        // BK Ok
        uint256 tokens = _baseTokens.add(_bonusTokens);
        // BK Ok - Not revocable
        require(trusteeContract.grantAllocation(_account, tokens, false /* revokable */));

        // BK Ok - Log event
        PresaleAdded(_account, _baseTokens, _bonusTokens);

        // BK Ok
        return true;
    }


    //
    // PAUSE / UNPAUSE
    //

    // Allows the owner or admin to pause the sale for any reason.
    // BK Ok - Owner can repeatedly extend the pause time
    function pause() public onlyAdmin whenNotPaused {
        // BK Ok
        require(hasSaleEnded() == false);

        // BK Ok
        pausedTime = currentTime();

        // BK Ok
        return super.pause();
    }


    // Unpause may extend the end time of the public sale.
    // Note that we do not extend the start time of each phase.
    // Currently does not extend phase 1 end time, only final end time.
    // BK Ok - Only admin can execute when paused
    function unpause() public onlyAdmin whenPaused {

        // If owner unpauses before sale starts, no impact on end time.
        // BK Ok
        uint256 current = currentTime();

        // If owner unpauses after sale starts, calculate how to extend end.
        // BK Ok
        if (current > PHASE1_START_TIME) {
            // BK Ok
            uint256 timeDelta;

            // BK Ok
            if (pausedTime < PHASE1_START_TIME) {
                // Pause was triggered before the start time, extend by time that
                // passed from proposed start time until now.
                // BK Ok
                timeDelta = current.sub(PHASE1_START_TIME);
            // BK Ok
            } else {
                // Pause was triggered while the sale was already started.
                // Extend end time by amount of time since pause.
                // BK Ok
                timeDelta = current.sub(pausedTime);
            }

            // BK Ok
            endTime = endTime.add(timeDelta);
        }

        // BK Ok
        pausedTime = 0;

        // BK Ok
        return super.unpause();
    }


    // Allows the admin to move bonus tokens still available in the sale contract
    // out before burning all remaining unsold tokens in burnUnsoldTokens().
    // Used to distribute bonuses to token sale participants when the sale has ended
    // and all bonuses are known.
    // BK Ok - Only admin can execute
    function reclaimTokens(uint256 _amount) external onlyAfterSale onlyAdmin returns (bool) {
        // BK Ok
        uint256 ownBalance = tokenContract.balanceOf(address(this));
        // BK Ok
        require(_amount <= ownBalance);
        
        // BK Ok
        address tokenOwner = tokenContract.owner();
        // BK Ok
        require(tokenOwner != address(0));

        // BK Ok
        require(tokenContract.transfer(tokenOwner, _amount));

        // BK Ok
        TokensReclaimed(_amount);

        // BK Ok
        return true;
    }


    // Allows the admin to burn all unsold tokens in the sale contract.
    // BK Ok - Only admin can execute
    function burnUnsoldTokens() external onlyAfterSale onlyAdmin returns (bool) {
        // BK Ok
        uint256 ownBalance = tokenContract.balanceOf(address(this));

        // BK Ok
        require(tokenContract.burn(ownBalance));

        // BK Ok - Log event
        UnsoldTokensBurnt(ownBalance);

        // BK Ok
        return true;
    }


    // Allows the admin to finalize the sale and complete allocations.
    // The SimpleToken.admin also needs to finalize the token contract
    // so that token transfers are enabled.
    // BK Ok - Only admin can execute
    function finalize() external onlyAdmin returns (bool) {
        // BK Ok
        return finalizeInternal();
    }


    // The internal one will be called if tokens are sold out or
    // the end time for the sale is reached, in addition to being called
    // from the public version of finalize().
    // BK Ok - Private
    function finalizeInternal() private returns (bool) {
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
