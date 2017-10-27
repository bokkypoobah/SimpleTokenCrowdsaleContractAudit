# Simple Token Crowdsale Contract Audit

Status: The audit on the original crowdsale and token contracts is completed. The review on the more recently developed
*FutureTokenSaleLockBox* and *ProcessableAllocations* smart contract is outstanding. 

## Summary

[Simple Token](https://simpletoken.org/) intends to run a crowdsale commencing on Nov 14 2017.

Bok Consulting Pty Ltd was commissioned to perform an audit on Simple Tokens's crowdsale and token Ethereum smart contract.

### First Review
This **first review** has been conducted on Simple Tokens's source code in commits
[ed1c05d](https://github.com/SimpleTokenFoundation/SimpleTokenSale/commit/ed1c05df4ec51d8be2bbee601032aec536f9c4b1).

<br />

### Second Review

The **second review** has been conducted on the update to Simple Token's source code in commits
[08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e) and
[1a1e863](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/1a1e863441ba0149d7585203f5dbc6e800af00cf).

The key management for executing functions was updated in
[08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e). The OpenZeppelin
contracts were moved into the same directory as the other contracts and Ownable.sol was renamed to Owned.sol.

In [1a1e863](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/1a1e863441ba0149d7585203f5dbc6e800af00cf), 
two new contracts FutureTokenSaleLockBox.sol and ProcessableAllocations.sol were added.

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

### Crowdsale Mainnet Addresses

`TBA`

<br />

<br />

### Crowdsale Contract

**TODO**

* Presale contributions will not receive their allocated tokens until the `ops` account executes `Trustee.processAllocation(...)` and this
  may be executed after the crowdsale is over and the token contract is finalised
* There is a minimum and maximum ether (ETH) contribution amount
* All contributing accounts must be whitelisted by the crowdsale administrator before being able to contribute to the crowdsale
* The last contribution that hits the hard cap is reached will receive a refund of ETH that exceeds the permitted contribution amount
* All ETH contributions will be immediately transferred to the crowdsale wallet, and this greatly lowers the risk profile of this bespoke crowdsale
  smart contract
* The crowdsale can be paused by the crowdsale administrator. Additional time may be added to the end date to compensate for the paused period

<br />

### Token Contract

* The token contract is [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md) compliant with the
  following notable features:
  * `transfer(...)` and `transferFrom(...)` will throw an error if there is insufficient balance (including the approved balance in the case of
    `transferFrom(...)`, instead of returning false
  * 0 value transfers are valid
  * There is no payload size check on the data passed to `transfer(...)` and `transferFrom(...)`. This check was previously used to mitigate against
    the short address attack, but is no longer the recommended mitigation solution
  * `approve(...)` does not require a non-0 allowance to be set to 0 before modifying the allowance to a new non-0 allowance
  * Once the token contract is finalised after the crowdsale is over, token transfers cannot be paused or halted

<br />

<hr />

## Table Of Content

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
  * [Test 1 Max Funding](#test-1-max-funding)
* [Code Review](#code-review)
  * [First Code Review](#first-code-review)
  * [Second Code Review](#second-code-review)
  * [New Contracts Code Review](#new-contracts-code-review)
  * [Not Reviewed](#not-reviewed)
  * [Permissions](#permissions)
    * [onlyOwner](#onlyowner)
    * [onlyOwnerOrAdmin](#onlyowneroradmin)
    * [onlyAdmin](#onlyadmin)
    * [onlyAdminOrOps](#onlyadminorops)
    * [onlyOps](#onlyops)
    * [onlyOwnerOrRevoke](#onlyownerorrevoke)
    * [onlyRevoke](#onlyrevoke)
    * [isOwner](#isowner)
    * [isAdmin](#isadmin)
    * [isOwnerOrOps](#isownerorops)
    * [isOps](#isops)

<br />

<hr />

## Recommendations

### First Review Recommendations

* **LOW IMPORTANCE** In *Ownable*, use the [`acceptOwnership(...)`](https://github.com/openanx/OpenANXToken/blob/master/contracts/Owned.sol#L51-L55)
  pattern to improve the safety of ownership transfer process

  * [x] Added in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e) with *Ownable* renamed
    to *Owned*
* **LOW IMPORTANCE** In *ERC20Interface*, the comment [https://github.com/ethereum/EIPs/issues/20](https://github.com/ethereum/EIPs/issues/20) should
  be updated to the final standard at [https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)

  * [x] Updated in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e)
* **LOW IMPORTANCE** In the *ERC20Token* constructor, as stated in the recently finalised [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md):

  > A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.

  Add `Transfer(0x0, owner, _totalSupply);` to the bottom of the constructor. This will show the minting of the initial tokens in token explorers. 

  * [x] Added in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e)
* **LOW IMPORTANCE** In `ERC20Token.transfer(...)` and ``ERC20Token.transferFrom(...)`, as stated in the recently finalised
  [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md):

  > The function SHOULD throw if the _from account balance does not have enough tokens to spend

  and

  > Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.

  Also

  > The function SHOULD throw if the _from account balance does not have enough tokens to spend.

  Applicable to `transferFrom(...)` only

  > The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.

  The way to amend the code to adhere to the ERC20 standard is to remove the `if (...) { ... }` statements in both `transfer(...)` and
  `transferFrom(...)`

  * [x] Updated in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e)
* **LOW IMPORTANCE** In `ERC20Token.approve(...)`, as stated in the recently finalised 
  [ERC20 Token Standard - approve](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve):

  > THOUGH The contract itself shouldn't enforce it, ...

  Consider removing the `if (...) { ... }` statement

  * [x] Removed in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e)
* **VERY LOW IMPORTANCE** Reformat your code so it is consistent when combined into one file. E.g. the following code has 4, 5 and 3 tab spacings:

      # From ERC20Interface
          uint256 public totalSupply;

          function balanceOf(address _owner) constant returns (uint256 balance);

      # From ERC20Token
           function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
               return allowed[_owner][_spender];
           }

      # From SimpleToken
         function SimpleToken()
            ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX)
            OpsManaged()
         {
            finalized = false;

  Also the number of blank lines between functions, statements, blocks, ... are a little bit variable

  * [x] Reformatted in [08c4976](https://github.com/OpenSTFoundation/SimpleTokenSale/commit/08c4976d82cc91841df10ce805806ae72308305e)

<br />

### Second Review Recommendations

* **OPTIONAL** To save on gas cost on errors with the new Byzantium changes, add `require(balances[msg.sender] >= _value);` to the beginning
  of `ERC20Token.transfer(...)`. `require(...)` does not consume all the gas like the `assert(...)` in the SafeMath library

* **OPTIONAL** To save on gas cost on errors with the Byzantium changes, add `require(balances[_from] >= _value);` and
  `require(allowed[_from][msg.sender] >= _value);` to the beginning of `ERC20Token.transferFrom(...)`. `require(...)` does not consume all
  the gas like the `assert(...)` in the SafeMath library

* **LOW IMPORTANCE** `Trustee.processAllocation(...)` has the permissioning that `onlyOps` can execute this function, yet there is a
  check for `require(isOwner(msg.sender) || isAdmin(msg.sender));` in this function. This check will only be applicable if `opsAddress` is
  the same of either the `owner` or `adminAddress`. This check is only relevant when the token contract has not been finalised

* **LOW IMPORTANCE** `ProcessableAllocations.processProcessableAllocations()` has a **for** loop that iterates through the array of `grantees`.
  If this array holds to many entries, the gas required can exceed the Ethereum network block gas limit. Carefully check the gas limit for
  the intended number of grantees, and if this limit is too high, consider modifying this function to operate on subsets of the array

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is that
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Simple Token's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* The risk of ETH being hacked or stolen in this crowdsale contract is low and minimised in size, as any ETH contributed is immediately
  transferred into more widely tested external wallets (hardware, multisig or regular). No ETH is accumulated in this crowdsale
  contract. 

<br />

<hr />

## Testing

### Test 1 Max Funding

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy the token, trustee and sale contracts
* [x] Stitch the contracts together, move tokens to contracts
* [x] Add presale tokens, Whitelist participant accounts
* [x] Contribute to the crowdsale contract
* [x] Finalise the successful crowdsale
* [x] Transfer tokens
* [x] Process trustee allocation for presale accounts
* [x] Reclaim trustee tokens

<br />

Details of the testing environment can be found in [test](test).

<br />

<hr />

## Code Review

### First Code Review

Only some file reviewed fully.

* [x] [code-review-old/Owned.md](code-review-old/Owned.md)
  * [x] contract Owned
* [x] [code-review-old/Pausable.md](code-review-old/Pausable.md)
  * [x] contract Pausable is Ownable
* [x] [code-review-old/SafeMath.md](code-review-old/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review-old/ERC20Interface.md](code-review-old/ERC20Interface.md)
  * [x] contract ERC20Interface
* [x] [code-review-old/ERC20Token.md](code-review-old/ERC20Token.md)
  * [x] contract ERC20Token is ERC20Interface, Ownable
    * [x] using SafeMath for uint256
* [x] [code-review-old/OpsManaged.md](code-review-old/OpsManaged.md)
  * [x] contract OpsManaged is Ownable
* [ ] [code-review-old/Trustee.md](code-review-old/Trustee.md)
  * [ ] contract Trustee is OpsManaged
    * [ ] using SafeMath for uint256
* [x] [code-review-old/SimpleTokenConfig.md](code-review-old/SimpleTokenConfig.md)
  * [x] contract SimpleTokenConfig
* [x] [code-review-old/TokenSaleConfig.md](code-review-old/TokenSaleConfig.md)
  * [x] contract TokenSaleConfig is SimpleTokenConfig
* [ ] [code-review-old/SimpleToken.md](code-review-old/SimpleToken.md)
  * [ ] contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig
* [ ] [code-review-old/TokenSale.md](code-review-old/TokenSale.md)
  * [ ] contract TokenSale is OpsManaged, Pausable, TokenSaleConfig
    * [ ] using SafeMath for uint256

<br />

### Second Code Review

* [x] [code-review/Owned.md](code-review/Owned.md)
  * [x] contract Owned 
* [x] [code-review/SafeMath.md](code-review/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review/ERC20Interface.md](code-review/ERC20Interface.md)
  * [x] contract ERC20Interface 
* [x] [code-review/ERC20Token.md](code-review/ERC20Token.md)
  * [x] contract ERC20Token is ERC20Interface, Owned
    * [x] using SafeMath for uint256 
* [x] [code-review/OpsManaged.md](code-review/OpsManaged.md)
  * [x] contract OpsManaged is Owned 
* [x] [code-review/Pausable.md](code-review/Pausable.md)
  * [x] contract Pausable is OpsManaged 
* [x] [code-review/SimpleTokenConfig.md](code-review/SimpleTokenConfig.md)
  * [x] contract SimpleTokenConfig 
* [x] [code-review/TokenSaleConfig.md](code-review/TokenSaleConfig.md)
  * [x] contract TokenSaleConfig is SimpleTokenConfig 
* [x] [code-review/SimpleToken.md](code-review/SimpleToken.md)
  * [x] contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig 
* [x] [code-review/TokenSale.md](code-review/TokenSale.md)
  * [x] contract TokenSale is OpsManaged, Pausable, TokenSaleConfig
    * [x] using SafeMath for uint256
* [x] [code-review/Trustee.md](code-review/Trustee.md)
  * [x] contract Trustee is OpsManaged
    * [x] using SafeMath for uint256

<br />

### New Contracts Code Review

* [ ] [code-review/FutureTokenSaleLockBox.md](code-review/FutureTokenSaleLockBox.md)
  * [ ] contract TokenSaleInterface 
  * [ ] contract TokenInterface 
  * [ ] contract FutureTokenSaleLockBox is Owned
* [x] [code-review/ProcessableAllocations.md](code-review/ProcessableAllocations.md)
  * [x] contract TrusteeInterface 
  * [x] contract ProcessableAllocations is Owned 

<br />

### Not Reviewed

* [ ] [code-review/TokenSaleMock.md](code-review/TokenSaleMock.md)
  * [ ] contract TokenSaleMock is TokenSale
* [ ] [code-review/FutureTokenSaleLockBoxMock.md](code-review/FutureTokenSaleLockBoxMock.md)
  * [ ] contract FutureTokenSaleLockBoxMock is FutureTokenSaleLockBox

<br />

### Permissions

#### onlyOwner

```
$ egrep -e "onlyOwner[^a-zA-Z]" *.sol
FutureTokenSaleLockBox.sol:    function extendUnlockDate(uint256 _newDate) public onlyOwner returns (bool) {
FutureTokenSaleLockBox.sol:    function transfer(address _to, uint256 _value) public onlyOwner onlyAfterUnlockDate returns (bool) {
FutureTokenSaleLockBoxMock.sol:    function changeTime(uint256 _newTime) public onlyOwner returns (bool) {
Owned.sol:    modifier onlyOwner() {
Owned.sol:    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
ProcessableAllocations.sol: function addProcessableAllocation(address _grantee, uint256 _amount) public onlyOwner onlyIfUnlocked returns (bool) {
ProcessableAllocations.sol: function lock() public onlyOwner onlyIfUnlocked returns (bool) {
ProcessableAllocations.sol: function processProcessableAllocations() public onlyOwner onlyIfLocked returns (bool) {
TokenSale.sol:    function initialize() external onlyOwner returns (bool) {
TokenSaleMock.sol:   function changeTime(uint256 _newTime) public onlyOwner returns (bool) {
```

#### onlyOwnerOrAdmin

```
$ grep onlyOwnerOrAdmin *.sol
OpsManaged.sol:    modifier onlyOwnerOrAdmin() {
OpsManaged.sol:    function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
OpsManaged.sol:    function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
```

<br />

#### onlyAdmin

```
$ egrep -e "onlyAdmin[^a-zA-Z]" *.sol
OpsManaged.sol:    modifier onlyAdmin() {
Pausable.sol:  function pause() public onlyAdmin whenNotPaused {
Pausable.sol:  function unpause() public onlyAdmin whenPaused {
SimpleToken.sol:    function finalize() external onlyAdmin returns (bool success) {
TokenSale.sol:    function changeWallet(address _wallet) external onlyAdmin returns (bool) {
TokenSale.sol:    function setTokensPerKEther(uint256 _tokensPerKEther) external onlyAdmin onlyBeforeSale returns (bool) {
TokenSale.sol:    function setPhase1AccountTokensMax(uint256 _tokens) external onlyAdmin onlyBeforeSale returns (bool) {
TokenSale.sol:    function addPresale(address _account, uint256 _baseTokens, uint256 _bonusTokens) external onlyAdmin onlyBeforeSale returns (bool) {
TokenSale.sol:    function pause() public onlyAdmin whenNotPaused {
TokenSale.sol:    function unpause() public onlyAdmin whenPaused {
TokenSale.sol:    function reclaimTokens() external onlyAdmin returns (bool) {
TokenSale.sol:    function finalize() external onlyAdmin returns (bool) {
Trustee.sol:    function reclaimTokens() external onlyAdmin returns (bool) {
```

<br />

#### onlyAdminOrOps

```
$ grep onlyAdminOrOps *.sol
OpsManaged.sol:    modifier onlyAdminOrOps() {
Trustee.sol:    function grantAllocation(address _account, uint256 _amount, bool _revokable) public onlyAdminOrOps returns (bool) {
```

<br />

#### onlyOps

```
$ grep onlyOps *.sol
OpsManaged.sol:    modifier onlyOps() {
TokenSale.sol:    function updateWhitelist(address _account, uint8 _phase) external onlyOps returns (bool) {
Trustee.sol:    function processAllocation(address _account, uint256 _amount) external onlyOps returns (bool) {
```

<br />

#### onlyOwnerOrRevoke

```
$ grep onlyOwnerOrRevoke *.sol
Trustee.sol:    modifier onlyOwnerOrRevoke() {
Trustee.sol:    function setRevokeAddress(address _revokeAddress) external onlyOwnerOrRevoke returns (bool) {
```

<br />

#### onlyRevoke

```
$ grep onlyRevoke *.sol
Trustee.sol:    modifier onlyRevoke() {
Trustee.sol:    function revokeAllocation(address _account) external onlyRevoke returns (bool) {
```

<br />

#### isOwner

```
$ egrep -e "isOwner[^a-zA-Z]" *.sol
OpsManaged.sol:        require(isOwner(msg.sender) || isAdmin(msg.sender));
OpsManaged.sol:        return (isOwner(_address) || isOps(_address));
Owned.sol:        require(isOwner(msg.sender));
Owned.sol:    function isOwner(address _address) internal view returns (bool) {
Trustee.sol:        require(isOwner(msg.sender) || isRevoke(msg.sender));
Trustee.sol:            require(isOwner(msg.sender) || isAdmin(msg.sender));
```

<br />

#### isAdmin

```
$ grep isAdmin *.sol
OpsManaged.sol:        require(isAdmin(msg.sender));
OpsManaged.sol:        require(isAdmin(msg.sender) || isOps(msg.sender));
OpsManaged.sol:        require(isOwner(msg.sender) || isAdmin(msg.sender));
OpsManaged.sol:    function isAdmin(address _address) internal view returns (bool) {
OpsManaged.sol:        require(!isAdmin(_opsAddress));
Trustee.sol:        require(!isAdmin(_revokeAddress));
Trustee.sol:            require(isOwner(msg.sender) || isAdmin(msg.sender));
```

<br />

#### isOwnerOrOps

```
$ grep isOwnerOrOps *.sol
OpsManaged.sol:    function isOwnerOrOps(address _address) internal view returns (bool) {
SimpleToken.sol:        require(isOwnerOrOps(_sender) || _to == owner);
```

<br />

#### isOps

```
$ grep isOps *.sol
OpsManaged.sol:        require(isAdmin(msg.sender) || isOps(msg.sender));
OpsManaged.sol:        require(isOps(msg.sender));
OpsManaged.sol:    function isOps(address _address) internal view returns (bool) {
OpsManaged.sol:        return (isOwner(_address) || isOps(_address));
OpsManaged.sol:        require(!isOps(_adminAddress));
Trustee.sol:        require(!isOps(_revokeAddress));
Trustee.sol:        if (isOps(msg.sender)) {
```

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Simple Token - Oct 27 2017. The MIT Licence.