module bitcoin_spv::light_block;

use bitcoin_spv::block_header::BlockHeader;

public struct LightBlock has key, store {
    id: UID,
    height: u32,
    header: BlockHeader,
}

// === Light Block methods ===
public fun height(lb: &LightBlock): u32 {
    return lb.height
}

public fun header(lb: &LightBlock): &BlockHeader {
    return &lb.header
}
