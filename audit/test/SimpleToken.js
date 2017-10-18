var tokenOutput={"contracts":{"ERC20Interface.sol:ERC20Interface":{"abi":"[{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"}]","bin":""},"ERC20Token.sol:ERC20Token":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"_symbol\",\"type\":\"string\"},{\"name\":\"_name\",\"type\":\"string\"},{\"name\":\"_decimals\",\"type\":\"uint8\"},{\"name\":\"_totalSupply\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"}]","bin":"6060604052341561000f57600080fd5b604051610ae8380380610ae883398101604052808051820191906020018051820191906020018051919060200180519150505b5b60018054600160a060020a03191633600160a060020a03161790555b60028480516100729291602001906100bf565b5060038380516100869291602001906100bf565b506004805460ff191660ff84161790556000818155600154600160a060020a031681526005602052604090208190555b5050505061015f565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061010057805160ff191683800117855561012d565b8280016001018555821561012d579182015b8281111561012d578251825591602001919060010190610112565b5b5061013a92915061013e565b5090565b61015c91905b8082111561013a5760008155600101610144565b5090565b90565b61097a8061016e6000396000f300606060405236156100ac5763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166306fdde0381146100b1578063095ea7b31461013c57806318160ddd1461017257806323b872dd14610197578063313ce567146101d357806370a08231146101fc5780638da5cb5b1461022d57806395d89b411461025c578063a9059cbb146102e7578063dd62ed3e1461031d578063f2fde38b14610354575b600080fd5b34156100bc57600080fd5b6100c4610375565b60405160208082528190810183818151815260200191508051906020019080838360005b838110156101015780820151818401525b6020016100e8565b50505050905090810190601f16801561012e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561014757600080fd5b61015e600160a060020a0360043516602435610413565b604051901515815260200160405180910390f35b341561017d57600080fd5b6101856104c0565b60405190815260200160405180910390f35b34156101a257600080fd5b61015e600160a060020a03600435811690602435166044356104c6565b604051901515815260200160405180910390f35b34156101de57600080fd5b6101e6610669565b60405160ff909116815260200160405180910390f35b341561020757600080fd5b610185600160a060020a0360043516610672565b60405190815260200160405180910390f35b341561023857600080fd5b610240610691565b604051600160a060020a03909116815260200160405180910390f35b341561026757600080fd5b6100c46106a0565b60405160208082528190810183818151815260200191508051906020019080838360005b838110156101015780820151818401525b6020016100e8565b50505050905090810190601f16801561012e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34156102f257600080fd5b61015e600160a060020a036004351660243561073e565b604051901515815260200160405180910390f35b341561032857600080fd5b610185600160a060020a0360043581169060243516610857565b60405190815260200160405180910390f35b341561035f57600080fd5b610373600160a060020a0360043516610884565b005b60038054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561040b5780601f106103e05761010080835404028352916020019161040b565b820191906000526020600020905b8154815290600101906020018083116103ee57829003601f168201915b505050505081565b600080821180156104495750600160a060020a033381166000908152600660209081526040808320938716835292905290812054115b15610456575060006104ba565b600160a060020a03338116600081815260066020908152604080832094881680845294909152908190208590557f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9259085905190815260200160405180910390a35060015b92915050565b60005481565b60008115806104ed5750600160a060020a0384166000908152600560205260409020548290105b806105125750600160a060020a03831660009081526005602052604090205482810111155b1561051f57506000610662565b600160a060020a038085166000908152600660209081526040808320339094168352929052205482111561055557506000610662565b600160a060020a03841660009081526005602052604090205461057e908363ffffffff61091d16565b600160a060020a03808616600090815260056020908152604080832094909455600681528382203390931682529190915220546105c1908363ffffffff61091d16565b600160a060020a0380861660009081526006602090815260408083203385168452825280832094909455918616815260059091522054610607908363ffffffff61093416565b600160a060020a03808516600081815260056020526040908190209390935591908616907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9085905190815260200160405180910390a35060015b9392505050565b60045460ff1681565b600160a060020a0381166000908152600560205260409020545b919050565b600154600160a060020a031681565b60028054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561040b5780601f106103e05761010080835404028352916020019161040b565b820191906000526020600020905b8154815290600101906020018083116103ee57829003601f168201915b505050505081565b60008115806107655750600160a060020a0333166000908152600560205260409020548290105b8061078a5750600160a060020a03831660009081526005602052604090205482810111155b15610797575060006104ba565b600160a060020a0333166000908152600560205260409020546107c0908363ffffffff61091d16565b600160a060020a0333811660009081526005602052604080822093909355908516815220546107f5908363ffffffff61093416565b600160a060020a0380851660008181526005602052604090819020939093559133909116907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9085905190815260200160405180910390a35060015b92915050565b600160a060020a038083166000908152600660209081526040808320938516835292905220545b92915050565b60015433600160a060020a0390811691161461089f57600080fd5b600160a060020a03811615156108b457600080fd5b600154600160a060020a0380831691167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a36001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b5b50565b60008282111561092957fe5b508082035b92915050565b60008282018381101561094357fe5b8091505b50929150505600a165627a7a7230582038de62b209e7f9e37e391bb51549b7c39ca526f412f4eb49f3842711f1cdc9710029"},"OpenZepplin/Ownable.sol:Ownable":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]","bin":"6060604052341561000f57600080fd5b5b60008054600160a060020a03191633600160a060020a03161790555b5b61016c8061003c6000396000f300606060405263ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416638da5cb5b8114610048578063f2fde38b14610077575b600080fd5b341561005357600080fd5b61005b610098565b604051600160a060020a03909116815260200160405180910390f35b341561008257600080fd5b610096600160a060020a03600435166100a7565b005b600054600160a060020a031681565b60005433600160a060020a039081169116146100c257600080fd5b600160a060020a03811615156100d757600080fd5b600054600160a060020a0380831691167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b5b505600a165627a7a723058207d79ce5c94987bb42e34af5eea019e697ec7d4388d410b7234610b3eef60909b0029"},"OpenZepplin/SafeMath.sol:SafeMath":{"abi":"[]","bin":"60606040523415600e57600080fd5b5b603680601c6000396000f30060606040525b600080fd00a165627a7a72305820b39bf68c51dad12adbe305d06c641decc75ef8aa32464860576d390a2f3e25160029"},"OpsManaged.sol:OpsManaged":{"abi":"[{\"constant\":false,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"setOperationsAddress\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"isOwnerOrOps\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"operationsAddress\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"isOps\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_newAddress\",\"type\":\"address\"}],\"name\":\"OperationsAddressChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]","bin":"6060604052341561000f57600080fd5b5b5b60008054600160a060020a03191633600160a060020a03161790555b5b5b61036e8061003e6000396000f300606060405236156100755763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663499b8394811461007a5780638da5cb5b146100ad578063adcf59ee146100dc578063ea4cfe121461010f578063ef326c6d1461013e578063f2fde38b14610171575b600080fd5b341561008557600080fd5b610099600160a060020a0360043516610192565b604051901515815260200160405180910390f35b34156100b857600080fd5b6100c061022a565b604051600160a060020a03909116815260200160405180910390f35b34156100e757600080fd5b610099600160a060020a0360043516610239565b604051901515815260200160405180910390f35b341561011a57600080fd5b6100c0610268565b604051600160a060020a03909116815260200160405180910390f35b341561014957600080fd5b610099600160a060020a0360043516610277565b604051901515815260200160405180910390f35b341561017c57600080fd5b610190600160a060020a03600435166102a9565b005b6000805433600160a060020a039081169116146101ae57600080fd5b600054600160a060020a03838116911614156101c957600080fd5b6001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0384169081179091557f3e35a207bfd923192619f1bdadc7c52d3d5961f015e18efd870047dcf71c59e960405160405180910390a25060015b5b919050565b600054600160a060020a031681565b60008054600160a060020a0383811691161480610260575061025a82610277565b15156001145b90505b919050565b600154600160a060020a031681565b600154600090600160a060020a0316158015906102605750600154600160a060020a038381169116145b90505b919050565b60005433600160a060020a039081169116146102c457600080fd5b600160a060020a03811615156102d957600080fd5b600054600160a060020a0380831691167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a36000805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b5b505600a165627a7a72305820e6c3a4f34829469cc314169bf8e6405ac6c8049096204e5c36b088aa765f63070029"},"SimpleToken.sol:SimpleToken":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_NAME\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_SYMBOL\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"setOperationsAddress\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"finalize\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_DECIMALS\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"DECIMALSFACTOR\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKENS_MAX\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"isOwnerOrOps\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"finalized\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"operationsAddress\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"isOps\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[],\"name\":\"Finalized\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_newAddress\",\"type\":\"address\"}],\"name\":\"OperationsAddressChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"}]","bin":"606060405234156200001057600080fd5b5b5b604080519081016040908152600282527f535400000000000000000000000000000000000000000000000000000000000060208301528051908101604052600c81527f53696d706c6520546f6b656e0000000000000000000000000000000000000000602082015260126b0295be96e6406697200000005b5b60018054600160a060020a03191633600160a060020a03161790555b6002848051620000bc9291602001906200011e565b506003838051620000d29291602001906200011e565b506004805460ff191660ff84161790556000818155600154600160a060020a031681526005602052604090208190555b505050505b6007805460a060020a60ff02191690555b620001c8565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106200016157805160ff191683800117855562000191565b8280016001018555821562000191579182015b828111156200019157825182559160200191906001019062000174565b5b50620001a0929150620001a4565b5090565b620001c591905b80821115620001a05760008155600101620001ab565b5090565b90565b610f5280620001d86000396000f300606060405236156101255763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166306fdde03811461012a578063095ea7b3146101b557806318160ddd146101eb578063188214001461021057806323b872dd1461029b5780632a905318146102d7578063313ce56714610362578063499b83941461038b5780634bb278f3146103be5780635b7f415c146103e557806370a082311461040e5780638bc04eb71461043f5780638da5cb5b1461046457806395d89b4114610493578063a67e91a81461051e578063a9059cbb14610543578063adcf59ee14610579578063b3f05b97146105ac578063dd62ed3e146105d3578063ea4cfe121461060a578063ef326c6d14610639578063f2fde38b1461066c575b600080fd5b341561013557600080fd5b61013d61068d565b60405160208082528190810183818151815260200191508051906020019080838360005b8381101561017a5780820151818401525b602001610161565b50505050905090810190601f1680156101a75780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34156101c057600080fd5b6101d7600160a060020a036004351660243561072b565b604051901515815260200160405180910390f35b34156101f657600080fd5b6101fe6107d8565b60405190815260200160405180910390f35b341561021b57600080fd5b61013d6107de565b60405160208082528190810183818151815260200191508051906020019080838360005b8381101561017a5780820151818401525b602001610161565b50505050905090810190601f1680156101a75780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34156102a657600080fd5b6101d7600160a060020a0360043581169060243516604435610815565b604051901515815260200160405180910390f35b34156102e257600080fd5b61013d610836565b60405160208082528190810183818151815260200191508051906020019080838360005b8381101561017a5780820151818401525b602001610161565b50505050905090810190601f1680156101a75780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561036d57600080fd5b61037561086d565b60405160ff909116815260200160405180910390f35b341561039657600080fd5b6101d7600160a060020a0360043516610876565b604051901515815260200160405180910390f35b34156103c957600080fd5b6101d7610910565b604051901515815260200160405180910390f35b34156103f057600080fd5b61037561099d565b60405160ff909116815260200160405180910390f35b341561041957600080fd5b6101fe600160a060020a03600435166109a2565b60405190815260200160405180910390f35b341561044a57600080fd5b6101fe6109c1565b60405190815260200160405180910390f35b341561046f57600080fd5b6104776109cd565b604051600160a060020a03909116815260200160405180910390f35b341561049e57600080fd5b61013d6109dc565b60405160208082528190810183818151815260200191508051906020019080838360005b8381101561017a5780820151818401525b602001610161565b50505050905090810190601f1680156101a75780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561052957600080fd5b6101fe610a7a565b60405190815260200160405180910390f35b341561054e57600080fd5b6101d7600160a060020a0360043516602435610a8a565b604051901515815260200160405180910390f35b341561058457600080fd5b6101d7600160a060020a0360043516610aa9565b604051901515815260200160405180910390f35b34156105b757600080fd5b6101d7610ada565b604051901515815260200160405180910390f35b34156105de57600080fd5b6101fe600160a060020a0360043581169060243516610aea565b60405190815260200160405180910390f35b341561061557600080fd5b610477610b17565b604051600160a060020a03909116815260200160405180910390f35b341561064457600080fd5b6101d7600160a060020a0360043516610b26565b604051901515815260200160405180910390f35b341561067757600080fd5b61068b600160a060020a0360043516610b58565b005b60038054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107235780601f106106f857610100808354040283529160200191610723565b820191906000526020600020905b81548152906001019060200180831161070657829003601f168201915b505050505081565b600080821180156107615750600160a060020a033381166000908152600660209081526040808320938716835292905290812054115b1561076e575060006107d2565b600160a060020a03338116600081815260066020908152604080832094881680845294909152908190208590557f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9259085905190815260200160405180910390a35060015b92915050565b60005481565b60408051908101604052600c81527f53696d706c6520546f6b656e0000000000000000000000000000000000000000602082015281565b60006108213384610bf1565b61082c848484610c39565b90505b9392505050565b60408051908101604052600281527f5354000000000000000000000000000000000000000000000000000000000000602082015281565b60045460ff1681565b60015460009033600160a060020a0390811691161461089457600080fd5b600154600160a060020a03838116911614156108af57600080fd5b6007805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0384169081179091557f3e35a207bfd923192619f1bdadc7c52d3d5961f015e18efd870047dcf71c59e960405160405180910390a25060015b5b919050565b60015460009033600160a060020a0390811691161461092e57600080fd5b60075460a060020a900460ff161561094557600080fd5b6007805474ff0000000000000000000000000000000000000000191660a060020a1790557f6823b073d48d6e3a7d385eeb601452d680e74bb46afe3255a7d778f3a9b1768160405160405180910390a15060015b5b90565b601281565b600160a060020a0381166000908152600560205260409020545b919050565b670de0b6b3a764000081565b600154600160a060020a031681565b60028054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107235780601f106106f857610100808354040283529160200191610723565b820191906000526020600020905b81548152906001019060200180831161070657829003601f168201915b505050505081565b6b0295be96e64066972000000081565b6000610a963384610bf1565b610aa08383610ddc565b90505b92915050565b600154600090600160a060020a0383811691161480610ad25750610acc82610b26565b15156001145b90505b919050565b60075460a060020a900460ff1681565b600160a060020a038083166000908152600660209081526040808320938516835292905220545b92915050565b600754600160a060020a031681565b600754600090600160a060020a031615801590610ad25750600754600160a060020a038381169116145b90505b919050565b60015433600160a060020a03908116911614610b7357600080fd5b600160a060020a0381161515610b8857600080fd5b600154600160a060020a0380831691167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a36001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0383161790555b5b50565b60075460a060020a900460ff1615610c0857610c34565b610c1182610aa9565b80610c295750600154600160a060020a038281169116145b1515610c3457600080fd5b5b5050565b6000811580610c605750600160a060020a0384166000908152600560205260409020548290105b80610c855750600160a060020a03831660009081526005602052604090205482810111155b15610c925750600061082f565b600160a060020a0380851660009081526006602090815260408083203390941683529290522054821115610cc85750600061082f565b600160a060020a038416600090815260056020526040902054610cf1908363ffffffff610ef516565b600160a060020a0380861660009081526005602090815260408083209490945560068152838220339093168252919091522054610d34908363ffffffff610ef516565b600160a060020a0380861660009081526006602090815260408083203385168452825280832094909455918616815260059091522054610d7a908363ffffffff610f0c16565b600160a060020a03808516600081815260056020526040908190209390935591908616907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9085905190815260200160405180910390a35060015b9392505050565b6000811580610e035750600160a060020a0333166000908152600560205260409020548290105b80610e285750600160a060020a03831660009081526005602052604090205482810111155b15610e35575060006107d2565b600160a060020a033316600090815260056020526040902054610e5e908363ffffffff610ef516565b600160a060020a033381166000908152600560205260408082209390935590851681522054610e93908363ffffffff610f0c16565b600160a060020a0380851660008181526005602052604090819020939093559133909116907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9085905190815260200160405180910390a35060015b92915050565b600082821115610f0157fe5b508082035b92915050565b600082820183811015610f1b57fe5b8091505b50929150505600a165627a7a723058202911442750ac1461ac8b0a981571ba8c25da2a06ee674cf39c4db61fa431368b0029"},"SimpleTokenConfig.sol:SimpleTokenConfig":{"abi":"[{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_NAME\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_SYMBOL\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKEN_DECIMALS\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"DECIMALSFACTOR\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"TOKENS_MAX\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]","bin":"6060604052341561000f57600080fd5b5b6102ad8061001f6000396000f300606060405263ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416631882140081146100695780632a905318146100f45780635b7f415c1461017f5780638bc04eb7146101a8578063a67e91a8146101cd575b600080fd5b341561007457600080fd5b61007c6101f2565b60405160208082528190810183818151815260200191508051906020019080838360005b838110156100b95780820151818401525b6020016100a0565b50505050905090810190601f1680156100e65780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34156100ff57600080fd5b61007c610229565b60405160208082528190810183818151815260200191508051906020019080838360005b838110156100b95780820151818401525b6020016100a0565b50505050905090810190601f1680156100e65780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561018a57600080fd5b610192610260565b60405160ff909116815260200160405180910390f35b34156101b357600080fd5b6101bb610265565b60405190815260200160405180910390f35b34156101d857600080fd5b6101bb610271565b60405190815260200160405180910390f35b60408051908101604052600c81527f53696d706c6520546f6b656e0000000000000000000000000000000000000000602082015281565b60408051908101604052600281527f5354000000000000000000000000000000000000000000000000000000000000602082015281565b601281565b670de0b6b3a764000081565b6b0295be96e640669720000000815600a165627a7a72305820313bc4d0be51a5fab535a99ba24acd4a71c751f26928f12d812a6e66d14f0a3b0029"}},"version":"0.4.16+commit.d7661dd9.Darwin.appleclang"};