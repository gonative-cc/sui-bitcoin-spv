module btclc::block_header;

use btclc::chainctx::Chain;
use sui::dynamic_object_field as blocks_map;

public struct Header has key, store {
    id: UID,
    version: u32,
    prev_block: vector<u8>,
    merkle_root: vector<u8>,
    bits: u32,
    nonce: u32
}


public struct LightBlock has key, store {
    id: UID,
    height: u32,
    header: Header,
}



fun calc_next_block_difficulty(c: &Chain, last_block: &LightBlock, new_block_time: u32) : u32 {

    // TODO: handle lastHeader is nil or genesis block


    // if this block not start a new retarget cycle
    if ((last_block.height + 1) % c.params().blocks_pre_retarget() != 0) {
	
	// TODO: support ReduceMinDifficulty params
	// if c.params().reduce_min_difficulty {
	//     ...
	// }

	// Return previous block difficulty
	return last_block.header.bits
    };

    // we compute a new difficulty   
    
    return 0
}
