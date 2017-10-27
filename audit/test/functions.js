// Oct 12 2017
var ethPriceUSD = 300.8660;

// -----------------------------------------------------------------------------
// Accounts
// -----------------------------------------------------------------------------
var accounts = [];
var accountNames = {};

addAccount(eth.accounts[0], "Account #0 - Miner");
addAccount(eth.accounts[1], "Account #1 - Contract Owner");
addAccount(eth.accounts[2], "Account #2 - Wallet");
addAccount(eth.accounts[3], "Account #3 - Ops Account");
addAccount(eth.accounts[4], "Account #4 - Admin Account");
addAccount(eth.accounts[5], "Account #5 - Whitelisted Phase 1");
addAccount(eth.accounts[6], "Account #6 - Whitelisted Phase 2");
addAccount(eth.accounts[7], "Account #7");
addAccount(eth.accounts[8], "Account #8");
addAccount(eth.accounts[9], "Account #9");
addAccount(eth.accounts[10], "Account #10 - Revoke Account");
addAccount(eth.accounts[11], "Account #11 - Presale 1");
addAccount(eth.accounts[12], "Account #12 - Presale 2");


var minerAccount = eth.accounts[0];
var contractOwnerAccount = eth.accounts[1];
var wallet = eth.accounts[2];
var opsAccount = eth.accounts[3];
var adminAccount = eth.accounts[4];
var account5 = eth.accounts[5];
var account6 = eth.accounts[6];
var account7 = eth.accounts[7];
var account8 = eth.accounts[8];
var account9 = eth.accounts[9];
var revokeAccount = eth.accounts[10];
var presale1 = eth.accounts[11];
var presale2 = eth.accounts[12];

var baseBlock = eth.blockNumber;

function unlockAccounts(password) {
  for (var i = 0; i < eth.accounts.length; i++) {
    personal.unlockAccount(eth.accounts[i], password, 100000);
  }
}

function addAccount(account, accountName) {
  accounts.push(account);
  accountNames[account] = accountName;
}


// -----------------------------------------------------------------------------
// Token Contract
// -----------------------------------------------------------------------------
var tokenContractAddress = null;
var tokenContractAbi = null;

function addTokenContractAddressAndAbi(address, tokenAbi) {
  tokenContractAddress = address;
  tokenContractAbi = tokenAbi;
}


// -----------------------------------------------------------------------------
// Account ETH and token balances
// -----------------------------------------------------------------------------
function printBalances() {
  var token = tokenContractAddress == null || tokenContractAbi == null ? null : web3.eth.contract(tokenContractAbi).at(tokenContractAddress);
  var decimals = token == null ? 18 : token.decimals();
  var i = 0;
  var totalTokenBalance = new BigNumber(0);
  console.log("RESULT:  # Account                                             EtherBalanceChange                          Token Name");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  accounts.forEach(function(e) {
    var etherBalanceBaseBlock = eth.getBalance(e, baseBlock);
    var etherBalance = web3.fromWei(eth.getBalance(e).minus(etherBalanceBaseBlock), "ether");
    var tokenBalance = token == null ? new BigNumber(0) : token.balanceOf(e).shift(-decimals);
    totalTokenBalance = totalTokenBalance.add(tokenBalance);
    console.log("RESULT: " + pad2(i) + " " + e  + " " + pad(etherBalance) + " " + padToken(tokenBalance, decimals) + " " + accountNames[e]);
    i++;
  });
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT:                                                                           " + padToken(totalTokenBalance, decimals) + " Total Token Balances");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT: ");
}

function pad2(s) {
  var o = s.toFixed(0);
  while (o.length < 2) {
    o = " " + o;
  }
  return o;
}

function pad(s) {
  var o = s.toFixed(18);
  while (o.length < 27) {
    o = " " + o;
  }
  return o;
}

function padToken(s, decimals) {
  var o = s.toFixed(decimals);
  var l = parseInt(decimals)+12;
  while (o.length < l) {
    o = " " + o;
  }
  return o;
}


