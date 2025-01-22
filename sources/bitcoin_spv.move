
/// Module: bitcoin_spv
module bitcoin_spv::bitcoin_spv;

use bitcoin_spv::chain::Chain;
use bitcoin_spv::block_header::BlockHeader
// === Errors ===
// We will add this later


// === Init function for module ====
fun init(_ctx: &mut TxContext) {
    // TODO: Init this module with parameter
}

// === Entry methods ===

/// insert new header to bitcoin spv
public entry fun insert_header(_c: &Chain, block_header: &BlockHeader) {
    // insert a new header to current light client
}

// === views function ===
public entry fun latest_finalized_height(_c: &Chain): u32 {
    return 0
}

public entry fun latest_finalized_block(_c: &Chain): u32 {
    return 0
}

public entry fun verify_tx_inclusive(_c: &Chain, _block_hash: vector<u8>, _tx_id: vector<u8>, _proof: vector<u8>): bool {
    return true
}

