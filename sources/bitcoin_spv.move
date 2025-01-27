module bitcoin_spv::bitcoin_spv;

use bitcoin_spv::block_header::new_block_header;
use bitcoin_spv::light_block::LightBlock;
use sui::dynamic_object_field as dof;

public struct Params has key, store {
    id: UID,
}

public struct LightClient has key, store {
    id: UID,
    params: Params,
}

// === Init function for module ====
fun init(_ctx: &mut TxContext) {}

// === Entry methods ===

/// insert new header to bitcoin spv
public entry fun insert_header(c: &LightClient, raw_header: vector<u8>) {
    // insert a new header to current light client
    let next_header = new_block_header(raw_header);

    let current_block = c.latest_finalized_block();
    let current_header = current_block.header();

    current_header.verify_next_block(&next_header);
}

// === Views function ===

public fun latest_finalized_height(_c: &LightClient): u32 {
    return 0
}

public fun latest_finalized_block(c: &LightClient): &LightBlock {
    // TODO: decide return type
    let height = c.latest_finalized_height();
    let light_block = dof::borrow<_, LightBlock>(&c.id, height);
    return light_block
}

public entry fun verify_tx_inclusive(
    _c: &LightClient,
    _block_hash: vector<u8>,
    _tx_id: vector<u8>,
    _proof: vector<u8>,
): bool {
    return true
}
