
/// Module: bitcoin_spv
module bitcoin_spv::bitcoin_spv;

use sui::dynamic_object_field as dof;

use bitcoin_spv::btc_types::{BlockHeader, new_block_header, LightBlock, Params};

public struct BTCLightClient has key, store{
    id: UID,
    params: Params,
}

// === Errors ===
// We will add this later

// === Init function for module ====
fun init(_ctx: &mut TxContext) {
    // TODO: Init this module with parameter
}

// === Entry methods ===

/// insert new header to bitcoin spv
public entry fun insert_header(c: &BTCLightClient, raw_header: vector<u8>) {
    // insert a new header to current light client
    let next_header = new_block_header(raw_header);
    
    let current_block = c.latest_finalized_block();
    let current_header = current_block.header();

    current_header.verify_next_block(&next_header);

}

// === views function ===
public fun latest_finalized_height(_c: &BTCLightClient): u32 {
    return 0
}

public fun latest_finalized_block(c: &BTCLightClient): &LightBlock{
    let height = c.latest_finalized_height();
    let light_block = dof::borrow<_,LightBlock>(&c.id, height);
    return light_block
}

public entry fun verify_tx_inclusive(_c: &BTCLightClient, _block_hash: vector<u8>, _tx_id: vector<u8>, _proof: vector<u8>): bool {
    return true
}

