module bitcoin_spv::transaction;
use bitcoin_spv::btc_math::{btc_hash, covert_to_compact_size};

public struct Input has copy, drop {
    tx_id: vector<u8>,
    vout: vector<u8>,
    script_size: u256,
    script_sig: vector<u8>,
    sequece: vector<u8>,
}

public struct Output has copy, drop {
    amount: u256,
    script_pubkey_size: u256, // compact,
    script_pubkey: vector<u8>
}

public struct Transaction has copy, drop {
    version: vector<u8>,
    marker: Option<u8>,
    flag: Option<u8>,
    inputs: vector<Input>,
    outputs: vector<Output>,
    tx_id: vector<u8>,
    witness: vector<u8>,
    look_time: vector<u8>
}


// TODO: better name for this.
// we don't create any new transaction
public fun new_transaction(
    version: vector<u8>,
    marker: Option<u8>,
    flag: Option<u8>,
    inputs: vector<Input>,
    outputs: vector<Output>,
    witness: Option<vector<u8>>,
    lock_time: vector<u8>,
) {

    // let input_compact_size = covert_to_compact_size;


    // // We check inputs wellform
    // // We still do this check because we need ensure all data on transaction
    // // stay on the right place.


    // // check outputs wellform

    // // compute TxID
    // let mut tx_data = x"";
    // tx_data.append(version);
    // tx_data.append(number_input);
    // tx_data.append(inputs);
    // tx_data.append(number_output);
    // tx_data.append(outputs);
    // tx_data.append(lock_time);
    // let tx_id = btc_hash(tx_data);
}

public(package) fun input_wellform(input: &Input): bool {
    (input.tx_id.length() == 32) &&
        (input.vout.length() == 4) &&
        (input.script_sig.length() as u256 == input.script_size) &&
        (input.sequece.length() == 4)
}
