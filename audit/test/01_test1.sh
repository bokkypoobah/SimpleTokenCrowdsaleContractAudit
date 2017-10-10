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
  # Start time 1m 10s in the future
  STARTTIME=`echo "$CURRENTTIME+90" | bc`
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

# `perl -pi -e "s/bool transferable/bool public transferable/" $TOKENSOL`
# `perl -pi -e "s/MULTISIG_WALLET_ADDRESS \= 0xc79ab28c5c03f1e7fbef056167364e6782f9ff4f;/MULTISIG_WALLET_ADDRESS \= 0xa22AB8A9D641CE77e06D98b7D7065d324D3d6976;/" GimliCrowdsale.sol`
# `perl -pi -e "s/END_DATE = 1508500800;.*$/END_DATE \= $ENDTIME; \/\/ $ENDTIME_S/" GimliCrowdsale.sol`
# `perl -pi -e "s/VESTING_1_DATE = 1537272000;.*$/VESTING_1_DATE \= $VESTING1TIME; \/\/ $VESTING1TIME_S/" GimliCrowdsale.sol`
# `perl -pi -e "s/VESTING_2_DATE = 1568808000;.*$/VESTING_2_DATE \= $VESTING2TIME; \/\/ $VESTING2TIME_S/" GimliCrowdsale.sol`

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



exit;

// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Crowdsale/Token Contract";
console.log("RESULT: old='" + tokenBin + "'");
var newTokenBin = tokenBin.replace(/__BATTToken\.sol\:SafeMath________________/g, libAddress.substring(2, 42));
console.log("RESULT: new='" + newTokenBin + "'");
var symbol = "TST";
var name = "Test";
var decimals = 18;
var initialSupply = "10000000000000000000000000";
// -----------------------------------------------------------------------------
console.log("RESULT: " + tokenMessage);
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;

var token = tokenContract.new(symbol, name, decimals, initialSupply,
    {from: contractOwnerAccount, data: newTokenBin, gas: 6000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);

while (txpool.status.pending > 0) {
}

printTxData("tokenAddress=" + tokenAddress, tokenTx);
printBalances();
failIfTxStatusError(tokenTx, tokenMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var mintTokensMessage = "Mint Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + mintTokensMessage);
var mintTokens1Tx = token.mint(account3, "1000000000000000000000000", {from: contractOwnerAccount, gas: 100000});
var mintTokens2Tx = token.mint(account4, "1000000000000000000000000", {from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("mintTokens1Tx", mintTokens1Tx);
printTxData("mintTokens2Tx", mintTokens2Tx);
printBalances();
failIfTxStatusError(mintTokens1Tx, mintTokensMessage + " - mint 1,000,000 tokens 0x0 -> ac3");
failIfTxStatusError(mintTokens2Tx, mintTokensMessage + " - mint 1,000,000 tokens 0x0 -> ac4");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var startTransfersMessage = "Start Transfers";
// -----------------------------------------------------------------------------
console.log("RESULT: " + startTransfersMessage);
var startTransfers1Tx = token.disableMinting({from: contractOwnerAccount, gas: 100000});
var startTransfers2Tx = token.enableTransfers({from: contractOwnerAccount, gas: 100000});
while (txpool.status.pending > 0) {
}
printTxData("startTransfers1Tx", startTransfers1Tx);
printTxData("startTransfers2Tx", startTransfers2Tx);
printBalances();
failIfTxStatusError(startTransfers1Tx, startTransfersMessage + " - Disable Minting");
failIfTxStatusError(startTransfers2Tx, startTransfersMessage + " - Enable Transfers");
printTokenContractDetails();
console.log("RESULT: ");


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
