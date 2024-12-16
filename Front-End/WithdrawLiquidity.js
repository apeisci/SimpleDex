import React, { useState } from "react";
import Web3 from "web3";

const WithdrawLiquidity = ({ contract }) => {
	const [amount, setAmount] = useState(0);

	const WithdrawLiquidity = async () => {
		const accounts = await window.ethereum.request({
			method: "eth_requestAccounts",
		});
		await contract.methods
			.WithdrawLiquidity()
			.send({ from: accounts[0], value: Web3.utils.toWei(amount, "ether") });
	};

	return (
		<div>
			<input
				type="number"
				value={amount}
				onChange={(e) => setAmount(e.target.value)}
			/>
			<button onClick={WithdrawLiquidity}>WithdrawLiquidity</button>
		</div>
	);
};

export default WithdrawLiquidity;
