module bitcoin_spv::difficulty;

use bitcoin_spv::bitcoin_spv::{LightClient, Params};
use bitcoin_spv::light_block::LightBlock;
use bitcoin_spv::btc_math::target_to_bits;



/// compute new target
/// You can check this blogs for more information
/// https://learnmeabitcoin.com/technical/mining/target    
public fun retarget_algorithm(p: &Params, previous_target: u256, first_timestamp: u256, last_timestamp: u256): u256 {
    let mut actual_timespan = last_timestamp - first_timestamp;
    let target_timespan = p.target_timespan();
    
    if (actual_timespan < target_timespan / 4) {
	actual_timespan = target_timespan / 4;
    };
    
    if (actual_timespan > target_timespan * 4){
	actual_timespan = target_timespan * 4; 
    };    
    // Trick from summa-tx/bitcoin-spv
    // NB: high targets e.g. ffff0020 can cause overflows here
    // so we divide it by 256**2, then multiply by 256**2 later
    // we know the target is evenly divisible by 256**2, so this isn't an issue

    let mut next_target = previous_target / (1 << 16) * actual_timespan;
    next_target = next_target / target_timespan * (1 << 16);
    
    if (next_target > p.power_limit()) {
	next_target = p.power_limit();
    };

    next_target
}

public fun calc_next_block_difficulty(c: &LightClient, last_block: &LightBlock, _new_block_time: u32) : u32 {

    // TODO: handle lastHeader is nil or genesis block

    let blocks_pre_retarget = c.params().blocks_pre_retarget();
    
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

    // we compute a new difficulty
    let first_block = c.relative_ancestor(last_block, blocks_pre_retarget - 1);
    let first_header = first_block.header();
    let previous_target = first_header.target();
    let first_timestamp = first_header.timestamp();
    let last_timestamp = last_block.header().timestamp();
    
    let new_target = retarget_algorithm(c.params(), previous_target, first_timestamp as u256, last_timestamp as u256);

    let new_bits = target_to_bits(new_target);
    return new_bits
}



