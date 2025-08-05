import { fromBase64, fromHex, normalizeSuiAddress, toBase64 } from '@mysten/sui/utils';
import { getFullnodeUrl, SuiClient } from '@mysten/sui/client';
import { Inputs, Transaction } from '@mysten/sui/transactions';
import { decodeSuiPrivateKey, encodeSuiPrivateKey } from '@mysten/sui/cryptography';
import { Ed25519Keypair } from '@mysten/sui/keypairs/ed25519';


import 'dotenv/config';


function loadSigner() {
	let sk = fromBase64(process.env.ENCODE_SK);
    return Ed25519Keypair.fromSecretKey(sk.slice(1))
}

async function main() {
	const PACKAGE_ID = process.env.PACKAGE_ID;
	const client = new SuiClient({ url: getFullnodeUrl(process.env.NETWORK) });

	const signer = loadSigner();
	const tx = new Transaction();
	const raw_headers = process.env.HEADERS.split(",");
	let headers = [];
	for (let i = 0; i < raw_headers.length; ++i) {
		const header = tx.moveCall({
			target: `${PACKAGE_ID}::block_header::new_block_header`,
			arguments: [
				tx.pure("vector<u8>", fromHex(raw_headers[i]))
			]
		});
		headers.push(header)
	}

	const header_vec = tx.makeMoveVec({
		type: `${PACKAGE_ID}::block_header::BlockHeader`,
		elements: headers,
	})


	tx.moveCall({
		target: `${PACKAGE_ID}::light_client::initialize_light_client`,
		arguments: [
			tx.pure.u8(process.env.BTC_NETWORK),
			tx.pure.u64(process.env.BTC_HEIGHT),
			header_vec,
			tx.pure.u256(process.env.PARENT_CHAIN_WORK),
			tx.pure.u64(process.env.FINALITY)
		]
	})

	let res = await client.signAndExecuteTransaction({
		transaction: tx,
		signer,
		options: {
			showEffects: true,
			showEvents: true
		}
	});

	let result = await client.waitForTransaction({ digest: res.digest });
	console.log(result)
}


main().then(() => {}).catch(err => console.log(err))