// -----------------------------------------------------------------------------
// Transaction status
// -----------------------------------------------------------------------------
function printTxData(name, txId) {
  var tx = eth.getTransaction(txId);
  var txReceipt = eth.getTransactionReceipt(txId);
  var gasPrice = tx.gasPrice;
  var gasCostETH = tx.gasPrice.mul(txReceipt.gasUsed).div(1e18);
  var gasCostUSD = gasCostETH.mul(ethPriceUSD);
  var block = eth.getBlock(txReceipt.blockNumber);
  console.log("RESULT: " + name + " status=" + txReceipt.status + " gas=" + tx.gas +
    " gasUsed=" + txReceipt.gasUsed + " costETH=" + gasCostETH + " costUSD=" + gasCostUSD +
    " @ ETH/USD=" + ethPriceUSD + " gasPrice=" + gasPrice + " block=" + 
    txReceipt.blockNumber + " txIx=" + tx.transactionIndex + " txId=" + txId +
    " @ " + block.timestamp + " " + new Date(block.timestamp * 1000).toUTCString());
}

function assertEtherBalance(account, expectedBalance) {
  var etherBalance = web3.fromWei(eth.getBalance(account), "ether");
  if (etherBalance == expectedBalance) {
    console.log("RESULT: OK " + account + " has expected balance " + expectedBalance);
  } else {
    console.log("RESULT: FAILURE " + account + " has balance " + etherBalance + " <> expected " + expectedBalance);
  }
}

function failIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 0) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 1) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function gasEqualsGasUsed(tx) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  return (gas == gasUsed);
}

function failIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: PASS " + msg);
    return 1;
  } else {
    console.log("RESULT: FAIL " + msg);
    return 0;
  }
}

function failIfGasEqualsGasUsedOrContractAddressNull(contractAddress, tx, msg) {
  if (contractAddress == null) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    var gas = eth.getTransaction(tx).gas;
    var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
    if (gas == gasUsed) {
      console.log("RESULT: FAIL " + msg);
      return 0;
    } else {
      console.log("RESULT: PASS " + msg);
      return 1;
    }
  }
}


