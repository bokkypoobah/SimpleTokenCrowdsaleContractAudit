#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`
TRUSTEESOL=`grep ^TRUSTEESOL= settings.txt | sed "s/^.*=//"`
TRUSTEEJS=`grep ^TRUSTEEJS= settings.txt | sed "s/^.*=//"`
CROWDSALESOL=`grep ^CROWDSALESOL= settings.txt | sed "s/^.*=//"`
CROWDSALEJS=`grep ^CROWDSALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

BLOCKSINDAY=10

if [ "$MODE" == "dev" ]; then
  # Start time now
  STARTTIME=`echo "$CURRENTTIME" | bc`
else
  # Start time 2m 30s in the future
  STARTTIME=`echo "$CURRENTTIME+210" | bc`
fi
STARTTIME_S=`date -r $STARTTIME -u`
PHASE2TIME=`echo "$CURRENTTIME+240" | bc`
PHASE2TIME_S=`date -r $PHASE2TIME -u`
ENDTIME=`echo "$CURRENTTIME+300" | bc`
ENDTIME_S=`date -r $ENDTIME -u`

printf "MODE            = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD        = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR       = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "TOKENSOL        = '$TOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "TOKENJS         = '$TOKENJS'\n" | tee -a $TEST1OUTPUT
printf "TRUSTEESOL      = '$TRUSTEESOL'\n" | tee -a $TEST1OUTPUT
printf "TRUSTEEJS       = '$TRUSTEEJS'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALESOL    = '$CROWDSALESOL'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALEJS     = '$CROWDSALEJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA  = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS       = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT     = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS    = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME     = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "STARTTIME       = '$STARTTIME' '$STARTTIME_S'\n" | tee -a $TEST1OUTPUT
printf "PHASE2TIME      = '$PHASE2TIME' '$PHASE2TIME_S'\n" | tee -a $TEST1OUTPUT
printf "ENDTIME         = '$ENDTIME' '$ENDTIME_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
# `cp modifiedContracts/SnipCoin.sol .`
`cp -rp $SOURCEDIR/*.sol .`
# `cp -rp modifiedContracts/*.sol .`

# --- Modify parameters ---
`perl -pi -e "s/PHASE1_START_TIME         \= 1510664400;.*$/PHASE1_START_TIME         \= $STARTTIME; \/\/ $STARTTIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/PHASE2_START_TIME         \= 1510750800;.*$/PHASE2_START_TIME         \= $PHASE2TIME; \/\/ $PHASE2TIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/END_TIME                  \= 1511269199;.*$/END_TIME                  \= $ENDTIME; \/\/ $ENDTIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/CONTRIBUTION_MAX          \= 10000.0 ether;.*$/CONTRIBUTION_MAX          \= 100000.0 ether;/" TokenSaleConfig.sol`

DIFFS1=`diff -r $SOURCEDIR . | grep -v "Only in"`
echo "--- Differences diff -r $SOURCEDIR . ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

echo "var tokenOutput=`solc --optimize --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS
echo "var trusteeOutput=`solc --optimize --combined-json abi,bin,interface $TRUSTEESOL`;" > $TRUSTEEJS
echo "var saleOutput=`solc --optimize --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS


geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("$TRUSTEEJS");
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:SimpleToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:SimpleToken"].bin;
var trusteeAbi = JSON.parse(trusteeOutput.contracts["$TRUSTEESOL:Trustee"].abi);
var trusteeBin = "0x" + trusteeOutput.contracts["$TRUSTEESOL:Trustee"].bin;
var saleAbi = JSON.parse(saleOutput.contracts["$CROWDSALESOL:TokenSale"].abi);
var saleBin = "0x" + saleOutput.contracts["$CROWDSALESOL:TokenSale"].bin;

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));
// console.log("DATA: trusteeAbi=" + JSON.stringify(trusteeAbi));
// console.log("DATA: trusteeBin=" + JSON.stringify(trusteeBin));
// console.log("DATA: saleAbi=" + JSON.stringify(saleAbi));
// console.log("DATA: saleBin=" + JSON.stringify(saleBin));

unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenMessage = "Deploy Token Contract";
var deployTrusteeMessage = "Deploy Trustee Contract";
var deploySaleMessage = "Deploy Sale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployTokenMessage);
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;

console.log("RESULT: " + deployTrusteeMessage);
var trusteeContract = web3.eth.contract(trusteeAbi);
// console.log(JSON.stringify(trusteeContract));
var trusteeTx = null;
var trusteeAddress = null;

console.log("RESULT: " + deploySaleMessage);
var saleContract = web3.eth.contract(saleAbi);
// console.log(JSON.stringify(saleContract));
var saleTx = null;
var saleAddress = null;

var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);

while (txpool.status.pending > 0) {
}

var trustee = trusteeContract.new(tokenAddress, {from: contractOwnerAccount, data: trusteeBin, gas: 6000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        trusteeTx = contract.transactionHash;
      } else {
        trusteeAddress = contract.address;
        addTrusteeContractAddressAndAbi(trusteeAddress, trusteeAbi);
        addAccount(trusteeAddress, "Trustee");
        console.log("DATA: trusteeAddress=" + trusteeAddress);
      }
    }
  }
);

while (txpool.status.pending > 0) {
}

var sale = saleContract.new(tokenAddress, trusteeAddress, wallet, {from: contractOwnerAccount, data: saleBin, gas: 6000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        saleTx = contract.transactionHash;
      } else {
        saleAddress = contract.address;
        addSaleContractAddressAndAbi(saleAddress, saleAbi);
        addAccount(saleAddress, "Sale");
        console.log("DATA: saleAddress=" + saleAddress);
      }
    }
  }
);

while (txpool.status.pending > 0) {
}

printTxData("tokenAddress=" + tokenAddress, tokenTx);
printTxData("trusteeAddress=" + trusteeAddress, trusteeTx);
printTxData("saleAddress=" + saleAddress, saleTx);
printBalances();
failIfTxStatusError(tokenTx, deployTokenMessage);
failIfTxStatusError(trusteeTx, deployTrusteeMessage);
failIfTxStatusError(saleTx, deploySaleMessage);
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var stitchContractsMessage = "Stitch Contracts Together";
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
// Email from Antoine
// * [x] const token     = await SimpleToken.new({ from: accounts[0], gas: 3500000 })
// * [x] const trustee   = await Trustee.new(token.address, { from: accounts[0], gas: 3500000 })
// * [x] const sale       = await TokenSale.new(token.address, trustee.address, accounts[0], { from: accounts[0], gas: 4500000 })
// 
// await token.setOpsAddress(sale.address)
// await trustee.setOpsAddress(sale.address)
// await sale.setAdminAddress(accounts[1])
// await sale.setOpsAddress(accounts[2])
// 
// const TOKENS_MAX    = await sale.TOKENS_MAX.call()
// const TOKENS_SALE   = await sale.TOKENS_SALE.call()
// const TOKENS_FUTURE = await sale.TOKENS_FUTURE.call()
// 
// const trusteeTokens = TOKENS_MAX.sub(TOKENS_SALE).sub(TOKENS_FUTURE)
// 
// await token.transfer(sale.address, TOKENS_SALE, { from: accounts[0] })
// await token.transfer(trustee.address, trusteeTokens, { from: accounts[0] })
//  
// await sale.initialize({ from: accounts[0] })
// 
// await sale.addPresale(accounts[3], 1000, 100, { from: admin })
// -----------------------------------------------------------------------------
var tokensForSale = sale.TOKENS_SALE();
console.log("RESULT: tokensForSale=" + tokensForSale);
// var tokensForTrustee = sale.TOKENS_FOUNDERS().add(sale.TOKENS_ADVISORS()).add(sale.TOKENS_EARLY_INVESTORS()).add(sale.TOKENS_ACCELERATOR_MAX()).add(sale.TOKENS_FUTURE());
var tokensForTrustee = sale.TOKENS_MAX().sub(sale.TOKENS_SALE()).sub(sale.TOKENS_FUTURE());
console.log("RESULT: tokensForTrustee=" + tokensForTrustee);

console.log("RESULT: " + stitchContractsMessage);
var stitchContracts1Tx = token.setOpsAddress(saleAddress, {from: contractOwnerAccount, gas: 100000});
var stitchContracts2Tx = token.setAdminAddress(adminAccount, {from: contractOwnerAccount, gas: 100000});
var stitchContracts3Tx = trustee.setOpsAddress(saleAddress, {from: contractOwnerAccount, gas: 100000});
var stitchContracts4Tx = trustee.setRevokeAddress(revokeAccount, {from: contractOwnerAccount, gas: 100000});
var stitchContracts5Tx = trustee.setAdminAddress(adminAccount, {from: contractOwnerAccount, gas: 100000});
var stitchContracts6Tx = sale.setOpsAddress(opsAccount, {from: contractOwnerAccount, gas: 100000});
var stitchContracts7Tx = sale.setAdminAddress(adminAccount, {from: contractOwnerAccount, gas: 100000});
var stitchContracts8Tx = token.transfer(saleAddress, tokensForSale, {from: contractOwnerAccount, gas: 100000});
var stitchContracts9Tx = token.transfer(trusteeAddress, tokensForTrustee, {from: contractOwnerAccount, gas: 100000});
var stitchContracts10Tx = sale.initialize({from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
var stitchContracts6Tx = sale.initialize({from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("stitchContracts1Tx", stitchContracts1Tx);
printTxData("stitchContracts2Tx", stitchContracts2Tx);
printTxData("stitchContracts3Tx", stitchContracts3Tx);
printTxData("stitchContracts4Tx", stitchContracts4Tx);
printTxData("stitchContracts5Tx", stitchContracts5Tx);
printTxData("stitchContracts6Tx", stitchContracts6Tx);
printTxData("stitchContracts7Tx", stitchContracts7Tx);
printTxData("stitchContracts8Tx", stitchContracts8Tx);
printTxData("stitchContracts9Tx", stitchContracts9Tx);
printTxData("stitchContracts10Tx", stitchContracts10Tx);
printBalances();
failIfTxStatusError(stitchContracts1Tx, stitchContractsMessage + " - token.setOpsAddress(sale)");
failIfTxStatusError(stitchContracts2Tx, stitchContractsMessage + " - token.setAdminAddress(adminAccount)");
failIfTxStatusError(stitchContracts3Tx, stitchContractsMessage + " - trustee.setOpsAddress(sale)");
failIfTxStatusError(stitchContracts4Tx, stitchContractsMessage + " - trustee.setRevokeAddress(revokeAccount)");
failIfTxStatusError(stitchContracts5Tx, stitchContractsMessage + " - trustee.setAdminAddress(adminAccount)");
failIfTxStatusError(stitchContracts6Tx, stitchContractsMessage + " - sale.setOpsAddress(opsAccount)");
failIfTxStatusError(stitchContracts7Tx, stitchContractsMessage + " - sale.setAdminAddress(adminAccount)");
failIfTxStatusError(stitchContracts8Tx, stitchContractsMessage + " - token.transfer(sale, " + tokensForSale.shift(-18) + ")");
failIfTxStatusError(stitchContracts9Tx, stitchContractsMessage + " - token.transfer(trustee, " + tokensForTrustee.shift(-18) + ")");
failIfTxStatusError(stitchContracts10Tx, stitchContractsMessage + " - sale.initialize()");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var presaleMessage = "Pre-sale Sequence #1";
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
// -----------------------------------------------------------------------------
console.log("RESULT: " + presaleMessage);
var presale1Tx = sale.setTokensPerKEther(2000000, {from: adminAccount, gas: 100000});
var presale2Tx = sale.setPhase1AccountTokensMax(20000000000000000000000, {from: adminAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("presale1Tx", presale1Tx);
printTxData("presale2Tx", presale2Tx);
printBalances();
failIfTxStatusError(presale1Tx, presaleMessage + " - sale.setTokensPerKEther(2000000)");
failIfTxStatusError(presale2Tx, presaleMessage + " - sale.phase1AccountTokensMax(20000)");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelistMessage = "Pre-sale Sequence #1 - Presale + Whitelist";
// -----------------------------------------------------------------------------
console.log("RESULT: " + whitelistMessage);
var addPresale1Tx = sale.addPresale(presale1, "10000000000000000000000", "100000000000000000000", {from: adminAccount, gas: 200000});
var addPresale2Tx = sale.addPresale(presale2, "10000000000000000000000", "100000000000000000000", {from: adminAccount, gas: 200000});
var whitelist1Tx = sale.updateWhitelist(account5, 1, {from: opsAccount, gas: 100000});
var whitelist2Tx = sale.updateWhitelist(account6, 2, {from: opsAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("addPresale1Tx", addPresale1Tx);
printTxData("addPresale2Tx", addPresale2Tx);
printTxData("whitelist1Tx", whitelist1Tx);
printTxData("whitelist2Tx", whitelist2Tx);
printBalances();
failIfTxStatusError(addPresale1Tx, whitelistMessage + " - ac11 added presale 10000 + 100 bonus");
failIfTxStatusError(addPresale2Tx, whitelistMessage + " - ac12 added presale 10000 + 100 bonus");
failIfTxStatusError(whitelist1Tx, whitelistMessage + " - ac5 phase 1");
failIfTxStatusError(whitelist2Tx, whitelistMessage + " - ac6 phase 2");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
// Wait for Phase 1 start
// -----------------------------------------------------------------------------
waitUntil("PHASE1_START_TIME()", sale.PHASE1_START_TIME(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution Phase 1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("1", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account6, to: saleAddress, gas: 400000, value: web3.toWei("1", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac5 1 ETH");
passIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac6 1 ETH - Expecting Failure");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
// Wait for Phase 2 start
// -----------------------------------------------------------------------------
waitUntil("PHASE2_START_TIME()", sale.PHASE2_START_TIME(), 0);


// -----------------------------------------------------------------------------
var sendContribution2Message = "Send Contribution Phase 2";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution2Message);
var sendContribution2_1Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution2_2Tx = eth.sendTransaction({from: account6, to: saleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution2_1Tx", sendContribution2_1Tx);
printTxData("sendContribution2_2Tx", sendContribution2_2Tx);
printBalances();
failIfTxStatusError(sendContribution2_1Tx, sendContribution2Message + " - ac5 10 ETH");
failIfTxStatusError(sendContribution2_2Tx, sendContribution2Message + " - ac6 10 ETH");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContribution3Message = "Max Out Contribution Phase 2";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution3Message);
var sendContribution3_1Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("100000", "ether")});
var sendContribution3_2Tx = eth.sendTransaction({from: account6, to: saleAddress, gas: 400000, value: web3.toWei("100000", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution3_1Tx", sendContribution3_1Tx);
printTxData("sendContribution3_2Tx", sendContribution3_2Tx);
printBalances();
failIfTxStatusError(sendContribution3_1Tx, sendContribution3Message + " - ac5 100,000 ETH - Expecting 1 partial");
failIfTxStatusError(sendContribution3_2Tx, sendContribution3Message + " - ac6 100,000 ETH - Expecting 1 partial");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finaliseMessage = "Finalise";
// -----------------------------------------------------------------------------
console.log("RESULT: " + finaliseMessage);
var finalise1Tx = sale.finalize({from: adminAccount, gas: 100000});
var finalise2Tx = token.finalize({from: adminAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("finalise1Tx", finalise1Tx);
printTxData("finalise2Tx", finalise2Tx);
printBalances();
passIfTxStatusError(finalise1Tx, finaliseMessage + " - sale - expecting revert as the sale was automatically finalised");
failIfTxStatusError(finalise2Tx, finaliseMessage + " - token");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken1Message = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken1Message);
var moveToken1_1Tx = token.transfer(account7, "100000000000000000", {from: account5, gas: 100000});
var moveToken1_2Tx = token.approve(account8,  "3000000000000000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken1_3Tx = token.transferFrom(account6, account9, "3000000000000000000", {from: account8, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("moveToken1_1Tx", moveToken1_1Tx);
printTxData("moveToken1_2Tx", moveToken1_2Tx);
printTxData("moveToken1_3Tx", moveToken1_3Tx);
printBalances();
failIfTxStatusError(moveToken1_1Tx, moveToken1Message + " - transfer 0.1 ST ac5 -> ac7");
failIfTxStatusError(moveToken1_2Tx, moveToken1Message + " - approve 3 ST ac6 -> ac8");
failIfTxStatusError(moveToken1_3Tx, moveToken1Message + " - transferFrom 3 ST ac6 -> ac9 by ac8");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var processAllocationMessage = "Process Trustee Allocation";
// -----------------------------------------------------------------------------
console.log("RESULT: " + processAllocationMessage);
var changeTrusteeOpsTx = trustee.setOpsAddress(opsAccount, {from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
var processAllocation1Tx = trustee.processAllocation(presale1,  "10000000000000000000000", {from: opsAccount, gas: 100000});
var processAllocation2Tx = trustee.processAllocation(presale2,  "9000000000000000000000", {from: opsAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("changeTrusteeOpsTx", changeTrusteeOpsTx);
printTxData("processAllocation1Tx", processAllocation1Tx);
printTxData("processAllocation2Tx", processAllocation2Tx);
printBalances();
failIfTxStatusError(changeTrusteeOpsTx, processAllocationMessage + " - Change trustee ops account to opsAccount");
failIfTxStatusError(processAllocation1Tx, processAllocationMessage + " - processAllocation ac11 10000");
failIfTxStatusError(processAllocation2Tx, processAllocationMessage + " - processAllocation ac12 9000");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var reclaimTrusteeAllocationMessage = "Reclaim Trustee Allocation";
// -----------------------------------------------------------------------------
console.log("RESULT: " + reclaimTrusteeAllocationMessage);
var reclaimTrusteeAllocationTx = trustee.reclaimTokens({from: adminAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("reclaimTrusteeAllocationTx", reclaimTrusteeAllocationTx);
printBalances();
failIfTxStatusError(reclaimTrusteeAllocationTx, reclaimTrusteeAllocationMessage);
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");




exit;

// -----------------------------------------------------------------------------
var transferTokenMessage = "Transfer Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + transferTokenMessage);
var transferToken1Tx = token.transfer(account3, "100000000000000000000", {from: contractOwnerAccount, gas: 100000});
var transferToken2Tx = token.transfer(account4, "100000000000000000000", {from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("transferToken1Tx", transferToken1Tx);
printTxData("transferToken2Tx", transferToken2Tx);
printBalances();
failIfTxStatusError(transferToken1Tx, transferTokenMessage + " - transfer 10,000 tokens ac1 -> ac3");
failIfTxStatusError(transferToken2Tx, transferTokenMessage + " - transfer 10,000 tokens ac1 -> ac4");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTokenMessage = "Move 0 Tokens After Transfers Allowed";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveTokenMessage);
var moveToken1Tx = token.transfer(account5, "0", {from: account3, gas: 100000});
var moveToken3Tx = token.transferFrom(account4, account7, "0", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("moveToken1Tx", moveToken1Tx);
printTxData("moveToken3Tx", moveToken3Tx);
printBalances();
failIfTxStatusError(moveToken1Tx, moveTokenMessage + " - transfer 0 tokens ac3 -> ac5. SHOULD not throw");
failIfTxStatusError(moveToken3Tx, moveTokenMessage + " - transferFrom 0 tokens ac4 -> ac7 by ac6. SHOULD not throw");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTokenMessage = "Move More Tokens Than Owned";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveTokenMessage);
var moveToken1Tx = token.transfer(account5, "3000000000000000000000001", {from: account3, gas: 100000});
var moveToken2Tx = token.approve(account6,  "3000000000000000000000001", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken3Tx = token.transferFrom(account4, account7, "3000000000000000000000001", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("moveToken1Tx", moveToken1Tx);
printTxData("moveToken2Tx", moveToken2Tx);
printTxData("moveToken3Tx", moveToken3Tx);
printBalances();
passIfTxStatusError(moveToken1Tx, moveTokenMessage + " - transfer 300K+1e-18 tokens ac3 -> ac5. SHOULD throw");
failIfTxStatusError(moveToken2Tx, moveTokenMessage + " - approve 300K+1e-18 tokens ac4 -> ac6");
passIfTxStatusError(moveToken3Tx, moveTokenMessage + " - transferFrom 300K+1e-18 tokens ac4 -> ac7 by ac6. SHOULD throw");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var approveTokenMessage = "Change Approval Without Setting To 0";
// -----------------------------------------------------------------------------
console.log("RESULT: " + approveTokenMessage);
var approveToken2Tx = token.approve(account6,  "3000000000000000000000002", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("approveToken2Tx", approveToken2Tx);
printBalances();
passIfTxStatusError(approveToken2Tx, approveTokenMessage + " - approve 300K+2e-18 tokens ac4 -> ac6. SHOULD throw");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var approveTokenMessage = "Change Approval By Setting To 0 In Between";
// -----------------------------------------------------------------------------
console.log("RESULT: " + approveTokenMessage);
var approveToken2Tx = token.approve(account6,  "0", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var approveToken3Tx = token.approve(account6,  "3000000000000000000000002", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("approveToken2Tx", approveToken2Tx);
printTxData("approveToken3Tx", approveToken3Tx);
printBalances();
failIfTxStatusError(approveToken2Tx, approveTokenMessage + " - approve 0 tokens ac4 -> ac6");
failIfTxStatusError(approveToken3Tx, approveTokenMessage + " - approve 300K+2e-18 tokens ac4 -> ac6");
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
