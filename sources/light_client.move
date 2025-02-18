module bitcoin_spv::light_client;

use bitcoin_spv::block_header::{BlockHeader, new_block_header};
use bitcoin_spv::light_block::{LightBlock, new_light_block};
use bitcoin_spv::merkle_tree::verify_merkle_proof;
use bitcoin_spv::btc_math::target_to_bits;
use bitcoin_spv::utils::nth_element;

use sui::dynamic_field as df;

const EBlockHashNotMatch: u64 = 1;
const EDifficultyNotMatch: u64 = 2;
const ETimeTooOld: u64 = 3;
const EHeaderListIsEmpty: u64 = 4;
const EBlockDoesnotExist: u64 = 5;
const EForkNotEnoughPower: u64 = 6;

public struct ExistEvent has copy, drop {
    block_hash: vector<u8>,
    exist: bool
}

public struct LatestBlockEvent has drop, copy{
    light_block: LightBlock
}

public struct VerifyTxEvent has copy, drop{
    tx_id: vector<u8>,
    result: bool,
    block_hash: vector<u8>
}

public struct InsertHeaderEvent has copy, drop {
    fork: bool,
    latest_block: BlockHeader
}

public struct CreatedLCEvent has copy, drop{
    light_client_id: ID,
}

public struct Params has store{
    power_limit: u256,
    blocks_pre_retarget: u64,
    /// time in seconds when we update the target
    target_timespan: u64,
    pow_no_retargeting: bool,
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
        power_limit: 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
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
fun init(_ctx: &mut TxContext) {
    // let p = mainnet_params();
    // // https://btcscan.org/block/00000000000003a5e28bef30ad31f1f9be706e91ae9dda54179a95c9f9cd9ad0
    // let raw_header = x"010000009d6f4e09d579c93015a83e9081fee83a5c8b1ba3c86516b61f0400000000000025399317bb5c7c4daefe8fe2c4dfac0cea7e4e85913cd667030377240cadfe93a4906b50087e051a84297df7";
    // let lc = new_light_client(p, 201600, vector[raw_header], ctx);
    // transfer::transfer(lc, tx_context::sender(ctx));
}

// initializes Bitcoin light client by providing a trusted snapshot height and header
public fun new_light_client(params: Params, start_height: u64, start_headers: vector<vector<u8>>, start_chain_work: u256, ctx: &mut TxContext): LightClient {
    let mut lc = LightClient {
        id: object::new(ctx),
        params: params,
        finalized_height: 0,
    };

    let mut current_chain_work = start_chain_work;
    if (!start_headers.is_empty()) {
        let mut height = start_height;
        start_headers.do!(|raw_header| {
            let header = new_block_header(raw_header);
            let light_block = new_light_block(height, header, current_chain_work);
            let header_calc_work = light_block.header().calc_work();
            lc.set_block_header_by_height(height, header);
            lc.add_light_block(light_block);
            height = height + 1;
            current_chain_work = current_chain_work + header_calc_work;
        });

        lc.finalized_height = height - 1;
    };

    sui::event::emit(
        CreatedLCEvent {
            light_client_id: object::id(&lc),

        }
    );
    return lc
}


// Helper function to initialize new light client.
// network: 0 = mainnet, 1 = testnet
public fun new_btc_light_client(
    network: u8, start_height: u64, start_headers: vector<vector<u8>>, pre_start_chain_work: u256, ctx: &mut TxContext
)  {
    let params = match (network) {
        0 => mainnet_params(),
        1 => testnet_params(),
        _ => regtest_params()
    };
    let lc = new_light_client(params, start_height, start_headers, pre_start_chain_work, ctx);
    transfer::share_object(lc);
}

// === Entry methods ===
/// insert new header to bitcoin spv
public(package) fun insert_header(c: &mut LightClient, current_block_hash: vector<u8>, next_header: BlockHeader): vector<u8> {
    let current_block = c.get_light_block_by_hash(current_block_hash);
    let current_header = current_block.header();

    // verify new header
    assert!(current_header.block_hash() == next_header.prev_block(), EBlockHashNotMatch);
    let next_block_difficulty = calc_next_required_difficulty(c, current_block, 0);
    assert!(next_block_difficulty == next_header.bits(), EDifficultyNotMatch);


    // https://learnmeabitcoin.com/technical/block/time
    // we only check the case "A timestamp greater than the median time of the last 11 blocks".
    // because  network adjusted time requires a miners local time.
    let median_time = c.calc_past_median_time(current_block);
    assert!(next_header.timestamp() >= median_time, ETimeTooOld);
    next_header.pow_check();

    // update new header
    let next_height = current_block.height() + 1;
    let next_chain_work = current_block.chain_work() + next_header.calc_work();
    let next_light_block = new_light_block(next_height, next_header, next_chain_work);

    c.finalized_height = next_height;

    c.add_light_block(next_light_block);
    c.set_block_header_by_height(next_height, next_header);
    next_header.block_hash()
}

fun extend_chain_from_block(c: &mut LightClient, start_point: vector<u8>, raw_headers: vector<vector<u8>>): vector<u8> {
    let mut previous_block_hash = start_point;
    raw_headers.do!(|raw_header| {
        let header = new_block_header(raw_header);
        previous_block_hash = c.insert_header(previous_block_hash, header);
    });

    previous_block_hash
}

public entry fun insert_headers(c: &mut LightClient, raw_headers: vector<vector<u8>>) {
    // TODO: check if we can use BlockHeader instead of raw_header or vector<u8>(bytes)
    assert!(!raw_headers.is_empty(), EHeaderListIsEmpty);

    let first_header = new_block_header(raw_headers[0]);
    let latest_block_hash = c.latest_block().header().block_hash();

    if (first_header.prev_block() == latest_block_hash) {
        // extend current fork
        c.extend_chain_from_block(first_header.prev_block(), raw_headers);

        sui::event::emit(InsertHeaderEvent {
            fork: false,
            latest_block: *c.latest_block().header()
        });
    } else {
        // handle a fork choice

        assert!(c.exist(first_header.prev_block()), EBlockDoesnotExist);
        let current_chain_work = c.latest_block().chain_work();
        let current_block_hash = c.latest_block().header().block_hash();

        let candidate_fork_head_hash = c.extend_chain_from_block(first_header.prev_block(), raw_headers);

        let candidate_head = c.get_light_block_by_hash(candidate_fork_head_hash);
        let candidate_chain_work = candidate_head.chain_work();
        assert!(current_chain_work < candidate_chain_work, EForkNotEnoughPower);
        c.rollback(first_header.prev_block(), current_block_hash);

        sui::event::emit(InsertHeaderEvent {
            fork: true,
            latest_block: *c.latest_block().header()
        });
    }
}

/// Detele all block between head_hash to checkpoint_hash
public(package) fun rollback(c: &mut LightClient, checkpoint_hash: vector<u8>, head_hash: vector<u8>) {
    // TODO: Should we handle the case head hash never reach to checkpoint?
    // B/c if this happend then this is just out of gas to run.
    let mut block_hash = head_hash;
    while (checkpoint_hash != block_hash) {
        let previous_block_hash = c.get_light_block_by_hash(block_hash).header().prev_block();
        c.remove_light_block(block_hash);
        block_hash = previous_block_hash;
    }
}

// === Views function ===

public fun latest_height(c: &LightClient): u64 {
    return c.finalized_height
}

public fun latest_block(c: &LightClient): &LightBlock {
    // TODO: decide return type
    let height = c.latest_height();
    let block_hash = c.get_block_header_by_height(height).block_hash();
    let b = c.get_light_block_by_hash(block_hash);
    sui::event::emit(LatestBlockEvent {
        light_block: *b
    });
    b
}


/// Verify a transaction has tx_id(32 bytes) inclusive in the block has height h.
/// proof is merkle proof for tx_id. This is a sha256(32 bytes) vector.
/// tx_index is index of transaction in block.
/// We use little endian encoding for all data.
public fun verify_tx(
    c: &LightClient,
    block_hash: vector<u8>,
    tx_id: vector<u8>,
    proof: vector<vector<u8>>,
    tx_index: u64
): bool {
    // TODO: update this when we have APIs for finalized block.
    // TODO: handle: light block/block_header not exist.
    let header = c.get_light_block_by_hash(block_hash).header();
    let merkle_root = header.merkle_root();
    let result = verify_merkle_proof(merkle_root, proof, tx_id, tx_index);
    sui::event::emit(VerifyTxEvent {
        block_hash: header.block_hash(),
        tx_id,
        result,
    });
    result
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
    let ancestor_block_hash = c.get_block_header_by_height(ancestor_height).block_hash();
    return c.get_light_block_by_hash(ancestor_block_hash)
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
        if (!c.exist(prev_lb.header().prev_block())) {
            break
        };
        prev_lb = c.relative_ancestor(prev_lb, 1);
        i = i + 1;
    };

