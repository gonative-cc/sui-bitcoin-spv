module bitcoin_spv::transaction;
use bitcoin_spv::btc_math::btc_hash;

public struct Input has copy, drop {
    input_bytes: vector<u8>,
}

public struct Output has copy, drop {
    output_bytes: vector<u8>
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
    number_input: vector<u8>,
    inputs: vector<Input>,
    number_output: vector<u8>,
    outputs: vector<Output>,
    witness: Option<vector<u8>>,
    lock_time: vector<u8>,
) {


}
