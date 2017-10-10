# Simple Token Crowdsale Contract Audit

Status: Work in progress

## Summary

[Simple Token](https://simpletoken.org/) intends to run a crowdsale commencing on Nov 14 2017.

Bok Consulting Pty Ltd was commissioned to perform an audit on theSimple Tokens's crowdsale and token Ethereum smart contract.

This audit has been conducted on Simple Tokens's source code in commits
[ed1c05d](https://github.com/SimpleTokenFoundation/SimpleTokenSale/commit/ed1c05df4ec51d8be2bbee601032aec536f9c4b1).

**TODO**: Confirm that no potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

### Crowdsale Mainnet Addresses

`TBA`

<br />

<br />

### Crowdsale Contract

**TODO**

<br />

### Token Contract

**TODO** Confirm [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md) compliance

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
  * [Test 1](#test-1)
  * [Test 2](#test-2)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

* **LOW IMPORTANCE** In *Ownable*, use the [`acceptOwnership(...)`](https://github.com/openanx/OpenANXToken/blob/master/contracts/Owned.sol#L51-L55)
  pattern to improve the safety of ownership transfer process

<br />

<hr />

## Potential Vulnerabilities

**TODO**: Confirm that no potential vulnerabilities have been identified in the crowdsale and token contract.

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

**TODO**

<br />

<hr />

## Testing

### Test 1

**TODO**

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [ ] Deploy the crowdsale/token contract(s)
* [ ] Contribute to the crowdsale contract
* [ ] Finalise the successful crowdsale

<br />

### Test 2

**TODO**

The following functions were tested using the script [test/02_test2.sh](test/02_test2.sh) with the summary results saved
in [test/test2results.txt](test/test2results.txt) and the detailed output saved in [test/test2output.txt](test/test2output.txt):

* [ ] Deploy the crowdsale/token contract(s)
* [ ] Contribute to the crowdsale contract
* [ ] Finalise the unsuccessful crowdsale
* [ ] Investors to execute refunds

<br />

Details of the testing environment can be found in [test](test).

<br />

<hr />

## Code Review

* [ ] [code-review/ERC20Interface.md](code-review/ERC20Interface.md)
  * [ ] contract ERC20Interface
* [ ] [code-review/ERC20Token.md](code-review/ERC20Token.md)
  * [ ] contract ERC20Token is ERC20Interface, Ownable
    * [ ] using SafeMath for uint256
* [ ] [code-review/OpsManaged.md](code-review/OpsManaged.md)
  * [ ] contract OpsManaged is Ownable
* [ ] [code-review/Trustee.md](code-review/Trustee.md)
  * [ ] contract Trustee is OpsManaged
    * [ ] using SafeMath for uint256
* [ ] [code-review/SimpleTokenConfig.md](code-review/SimpleTokenConfig.md)
  * [ ] contract SimpleTokenConfig
* [ ] [code-review/TokenSaleConfig.md](code-review/TokenSaleConfig.md)
  * [ ] contract TokenSaleConfig is SimpleTokenConfig
* [ ] [code-review/SimpleToken.md](code-review/SimpleToken.md)
  * [ ] contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig
* [ ] [code-review/TokenSale.md](code-review/TokenSale.md)
  * [ ] contract TokenSale is OpsManaged, Pausable, TokenSaleConfig
    * [ ] using SafeMath for uint256

<br />

### OpenZeppelin Code Review

* [x] [openzeppelin-code-review/Ownable.md](openzeppelin-code-review/Ownable.md)
  * [x] contract Ownable
* [x] [openzeppelin-code-review/Pausable.md](openzeppelin-code-review/Pausable.md)
  * [x] contract Pausable is Ownable
* [x] [openzeppelin-code-review/SafeMath.md](openzeppelin-code-review/SafeMath.md)
  * [x] library SafeMath

<br />

### Not Reviewed

  * [ ] [code-review/TokenSaleMock.md](code-review/TokenSaleMock.md)
  * [ ] contract TokenSaleMock is TokenSale

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Simple Token - Oct 11 2017. The MIT Licence.