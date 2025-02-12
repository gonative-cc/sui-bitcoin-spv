module bitcoin_spv::light_block;

use bitcoin_spv::block_header::{BlockHeader, new_block_header};

public struct LightBlock has copy, store, drop {
    height: u64,
    chain_work: u256,
    header: BlockHeader
}

public fun new_light_block(height: u64, block_header: vector<u8>, chain_work: u256): LightBlock {
    LightBlock {
        height,
        chain_work,
        header: new_block_header(block_header)
    }
}

/*
 * Light Block methods
 */

public fun height(lb: &LightBlock): u64 {
    return lb.height
}

public fun header(lb: &LightBlock): &BlockHeader {
    return &lb.header
}

public fun chain_work(lb: &LightBlock): u256 {
    lb.chain_work
}
