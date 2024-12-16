import React, { useEffect, useState } from "react";
import Web3 from "web3";
import AddLiquidity from "./components/AddLiquidity";
import WithDrawLiquidity from "./components/WithDrawLiquidity";
import ExchangeTokensAForB from "./components/ExchangeTokensAForB";
import ExchangeTokensBForA from "./components/ExchangeTokensBForA";
import GetTherPrice from "./components/GetTherPrice";
import SimpleDEX from "./contracts/SimpleDEX.json";

const App = () => {
	const [contract, setContract] = useState(null);

	useEffect(() => {
		const loadBlockchainData = async () => {
			const web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
			const networkId = await web3.eth.net.getId();
			const deployedNetwork = SimpleDEX.networks[networkId];
			const contractInstance = new web3.eth.Contract(
				SimpleDEX.abi,
				deployedNetwork && deployedNetwork.address
			);
			setContract(contractInstance);
		};

		loadBlockchainData();
	}, []);

	return (
		<div>
			<h1>SimpleDEX</h1>
			{contract && (
				<>
					<AddLiquidity contract={contract} />
					<WithDrawLiquidity contract={contract} />
					<ExchangeTokensAForBAForB contract={contract} />
					<ExchangeTokensBForA contract={contract} />
					<GetTherPrice contract={contract} />
				</>
			)}
		</div>
	);
};

export default App;
