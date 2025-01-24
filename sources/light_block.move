module bitcoin_spv::light_block;

use bitcoin_spv::bitcoin_spv::LightClient;
use bitcoin_spv::block_header::BlockHeader;

use sui::dynamic_object_field as dof;

public struct LightBlock has key, store {
    id: UID,
    height: u64,
    header: BlockHeader
}

// === Light Block methods ===
public fun height(lb: &LightBlock): u64 {
    return lb.height
}

public fun header(lb: &LightBlock): &BlockHeader {
    return &lb.header
}
