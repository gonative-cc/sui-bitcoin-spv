module bitcoin_spv::bitcoin_spv;

use bitcoin_spv::block_header::new_block_header;
use bitcoin_spv::light_block::{LightBlock, new_light_block};
use bitcoin_spv::merkle_tree::verify_merkle_proof;
use bitcoin_spv::btc_math::target_to_bits;

use sui::dynamic_object_field as dof;

const EBlockHashNotMatch: u64 = 0;
const EDifficultyNotMatch: u64 = 1;

public struct Params has store{
    power_limit: u256,
    blocks_pre_retarget: u256,
    target_timespan: u256,
}

public struct LightClient has key, store {
    id: UID,
    params: Params,
    finalized_height: u256
}

// === Init function for module ====
fun init(_ctx: &mut TxContext) {}

public fun new_light_client(params: Params, ctx: &mut TxContext): LightClient {
    let lc = LightClient {
	    id: object::new(ctx),
	    params: params,
        finalized_height: 0,
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
public entry fun insert_header(c: &mut LightClient, raw_header: vector<u8>, ctx: &mut TxContext) {
    let next_header = new_block_header(raw_header);
    let current_block = c.latest_finalized_block();
    let current_header = current_block.header();

    // verify new header
    assert!(current_header.block_hash() == next_header.prev_block(), EBlockHashNotMatch);
    let next_block_difficulty = calc_next_required_difficulty(c, current_block, 0);
    assert!(next_block_difficulty == next_header.bits(), EDifficultyNotMatch);
    next_header.pow_check();

    // update new header
    let next_height = current_block.height() + 1;
    let next_light_block = new_light_block(next_height, raw_header, ctx);
    c.finalized_height = next_height;
    c.set_light_block(next_light_block);
}


// === Views function ===

public fun latest_finalized_height(c: &LightClient): u256 {
    return c.finalized_height
}

public fun latest_finalized_block(c: &LightClient): &LightBlock {
    // TODO: decide return type
    let height = c.latest_finalized_height();
    return c.light_block_at_height(height)
}

public fun light_block_at_height(c: &LightClient, height: u256) : &LightBlock {
    let light_block = dof::borrow(c.client_id(), height);
    return light_block
}

/// Verify a transaction has tx_id(32 bytes) inclusive in the block has height h.
/// proof is merkle proof for tx_id. This is a sha256(32 bytes) vector.
/// tx_index is index of transaction in block.
/// We use little endian encoding for all data.
public fun verify_tx(
    c: &LightClient,
    height: u256,
    tx_id: vector<u8>,
    proof: vector<vector<u8>>,
    tx_index: u256
): bool {
    // TODO: update this when we have APIs for finalized block.
    // TODO: handle: light block not exist.
    let light_block = dof::borrow<_, LightBlock>(&c.id, height);
    let header = light_block.header();
    let merkle_root = header.merkle_root();
    return verify_merkle_proof(merkle_root, proof, tx_id, tx_index)
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


// last_block is a new block that we are adding. The function calculates the required difficulty for the block
// after the passed the `last_block`.
public fun calc_next_required_difficulty(c: &LightClient, last_block: &LightBlock, _new_block_time: u32) : u32 {
    // reference from https://github.com/btcsuite/btcd/blob/master/blockchain/difficulty.go#L136
    // TODO: handle lastHeader is nil or genesis block
    let params = c.params();
    let blocks_pre_retarget = params.blocks_pre_retarget();

    // if this block not start a new retarget cycle
    if ((last_block.height() + 1) % blocks_pre_retarget != 0) {

	    // TODO: support ReduceMinDifficulty params
	    // if c.params().reduce_min_difficulty {
	    //     ...
	    //     new_block_time is using in this logic
	    // }

	    // Return previous block difficulty
	    return last_block.header().bits()
    };

    // we compute a new difficulty for the new target cycle.
    // this target applies at block  height + 1
    let first_block = c.relative_ancestor(last_block, blocks_pre_retarget - 1);
    let first_header = first_block.header();
    let previous_target = first_header.target();
    let first_timestamp = first_header.timestamp();
    let last_timestamp = last_block.header().timestamp();

    let new_target = retarget_algorithm(c.params(), previous_target, first_timestamp as u256, last_timestamp as u256);
    let new_bits = target_to_bits(new_target);
    return new_bits
}

/// compute new target
/// You can check this blogs for more information
/// https://learnmeabitcoin.com/technical/mining/target
public fun retarget_algorithm(p: &Params, previous_target: u256, first_timestamp: u256, last_timestamp: u256): u256 {
    let mut adjusted_timespan = last_timestamp - first_timestamp;
    let target_timespan = p.target_timespan();

    // target adjustment is based on the time diff from the target_timestamp. We have max and min value:
    // https://github.com/bitcoin/bitcoin/blob/v28.1/src/pow.cpp#L55
    // https://github.com/btcsuite/btcd/blob/v0.24.2/blockchain/difficulty.go#L184
    let min_timespan = target_timespan / 4;
    let max_timespan = target_timespan * 4;
    if (adjusted_timespan > max_timespan) {
        adjusted_timespan = max_timespan;
    } else if (adjusted_timespan < min_timespan) {
        adjusted_timespan = min_timespan;
    };

    // A trick from summa-tx/bitcoin-spv :D.
    // NB: high targets e.g. ffff0020 can cause overflows here
    // so we divide it by 256**2, then multiply by 256**2 later.
    // we know the target is evenly divisible by 256**2, so this isn't an issue
    // notes: 256*2 = (1 << 16)
    let mut next_target = previous_target / (1 << 16) * adjusted_timespan;
    next_target = next_target / target_timespan * (1 << 16);

    if (next_target > p.power_limit()) {
	    next_target = p.power_limit();
    };

    next_target
}

fun set_light_block(lc: &mut LightClient, lb: LightBlock) {
    dof::add(lc.client_id_mut(), lb.height(), lb);
}


#[test_only]
public fun add_light_block(lc: &mut LightClient, lb: LightBlock) {
    if (lb.height() > lc.finalized_height) {
        lc.finalized_height= lb.height();
    };
    set_light_block(lc, lb);
}
