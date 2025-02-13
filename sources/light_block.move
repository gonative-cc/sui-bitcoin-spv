module bitcoin_spv::light_block;

use bitcoin_spv::block_header::BlockHeader;

public struct LightBlock has copy, store, drop {
    height: u64,
    chain_work: u256,
    header: BlockHeader
}

public fun new_light_block(height: u64, header: BlockHeader, chain_work: u256): LightBlock {
    LightBlock {
        height,
        chain_work,
        header: header
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
