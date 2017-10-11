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
  STARTTIME=`echo "$CURRENTTIME+150" | bc`
fi
STARTTIME_S=`date -r $STARTTIME -u`
PHASE2TIME=`echo "$CURRENTTIME+60*3" | bc`
PHASE2TIME_S=`date -r $PHASE2TIME -u`
ENDTIME=`echo "$CURRENTTIME+60*4" | bc`
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
`cp -rp $SOURCEDIR/OpenZepplin .`

# --- Modify parameters ---
`perl -pi -e "s/PHASE1_START_TIME         \= 1510660800;.*$/PHASE1_START_TIME         \= $STARTTIME; \/\/ $STARTTIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/PHASE2_START_TIME         \= 1510747200;.*$/PHASE2_START_TIME         \= $PHASE2TIME; \/\/ $PHASE2TIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/END_TIME                  \= 1511265599;.*$/END_TIME                  \= $ENDTIME; \/\/ $ENDTIME_S/" TokenSaleConfig.sol`
`perl -pi -e "s/CONTRIBUTION_MAX          \= 10000.0 ether;.*$/CONTRIBUTION_MAX          \= 100000.0 ether;/" TokenSaleConfig.sol`

DIFFS1=`diff -r $SOURCEDIR . | grep -v "Only in"`
echo "--- Differences diff -r $SOURCEDIR . ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

