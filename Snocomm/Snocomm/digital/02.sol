var contract_obj = proofContract.at($.{""});
	contract_obj.set.sendTransaction("Owner Name", $.{""}, {
		from: web3.eth.accounts[0],
	},	function(error, transactionHash) {
		if (!err)
			console.log(transactionHash)
	}
)

contract_obj.get.call($.{""})