import React, { useState } from "react";
import Web3 from "web3";

const AddLiquidity = ({ contract }) => {
	const [amount, setAmount] = useState(0);

	const addLiquidity = async () => {
		const accounts = await window.ethereum.request({
			method: "eth_requestAccounts",
		});
		await contract.methods
			.addLiquidity()
			.send({ from: accounts[0], value: Web3.utils.toWei(amount, "ether") });
	};

	return (
		<div>
			<input
				type="number"
				value={amount}
				onChange={(e) => setAmount(e.target.value)}
			/>
			<button onClick={addLiquidity}>Add Liquidity</button>
		</div>
	);
};

export default AddLiquidity;
