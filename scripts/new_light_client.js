import { fromHex, fromBase64 } from "@mysten/sui/utils";
import { getFullnodeUrl, SuiClient } from "@mysten/sui/client";
import { Transaction } from "@mysten/sui/transactions";
import { Ed25519Keypair } from "@mysten/sui/keypairs/ed25519";

import "dotenv/config";

function mkSigner() {
	if (process.env.ENCODE_SK) {
		let sk = fromBase64(process.env.ENCODE_SK);
		return Ed25519Keypair.fromSecretKey(sk.slice(1));
	}
	if (process.env.MNEMONIC) {
		return Ed25519Keypair.deriveKeypair(process.env.MNEMONIC);
	}
	throw new Error(
		"Missing required environment variable: Please set either ENCODE_SK or MNEMONIC.",
	);
}

async function main() {
	const SPV_PACKAGE_ID = process.env.SPV_PACKAGE_ID;
	const PARSER_PACKAGE_ID = process.env.PARSER_PACKAGE_ID;
	const client = new SuiClient({ url: getFullnodeUrl(process.env.NETWORK) });

	const signer = mkSigner();
	const tx = new Transaction();
	const raw_headers = process.env.HEADERS.split(",");
	let headers = [];
	for (let i = 0; i < raw_headers.length; ++i) {
		const header = tx.moveCall({
			target: `${PARSER_PACKAGE_ID}::header::new`,
			arguments: [tx.pure("vector<u8>", fromHex(raw_headers[i]))],
		});
		headers.push(header);
	}

	const header_vec = tx.makeMoveVec({
		type: `${PARSER_PACKAGE_ID}::header::BlockHeader`,
		elements: headers,
	});

	tx.moveCall({
		target: `${SPV_PACKAGE_ID}::light_client::initialize_light_client`,
		arguments: [
			tx.pure.u8(process.env.BTC_NETWORK),
			tx.pure.u64(process.env.BTC_HEIGHT),
			header_vec,
			tx.pure.u256(process.env.PARENT_CHAIN_WORK),
			tx.pure.u64(process.env.CONFIRMATION_DEPTH),
		],
	});

	let res = await client.signAndExecuteTransaction({
		transaction: tx,
		signer,
		options: {
			showEffects: true,
			showEvents: true,
		},
	});

	await client.waitForTransaction({ digest: res.digest });

	console.log(JSON.stringify(res.events[0].parsedJson, null, 2));
}

main()
	.then(() => {})
	.catch((err) => console.log(err));