    let size = timestamps.length();
    nth_element(&mut timestamps, size / 2)
}



// update and query data
public(package) fun add_light_block(lc: &mut LightClient, lb: LightBlock) {
    let block_hash = lb.header().block_hash();
    df::add(lc.client_id_mut(), block_hash, lb);

}

public(package) fun remove_light_block(lc: &mut LightClient, block_hash: vector<u8>) {
    df::remove<_, LightBlock>(lc.client_id_mut(), block_hash);
}

public fun get_light_block_by_hash(lc: &LightClient, block_hash: vector<u8>): &LightBlock {
    // TODO: Can we use option type?
    df::borrow(lc.client_id(), block_hash)
}

public fun exist(lc: &LightClient, block_hash: vector<u8>): bool {
    let exist = df::exists_(lc.client_id(), block_hash);
    sui::event::emit(ExistEvent {
        block_hash,
        exist
    });
    exist
}

public(package) fun set_block_header_by_height(c: &mut LightClient, height: u64, block_header: BlockHeader) {
    df::remove_if_exists<u64, BlockHeader>(c.client_id_mut(), height);
    df::add(c.client_id_mut(), height, block_header);
}

public fun get_block_header_by_height(c: &LightClient, height: u64): &BlockHeader {
    df::borrow(c.client_id(), height)
}

public(package) fun set_latest_block(c: &mut LightClient, light_block: LightBlock) {
    c.add_light_block(light_block);
    c.set_block_header_by_height(light_block.height(), *light_block.header());
    c.finalized_height = light_block.height();
}
