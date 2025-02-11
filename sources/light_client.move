module bitcoin_spv::light_client;

use bitcoin_spv::block_header::{BlockHeader, new_block_header};
use bitcoin_spv::light_block::{LightBlock, new_light_block};
use bitcoin_spv::merkle_tree::verify_merkle_proof;
use bitcoin_spv::btc_math::target_to_bits;
use bitcoin_spv::utils::nth_element;

use sui::dynamic_object_field as dof;
use sui::dynamic_field as df;

const EBlockHashNotMatch: u64 = 1;
const EDifficultyNotMatch: u64 = 2;
const ETimeTooOld: u64 = 3;

public struct Params has store{
    power_limit: u256,
    blocks_pre_retarget: u64,
    /// time in seconds when we update the target
    target_timespan: u64,
    pow_no_retargeting: bool
}

// default params for bitcoin mainnet
public fun mainnet_params(): Params {
    return Params {
        power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10, // ~ 2 weeks.
        pow_no_retargeting: false,
    }
}

// default params for bitcoin testnet
public fun testnet_params(): Params {
    return mainnet_params()
}

// default params for bitcoin regtest
public fun regtest_params(): Params {
    return Params {
        power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10,  // ~ 2 weeks.
        pow_no_retargeting: true,
    }
}

public fun blocks_pre_retarget(p: &Params) : u64 {
    p.blocks_pre_retarget
}

public fun power_limit(p: &Params): u256 {
    p.power_limit
}

public fun target_timespan(p: &Params): u64 {
    p.target_timespan
}

public fun pow_no_retargeting(p: &Params): bool {
    p.pow_no_retargeting
}

/*
 * Light Client
 */
public struct LightClient has key, store {
    id: UID,
    params: Params,
    finalized_height: u64
}


// === Init function for module ====
fun init(ctx: &mut TxContext) {
    let p = mainnet_params();
    // https://btcscan.org/block/00000000000003a5e28bef30ad31f1f9be706e91ae9dda54179a95c9f9cd9ad0
    let raw_header = x"010000009d6f4e09d579c93015a83e9081fee83a5c8b1ba3c86516b61f0400000000000025399317bb5c7c4daefe8fe2c4dfac0cea7e4e85913cd667030377240cadfe93a4906b50087e051a84297df7";
    let lc = new_light_client(p, 201600, vector[raw_header], ctx);
    transfer::transfer(lc, tx_context::sender(ctx));
}

// initializes Bitcoin light client by providing a trusted snapshot height and header
public fun new_light_client(params: Params, start_height: u64, start_headers: vector<vector<u8>>, ctx: &mut TxContext): LightClient {
    let mut lc = LightClient {
        id: object::new(ctx),
        params: params,
        finalized_height: 0,
    };

    if (!start_headers.is_empty()) {
        let mut height = start_height;
        start_headers.do!(|header| {
            let light_block = new_light_block(height, header, ctx);
            lc.set_light_block(light_block);
            height = height + 1;
        });

        lc.finalized_height = height - 1;
    };
    return lc
}

// Helper function to initialize new light client.
// network: 0 = mainnet, 1 = testnet
public fun new_btc_light_client(
    network: u8, start_height: u64, start_headers: vector<vector<u8>>, ctx: &mut TxContext
)  {
    let params = match (network) {
        0 => mainnet_params(),
        1 => testnet_params(),
        _ => regtest_params()
    };
    let lc = new_light_client(params, start_height, start_headers, ctx);
    transfer::share_object(lc);
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

    // https://learnmeabitcoin.com/technical/block/time
    // we only check the case "A timestamp greater than the median time of the last 11 blocks".
    // because  network adjusted time requires a miners local time.
    let median_time = calc_past_median_time(c, current_block);
    assert!(next_header.timestamp() > median_time, ETimeTooOld);
    next_header.pow_check();

    // update new header
    let next_height = current_block.height() + 1;
    let next_light_block = new_light_block(next_height, raw_header, ctx);
    c.finalized_height = next_height;
    c.set_light_block(next_light_block);
}


public entry fun insert_headers(c: &mut LightClient, raw_headers: vector<vector<u8>>, ctx: &mut TxContext) {
    assert!(raw_headers.is_empty());

    let headers = raw_headers.map!(|raw_header| new_block_header(raw_header));

}

