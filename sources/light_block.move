module bitcoin_spv::light_block;

use bitcoin_spv::block_header::{BlockHeader, new_block_header};

public struct LightBlock has key, store {
    id: UID,
    height: u64,
    header: BlockHeader
}

public fun new_light_block(height: u64, block_header: vector<u8>, ctx: &mut TxContext): LightBlock {
    LightBlock {
        id: object::new(ctx),
        height,
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
