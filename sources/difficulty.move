module bitcoin_spv::difficulty;

use bitcoin_spv::btc_math::{bits_to_target, target_to_bits};
use bitcoin_spv::block_header::LightBlock;
use bitcoin_spv::chainctx::Chain;


public fun calc_next_block_difficulty(c: &Chain, last_block: &LightBlock, _new_block_time: u32) : u32 {

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
	return last_block.bits()
    };

    // we compute a new difficulty
    let first_block = last_block.relative_ancestor(blocks_pre_retarget - 1, c);

    let acctual_timespan = last_block.timestamp() - first_block.timestamp();
    let mut adjusted_timespan: u64 = acctual_timespan as u64;
    
    if ((acctual_timespan as u64) < c.min_retarget_timespan()) {
	adjusted_timespan = c.min_retarget_timespan();
    } else if ((acctual_timespan as u64)> c.max_retarget_timespan()){
	adjusted_timespan = c.max_retarget_timespan();
    };

    // compute new target
    // You can check this blogs for more information
    // https://learnmeabitcoin.com/technical/mining/target
    let old_target = bits_to_target(first_block.bits());
    // TODO: ensure this one can't overflow
    let mut new_target = old_target * (adjusted_timespan as u256);
    // TODO: make this more sense.
    let second = 1000000000;
    let target_timespan = c.params().target_timespan() / second;
    new_target = new_target / (target_timespan as u256);
    
    if (new_target > c.params().power_limit()) {
	new_target = c.params().power_limit();
    };
    return target_to_bits(new_target)
}