// === Views function ===

public fun latest_finalized_height(c: &LightClient): u64 {
    return c.finalized_height
}

public fun latest_finalized_block(c: &LightClient): &LightBlock {
    // TODO: decide return type
    let height = c.latest_finalized_height();
    return c.get_light_block(height)
}

/// Verify a transaction has tx_id(32 bytes) inclusive in the block has height h.
/// proof is merkle proof for tx_id. This is a sha256(32 bytes) vector.
/// tx_index is index of transaction in block.
/// We use little endian encoding for all data.
public fun verify_tx(
    c: &LightClient,
    height: u64,
    tx_id: vector<u8>,
    proof: vector<vector<u8>>,
    tx_index: u64
): bool {
    // TODO: update this when we have APIs for finalized block.
    // TODO: handle: light block not exist.
    let light_block = c.get_light_block(height);
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

public fun relative_ancestor(c: &LightClient, lb: &LightBlock, distance: u64): &LightBlock {
    let ancestor_height = lb.height() - distance;
    return c.get_light_block(ancestor_height)
}

fun set_block_header_by_hash(c: &mut LightClient, block_header: BlockHeader) {
    let block_hash = block_header.block_hash();
    df::add(c.client_id_mut(), block_hash, block_header);
}

fun get_block_header_by_hash(c: &LightClient, block_hash: vector<u8>): &BlockHeader {
    df::borrow(c.client_id(), block_hash)
}

// last_block is a new block that we are adding. The function calculates the required difficulty for the block
// after the passed the `last_block`.
public fun calc_next_required_difficulty(c: &LightClient, last_block: &LightBlock, _new_block_time: u32) : u32 {
    // reference from https://github.com/btcsuite/btcd/blob/master/blockchain/difficulty.go#L136
    // TODO: handle lastHeader is nil or genesis block
    let params = c.params();
    let blocks_pre_retarget = params.blocks_pre_retarget();


    if (params.pow_no_retargeting() || last_block.height() == 0) {
        let power_limit = params.power_limit();
        return target_to_bits(power_limit)
    };

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

    let new_target = retarget_algorithm(c.params(), previous_target, first_timestamp as u64, last_timestamp as u64);
    let new_bits = target_to_bits(new_target);
    return new_bits
}

/// compute new target
/// You can check this blogs for more information
/// https://learnmeabitcoin.com/technical/mining/target
public fun retarget_algorithm(p: &Params, previous_target: u256, first_timestamp: u64, last_timestamp: u64): u256 {
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
    let mut next_target = previous_target / (1 << 16) * (adjusted_timespan as u256);
    next_target = next_target / (target_timespan as u256) * (1 << 16);

    if (next_target > p.power_limit()) {
        next_target = p.power_limit();
    };

    next_target
}

fun calc_past_median_time(c: &LightClient, lb: &LightBlock): u32 {
    // Follow implementation from btcsuite/btcd
    // https://github.com/btcsuite/btcd/blob/bc6396ddfd097f93e2eaf0d1346ab80735eaa169/blockchain/blockindex.go#L312
    // https://learnmeabitcoin.com/technical/block/time
    let median_time_blocks = 11;
    let mut timestamps = vector[];
    let mut i = 0;
    let mut prev_lb = lb;
    while (i < median_time_blocks) {
        timestamps.push_back(prev_lb.header().timestamp());
        if (!c.exist(prev_lb.height() - 1)) {
            break
        };
        prev_lb = c.relative_ancestor(prev_lb, 1);
        i = i + 1;
    };

    let size = timestamps.length();
    nth_element(&mut timestamps, size / 2)
}

fun set_light_block(lc: &mut LightClient, lb: LightBlock) {
    dof::add(lc.client_id_mut(), lb.height(), lb);
}

public fun get_light_block(lc: &LightClient, height: u64): &LightBlock {
    dof::borrow(lc.client_id(), height)
}

fun exist(lc: &LightClient, height: u64): bool {
    dof::exists_(lc.client_id(), height)
}

#[test_only]
public fun add_light_block(lc: &mut LightClient, lb: LightBlock) {
    if (lb.height() > lc.finalized_height) {
        lc.finalized_height= lb.height();
    };
    set_light_block(lc, lb);
}
