module bitcoin_spv::transaction;
use bitcoin_spv::btc_math::btc_hash;

public struct Transaction has copy, drop{
    tx_data: vector<u8>
}

public fun new_transaction(tx_data: vector<u8>) : Transaction{
    Transaction {
        tx_data
    }
}

public fun tx_id(tx: &Transaction): vector<u8> {
    btc_hash(tx.tx_data)
}