//-----------------------------------------------------------------------------
// Wait until some unixTime + additional seconds
//-----------------------------------------------------------------------------
function waitUntil(message, unixTime, addSeconds) {
  var t = parseInt(unixTime) + parseInt(addSeconds) + parseInt(1);
  var time = new Date(t * 1000);
  console.log("RESULT: Waiting until '" + message + "' at " + unixTime + "+" + addSeconds + "s =" + time + " now=" + new Date());
  while ((new Date()).getTime() <= time.getTime()) {
  }
  console.log("RESULT: Waited until '" + message + "' at at " + unixTime + "+" + addSeconds + "s =" + time + " now=" + new Date());
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
// Token Contract
//-----------------------------------------------------------------------------
var tokenFromBlock = 0;
function printTokenContractDetails() {
  console.log("RESULT: tokenContractAddress=" + tokenContractAddress);
  if (tokenContractAddress != null && tokenContractAbi != null) {
    var contract = eth.contract(tokenContractAbi).at(tokenContractAddress);
    var decimals = contract.decimals();
    console.log("RESULT: token.owner=" + contract.owner());
    console.log("RESULT: token.opsAddress=" + contract.opsAddress());
    console.log("RESULT: token.adminAddress=" + contract.adminAddress());
    console.log("RESULT: token.symbol=" + contract.symbol());
    console.log("RESULT: token.name=" + contract.name());
    console.log("RESULT: token.decimals=" + decimals);
    console.log("RESULT: token.totalSupply=" + contract.totalSupply().shift(-decimals));
    console.log("RESULT: token.DECIMALSFACTOR=" + contract.DECIMALSFACTOR());
    console.log("RESULT: token.TOKENS_MAX=" + contract.TOKENS_MAX().shift(-decimals));
    console.log("RESULT: token.finalized=" + contract.finalized());

    var latestBlock = eth.blockNumber;
    var i;

    var ownershipTransferInitiatedEvents = contract.OwnershipTransferInitiated({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferInitiatedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferInitiated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferInitiatedEvents.stopWatching();

    var ownershipTransferCompletedEvents = contract.OwnershipTransferCompleted({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferCompletedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferCompleted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferCompletedEvents.stopWatching();

    var opsAddressChangedChangedEvents = contract.OpsAddressChanged({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    opsAddressChangedChangedEvents.watch(function (error, result) {
      console.log("RESULT: OpsAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    opsAddressChangedChangedEvents.stopWatching();

    var adminAddressChangedEvents = contract.AdminAddressChanged({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    adminAddressChangedEvents.watch(function (error, result) {
      console.log("RESULT: AdminAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    adminAddressChangedEvents.stopWatching();

    var finalizedChangedEvents = contract.Finalized({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    finalizedChangedEvents.watch(function (error, result) {
      console.log("RESULT: Finalized " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    finalizedChangedEvents.stopWatching();

    var approvalEvents = contract.Approval({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    approvalEvents.watch(function (error, result) {
      console.log("RESULT: Approval " + i++ + " #" + result.blockNumber + " _owner=" + result.args._owner +
        " _spender=" + result.args._spender + " _value=" + result.args._value.shift(-decimals));
    });
    approvalEvents.stopWatching();

    var transferEvents = contract.Transfer({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    transferEvents.watch(function (error, result) {
      console.log("RESULT: Transfer " + i++ + " #" + result.blockNumber + ": _from=" + result.args._from + " _to=" + result.args._to +
        " _value=" + result.args._value.shift(-decimals));
    });
    transferEvents.stopWatching();

    tokenFromBlock = latestBlock + 1;
  }
}


//-----------------------------------------------------------------------------
// Trustee Contract
//-----------------------------------------------------------------------------
var trusteeContractAddress = null;
var trusteeContractAbi = null;

function addTrusteeContractAddressAndAbi(address, abi) {
  trusteeContractAddress = address;
  trusteeContractAbi = abi;
}

var trusteeFromBlock = 0;
function printTrusteeContractDetails() {
  console.log("RESULT: trusteeContractAddress=" + trusteeContractAddress);
  // console.log("RESULT: trusteeContractAbi=" + JSON.stringify(trusteeContractAbi));
  if (trusteeContractAddress != null && trusteeContractAbi != null) {
    var contract = eth.contract(trusteeContractAbi).at(trusteeContractAddress);
    var tokenContract = eth.contract(tokenContractAbi).at(contract.tokenContract());
    var decimals = tokenContract.decimals();
    console.log("RESULT: trustee.owner=" + contract.owner());
    console.log("RESULT: trustee.opsAddress=" + contract.opsAddress());
    console.log("RESULT: trustee.adminAddress=" + contract.adminAddress());
    console.log("RESULT: trustee.revokeAddress=" + contract.revokeAddress());
    console.log("RESULT: trustee.tokenContract=" + contract.tokenContract());
    console.log("RESULT: trustee.totalLocked=" + contract.totalLocked().shift(-decimals));

    var latestBlock = eth.blockNumber;
    var i;

    var ownershipTransferInitiatedEvents = contract.OwnershipTransferInitiated({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferInitiatedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferInitiated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferInitiatedEvents.stopWatching();

    var ownershipTransferCompletedEvents = contract.OwnershipTransferCompleted({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferCompletedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferCompleted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferCompletedEvents.stopWatching();

    var opsAddressChangedEvents = contract.OpsAddressChanged({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    opsAddressChangedEvents.watch(function (error, result) {
      console.log("RESULT: OpsAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    opsAddressChangedEvents.stopWatching();

    var adminAddressChangedEvents = contract.AdminAddressChanged({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    adminAddressChangedEvents.watch(function (error, result) {
      console.log("RESULT: AdminAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    adminAddressChangedEvents.stopWatching();

    var allocationGrantedEvents = contract.AllocationGranted({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    allocationGrantedEvents.watch(function (error, result) {
      console.log("RESULT: AllocationGranted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    allocationGrantedEvents.stopWatching();

    var allocationRevokedEvents = contract.AllocationRevoked({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    allocationRevokedEvents.watch(function (error, result) {
      console.log("RESULT: AllocationRevoked " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    allocationRevokedEvents.stopWatching();

    var allocationProcessedEvents = contract.AllocationProcessed({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    allocationProcessedEvents.watch(function (error, result) {
      console.log("RESULT: AllocationProcessed " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    allocationProcessedEvents.stopWatching();

    var tokensReclaimedEvents = contract.TokensReclaimed({}, { fromBlock: trusteeFromBlock, toBlock: latestBlock });
    i = 0;
    tokensReclaimedEvents.watch(function (error, result) {
      console.log("RESULT: TokensReclaimed " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    tokensReclaimedEvents.stopWatching();

    trusteeFromBlock = parseInt(latestBlock) + 1;
  }
}


//-----------------------------------------------------------------------------
// Sale Contract
//-----------------------------------------------------------------------------
var saleContractAddress = null;
var saleContractAbi = null;

function addSaleContractAddressAndAbi(address, abi) {
  saleContractAddress = address;
  saleContractAbi = abi;
}

var saleFromBlock = 0;
function printSaleContractDetails() {
  console.log("RESULT: saleContractAddress=" + saleContractAddress);
  // console.log("RESULT: saleContractAbi=" + JSON.stringify(saleContractAbi));
  if (saleContractAddress != null && saleContractAbi != null) {
    var contract = eth.contract(saleContractAbi).at(saleContractAddress);
    var tokenContract = eth.contract(tokenContractAbi).at(contract.tokenContract());
    var decimals = tokenContract.decimals();
    console.log("RESULT: sale.owner=" + contract.owner());
    console.log("RESULT: sale.opsAddress=" + contract.opsAddress());
    console.log("RESULT: sale.adminAddress=" + contract.adminAddress());

    console.log("RESULT: sale.PHASE1_START_TIME=" + contract.PHASE1_START_TIME() + " " + new Date(contract.PHASE1_START_TIME() * 1000).toUTCString());
    console.log("RESULT: sale.PHASE2_START_TIME=" + contract.PHASE2_START_TIME() + " " + new Date(contract.PHASE2_START_TIME() * 1000).toUTCString());
    console.log("RESULT: sale.END_TIME=" + contract.END_TIME() + " " + new Date(contract.END_TIME() * 1000).toUTCString());
    console.log("RESULT: sale.CONTRIBUTION_MIN=" + contract.CONTRIBUTION_MIN().shift(-18));
    console.log("RESULT: sale.CONTRIBUTION_MAX=" + contract.CONTRIBUTION_MAX().shift(-18));
    console.log("RESULT: sale.PHASE1_ACCOUNT_TOKENS_MAX=" + contract.PHASE1_ACCOUNT_TOKENS_MAX().shift(-decimals));
    console.log("RESULT: sale.TOKENS_SALE=" + contract.TOKENS_SALE().shift(-decimals));
    console.log("RESULT: sale.TOKENS_FOUNDERS=" + contract.TOKENS_FOUNDERS().shift(-decimals));
    console.log("RESULT: sale.TOKENS_ADVISORS=" + contract.TOKENS_ADVISORS().shift(-decimals));
    console.log("RESULT: sale.TOKENS_EARLY_INVESTORS=" + contract.TOKENS_EARLY_INVESTORS().shift(-decimals));
    console.log("RESULT: sale.TOKENS_ACCELERATOR_MAX=" + contract.TOKENS_ACCELERATOR_MAX().shift(-decimals));
    console.log("RESULT: sale.TOKENS_FUTURE=" + contract.TOKENS_FUTURE().shift(-decimals));
    console.log("RESULT: sale.TOKENS_PER_KETHER=" + contract.TOKENS_PER_KETHER());

    console.log("RESULT: sale.finalized=" + contract.finalized());
    console.log("RESULT: sale.endTime=" + contract.endTime() + " " + new Date(contract.endTime() * 1000).toUTCString());
    console.log("RESULT: sale.pausedTime=" + contract.pausedTime() + " " + new Date(contract.pausedTime() * 1000).toUTCString());
    console.log("RESULT: sale.tokensPerKEther=" + contract.tokensPerKEther());
    console.log("RESULT: sale.phase1AccountTokensMax=" + contract.phase1AccountTokensMax().shift(-decimals));
    console.log("RESULT: sale.wallet=" + contract.wallet());
    console.log("RESULT: sale.tokenContract=" + contract.tokenContract());
    console.log("RESULT: sale.trusteeContract=" + contract.trusteeContract());
    console.log("RESULT: sale.totalTokensSold=" + contract.totalTokensSold().shift(-decimals));
    console.log("RESULT: sale.totalPresaleBase=" + contract.totalPresaleBase().shift(-decimals));
    console.log("RESULT: sale.totalPresaleBonus=" + contract.totalPresaleBonus().shift(-decimals));

    var latestBlock = eth.blockNumber;
    var i;

    var ownershipTransferInitiatedEvents = contract.OwnershipTransferInitiated({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferInitiatedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferInitiated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferInitiatedEvents.stopWatching();

    var ownershipTransferCompletedEvents = contract.OwnershipTransferCompleted({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferCompletedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferCompleted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferCompletedEvents.stopWatching();

    var opsAddressChangedEvents = contract.OpsAddressChanged({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    opsAddressChangedEvents.watch(function (error, result) {
      console.log("RESULT: OpsAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    opsAddressChangedEvents.stopWatching();

    var adminAddressChangedEvents = contract.AdminAddressChanged({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    adminAddressChangedEvents.watch(function (error, result) {
      console.log("RESULT: AdminAddressChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    adminAddressChangedEvents.stopWatching();

    var initializedEvents = contract.Initialized({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    initializedEvents.watch(function (error, result) {
      console.log("RESULT: Initialized " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    initializedEvents.stopWatching();

    var presaleAddedEvents = contract.PresaleAdded({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    presaleAddedEvents.watch(function (error, result) {
      console.log("RESULT: PresaleAdded " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    presaleAddedEvents.stopWatching();

    var whitelistUpdatedEvents = contract.WhitelistUpdated({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    whitelistUpdatedEvents.watch(function (error, result) {
      console.log("RESULT: WhitelistUpdated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    whitelistUpdatedEvents.stopWatching();

    var tokensPurchasedEvents = contract.TokensPurchased({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    tokensPurchasedEvents.watch(function (error, result) {
      console.log("RESULT: TokensPurchased " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    tokensPurchasedEvents.stopWatching();

    var tokensPerKEtherUpdatedEvents = contract.TokensPerKEtherUpdated({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    tokensPerKEtherUpdatedEvents.watch(function (error, result) {
      console.log("RESULT: TokensPerKEtherUpdated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    tokensPerKEtherUpdatedEvents.stopWatching();

    var phase1AccountTokensMaxUpdatedEvents = contract.Phase1AccountTokensMaxUpdated({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    phase1AccountTokensMaxUpdatedEvents.watch(function (error, result) {
      console.log("RESULT: Phase1AccountTokensMaxUpdated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    phase1AccountTokensMaxUpdatedEvents.stopWatching();

    var walletChangedEvents = contract.WalletChanged({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    walletChangedEvents.watch(function (error, result) {
      console.log("RESULT: WalletChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    walletChangedEvents.stopWatching();

    var tokensReclaimedEvents = contract.TokensReclaimed({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    tokensReclaimedEvents.watch(function (error, result) {
      console.log("RESULT: TokensReclaimed " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    tokensReclaimedEvents.stopWatching();

    var finalizedEvents = contract.Finalized({}, { fromBlock: saleFromBlock, toBlock: latestBlock });
    i = 0;
    finalizedEvents.watch(function (error, result) {
      console.log("RESULT: Finalized " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    finalizedEvents.stopWatching();

    saleFromBlock = parseInt(latestBlock) + 1;
  }
}