echo "var tokenOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS
echo "var trusteeOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $TRUSTEESOL`;" > $TRUSTEEJS
echo "var saleOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

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
var tokensForSale = sale.TOKENS_SALE();
console.log("RESULT: tokensForSale=" + tokensForSale);
//    8. Transfer tokens from owner to Trustee contract
var tokensForTrustee = sale.TOKENS_FOUNDERS().add(sale.TOKENS_ADVISORS()).add(sale.TOKENS_EARLY_INVESTORS()).add(sale.TOKENS_ACCELERATOR_MAX());
console.log("RESULT: tokensForTrustee=" + tokensForTrustee);
var tokensForFuture = sale.TOKENS_FUTURE();
console.log("RESULT: tokensForFuture=" + tokensForFuture);
//    9. Initialize TokenSale contract
// -----------------------------------------------------------------------------
console.log("RESULT: " + stitchContractsMessage);
var stitchContracts1Tx = token.setOperationsAddress(saleAddress, {from: contractOwnerAccount, gas: 100000});
var stitchContracts2Tx = trustee.setOperationsAddress(saleAddress, {from: contractOwnerAccount, gas: 100000});
var stitchContracts3Tx = sale.setOperationsAddress(saleOperations, {from: contractOwnerAccount, gas: 100000});
var stitchContracts4Tx = token.transfer(saleAddress, tokensForSale, {from: contractOwnerAccount, gas: 100000});
var stitchContracts5Tx = token.transfer(trusteeAddress, tokensForTrustee, {from: contractOwnerAccount, gas: 100000});
var stitchContracts6Tx = token.transfer(futureTokens, tokensForFuture, {from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
var stitchContracts7Tx = sale.initialize({from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("stitchContracts1Tx", stitchContracts1Tx);
printTxData("stitchContracts2Tx", stitchContracts2Tx);
printTxData("stitchContracts3Tx", stitchContracts3Tx);
printTxData("stitchContracts4Tx", stitchContracts4Tx);
printTxData("stitchContracts5Tx", stitchContracts5Tx);
printTxData("stitchContracts6Tx", stitchContracts6Tx);
printTxData("stitchContracts7Tx", stitchContracts7Tx);
printBalances();
failIfTxStatusError(stitchContracts1Tx, stitchContractsMessage + " - token.setOperationsAddress(sale)");
failIfTxStatusError(stitchContracts2Tx, stitchContractsMessage + " - trustee.setOperationsAddress(sale)");
failIfTxStatusError(stitchContracts3Tx, stitchContractsMessage + " - sale.setOperationsAddress(saleOperations)");
failIfTxStatusError(stitchContracts4Tx, stitchContractsMessage + " - token.transfer(sale, " + tokensForSale.shift(-18) + ")");
failIfTxStatusError(stitchContracts5Tx, stitchContractsMessage + " - token.transfer(trustee, " + tokensForTrustee.shift(-18) + ")");
failIfTxStatusError(stitchContracts6Tx, stitchContractsMessage + " - token.transfer(futureTokens, " + tokensForFuture.shift(-18) + ")");
failIfTxStatusError(stitchContracts7Tx, stitchContractsMessage + " - sale.initialize()");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelistMessage = "Whitelist"; // "And Add Presale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + whitelistMessage);
var whitelist1Tx = sale.updateWhitelist(account4, 1, {from: contractOwnerAccount, gas: 100000});
var whitelist2Tx = sale.updateWhitelist(account5, 2, {from: contractOwnerAccount, gas: 100000});
// var presale1Tx = sale.addPresale(presale, "100000000000000000000", "1000000000000000000", {from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("whitelist1Tx", whitelist1Tx);
printTxData("whitelist2Tx", whitelist2Tx);
// printTxData("presale1Tx", presale1Tx);
printBalances();
failIfTxStatusError(whitelist1Tx, whitelistMessage + " - ac4 phase 1");
failIfTxStatusError(whitelist2Tx, whitelistMessage + " - ac5 phase 2");
// failIfTxStatusError(presale1Tx, whitelistMessage + " - ac10 added presale 100 + 1 bonus");
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
// Wait for Phase 1 start
// -----------------------------------------------------------------------------
var startTime = sale.PHASE1_START_TIME();
var startTimeDate = new Date(startTime * 1000);
console.log("RESULT: Waiting until Phase 1 startTime at " + startTime + " " + startTimeDate + " currentDate=" + new Date());
while ((new Date()).getTime() <= startTimeDate.getTime()) {
}
console.log("RESULT: Waited until Phase 1 startTime at " + startTime + " " + startTimeDate + " currentDate=" + new Date());


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution Phase 1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account4, to: saleAddress, gas: 400000, value: web3.toWei("1", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("1", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac4 1 ETH");
passIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac5 1 ETH - Expecting Failure");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
// Wait for Phase 2 start
// -----------------------------------------------------------------------------
var startTime = sale.PHASE2_START_TIME();
var startTimeDate = new Date(startTime * 1000);
console.log("RESULT: Waiting until Phase 2 startTime at " + startTime + " " + startTimeDate + " currentDate=" + new Date());
while ((new Date()).getTime() <= startTimeDate.getTime()) {
}
console.log("RESULT: Waited until Phase 2 startTime at " + startTime + " " + startTimeDate + " currentDate=" + new Date());


// -----------------------------------------------------------------------------
var sendContribution2Message = "Send Contribution Phase 2";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution2Message);
var sendContribution2_1Tx = eth.sendTransaction({from: account4, to: saleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution2_2Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution2_1Tx", sendContribution2_1Tx);
printTxData("sendContribution2_2Tx", sendContribution2_2Tx);
printBalances();
failIfTxStatusError(sendContribution2_1Tx, sendContribution2Message + " - ac4 10 ETH");
failIfTxStatusError(sendContribution2_2Tx, sendContribution2Message + " - ac5 10 ETH");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContribution3Message = "Max Out Contribution Phase 2";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution3Message);
var sendContribution3_1Tx = eth.sendTransaction({from: account4, to: saleAddress, gas: 400000, value: web3.toWei("100000", "ether")});
var sendContribution3_2Tx = eth.sendTransaction({from: account5, to: saleAddress, gas: 400000, value: web3.toWei("100000", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution3_1Tx", sendContribution3_1Tx);
printTxData("sendContribution3_2Tx", sendContribution3_2Tx);
printBalances();
failIfTxStatusError(sendContribution3_1Tx, sendContribution3Message + " - ac4 100,000 ETH - Expecting 1 partial");
failIfTxStatusError(sendContribution3_2Tx, sendContribution3Message + " - ac5 100,000 ETH - Expecting 1 partial");
printTokenContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finaliseMessage = "Finalise";
// -----------------------------------------------------------------------------
console.log("RESULT: " + finaliseMessage);
var finalise1Tx = sale.finalize({from: contractOwnerAccount, gas: 100000});
var finalise2Tx = token.finalize({from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("finalise1Tx", finalise1Tx);
printTxData("finalise2Tx", finalise2Tx);
printBalances();
failIfTxStatusError(finalise1Tx, finaliseMessage + " - sale");
failIfTxStatusError(finalise2Tx, finaliseMessage + " - token");
printTokenContractDetails();
printTrusteeContractDetails();
printSaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken1Message = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken1Message);
var moveToken1_1Tx = token.transfer(account6, "100000000000000000", {from: account4, gas: 100000});
var moveToken1_2Tx = token.approve(account7,  "3000000000000000000", {from: account5, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken1_3Tx = token.transferFrom(account5, account8, "3000000000000000000", {from: account7, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("moveToken1_1Tx", moveToken1_1Tx);
printTxData("moveToken1_2Tx", moveToken1_2Tx);
printTxData("moveToken1_3Tx", moveToken1_3Tx);
printBalances();
failIfTxStatusError(moveToken1_1Tx, moveToken1Message + " - transfer 0.1 ST ac4 -> ac6");
failIfTxStatusError(moveToken1_2Tx, moveToken1Message + " - approve 3 ST ac5 -> ac7");
failIfTxStatusError(moveToken1_3Tx, moveToken1Message + " - transferFrom 3 ST ac5 -> ac8 by ac7");
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
