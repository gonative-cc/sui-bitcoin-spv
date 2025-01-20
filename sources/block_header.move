module btclc::block_header;

use btclc::chainctx::Chain;
use btclc::btc_math::{bits_to_target, target_to_bits};
use sui::dynamic_object_field as dof;

public struct Header has key, store {
    id: UID,
    version: u32,
    prev_block: vector<u8>,
    merkle_root: vector<u8>,
    timestamp: u32,
    bits: u32,
    nonce: u32
}


public struct LightBlock has key, store {
    id: UID,
    height: u32,
    header: Header,
}


public fun height(lb: &LightBlock): u32 {
    return lb.height
}

public fun bits(lb: &LightBlock): u32 {
    return lb.header.bits
}

public fun timestamp(lb: &LightBlock): u32 {
    return lb.header.timestamp
}

public fun relative_ancestor(lb: &LightBlock, distance: u32, c: &Chain): &LightBlock {
    let ancestor_height: u32 = lb.height - distance;
    
    let ancestor: &LightBlock = dof::borrow(c.id(), ancestor_height);
    return ancestor
}
