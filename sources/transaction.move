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
