module bitcoin_spv::bitcoin_spv;

use sui::dynamic_object_field as dof;
use bitcoin_spv::block_header::{new_block_header};
use bitcoin_spv::light_block::LightBlock;


public struct Params has store{
    power_limit: u256,
    blocks_pre_retarget: u256,
    target_timespan: u256,
}

public struct LightClient has key, store{
    id: UID,
    params: Params,
}

// === Init function for module ====
fun init(_ctx: &mut TxContext) {
    // TODO: Init this module with parameter
}

public fun new_light_client(params: Params, ctx: &mut TxContext): LightClient {
    let lc = LightClient {
	    id: object::new(ctx),
	    params: params
    };

    return lc
}

// default params for bitcoin mainnet
public fun mainnet_params(): Params {
    return Params {
	    power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
	    blocks_pre_retarget: 2016,
	    target_timespan: 2016 * 60 * 10, // time in seconds when we update the target: 2016 blocks ~ 2 weeks.
    }
}

// === Entry methods ===

/// insert new header to bitcoin spv
public entry fun insert_header(c: &LightClient, raw_header: vector<u8>) {
    // insert a new header to current light client
    let next_header = new_block_header(raw_header);

    let current_block = c.latest_finalized_block();
    let current_header = current_block.header();

    current_header.verify_next_block(&next_header);

}


public entry fun verify_tx_inclusive(_c: &LightClient, _block_hash: vector<u8>, _tx_id: vector<u8>, _proof: vector<u8>): bool {
    // TODO: check transaction id (tx_id) inclusive in block
    // we not decide the final infeface yet
    return true
}

// === Views function ===

public fun latest_finalized_height(_c: &LightClient): u32 {
    return 0
}

public fun latest_finalized_block(c: &LightClient): &LightBlock{
    // TODO: decide return type
    let height = c.latest_finalized_height();
    let light_block = dof::borrow<_,LightBlock>(&c.id, height);
    return light_block
}

public fun params(c: &LightClient): &Params{
    return &c.params
}

public fun client_id(c: &LightClient): &UID {
    return &c.id
}

public fun client_id_mut(c: &mut LightClient): &mut UID {
    return &mut c.id
}

public fun blocks_pre_retarget(p: &Params) : u256{
    return p.blocks_pre_retarget
}

public fun power_limit(p: &Params): u256 {
    return p.power_limit
}

public fun target_timespan(p: &Params): u256 {
    p.target_timespan
}


public fun relative_ancestor(c: &LightClient, lb: &LightBlock, distance: u256): &LightBlock {
    let ancestor_height = lb.height() - distance;

    let ancestor: &LightBlock = dof::borrow(c.client_id(), ancestor_height);
    return ancestor
}
