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
    amount: vector<u8>,
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


    let number_input = covert_to_compact_size(inputs.length() as u256);
    let number_output = covert_to_compact_size(outputs.length() as u256);

    let inputs_bytes = inputs_to_bytes(inputs);
    let outputs_bytes = outputs_to_bytes(outputs);
    // // compute TxID
    let mut tx_data = x"";
    tx_data.append(version);
    tx_data.append(number_input);
    tx_data.append(inputs_bytes);
    tx_data.append(number_output);
    tx_data.append(outputs_bytes);
    tx_data.append(lock_time);
    let tx_id = btc_hash(tx_data);
}

public(package) fun input_wellform(input: &Input): bool {
    (input.tx_id.length() == 32) &&
        (input.vout.length() == 4) &&
        (input.script_sig.length() as u256 == input.script_size) &&
        (input.sequece.length() == 4)
}

public(package) fun output_wellform(output: &Output): bool {
    (output.amount.length() == 8) &&
        (output.script_pubkey_size == output.script_pubkey.length() as u256)
}

public(package) fun inputs_to_bytes(inputs: vector<Input>) : vector<u8> {
    let mut decoded_bytes = vector[];
    inputs.length().do!(|i| {
        decoded_bytes.append(inputs[i].tx_id);
        decoded_bytes.append(inputs[i].vout);
        decoded_bytes.append(covert_to_compact_size(inputs[i].script_size));
        decoded_bytes.append(inputs[i].script_sig);
    });
    decoded_bytes
}

public(package) fun outputs_to_bytes(outputs: vector<Output>): vector<u8> {
    let mut decoded_bytes = vector[];
    outputs.length().do!(|i| {
        decoded_bytes.append(outputs[i].amount);
        decoded_bytes.append(covert_to_compact_size(outputs[i].script_pubkey_size));
        decoded_bytes.append(outputs[i].script_pubkey);
    });
    decoded_bytes
}
