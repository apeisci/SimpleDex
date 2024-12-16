import React, { useState } from "react";
import Web3 from "web3";

const GetThePrice = ({ contract }) => {
	const [amount, setAmount] = useState(0);

	const GetThePrice = async () => {
		const accounts = await window.ethereum.request({
			method: "eth_requestAccounts",
		});
		await contract.methods
			.GetThePrice()
			.send({ from: accounts[0], value: Web3.utils.toWei(amount, "ether") });
	};

	return (
		<div>
			<input
				type="number"
				value={amount}
				onChange={(e) => setAmount(e.target.value)}
			/>
			<button onClick={GetThePrice}>GetThePrice</button>
		</div>
	);
};

export default GetThePrice;
