module bitcoin_spv::transaction;
use bitcoin_spv::btc_math::btc_hash;

public struct Input has copy, drop {
    input_bytes: vector<u8>,
}

public struct Output has copy, drop {
    output_bytes: vector<u8>
}

public struct Transaction has copy, drop{
    tx_data: vector<u8>,
    inputs: vector<Input>,
    outputs: vector<Output>
}


public fun tx_id(tx: &Transaction): vector<u8> {
    btc_hash(tx.tx_data)
}



public struct TransactionReader {
    pos: u64,
    data: vector<u8>
}



public fun new_transaction_reader(data: vector<u8>): TransactionReader {
    TransactionReader {
        pos: 0,
        data,
    }
}

public fun version(r: &mut TransactionReader): vector<u8> {
    vector[]
}

public fun market(r: &mut TransactionReader): vector<u8> {
    vector[]
}

public fun flag(r: &mut TransactionReader): vector<u8> {
    vector[]
}

public fun number_element(r: &mut TransactionReader): u64 {
    0
}

public fun input(r: &mut TransactionReader): Input {
    Input {
        input_bytes: vector[]
    }
}

public fun output(r: &mut TransactionReader): Output {
    Output {
        output_bytes: vector[]
    }
}

public fun witness(r: &mut TransactionReader): vector<u8> {
    vector[]
}

public fun lock_time(r: &mut TransactionReader): vector<u8> {
    vector[]
}
