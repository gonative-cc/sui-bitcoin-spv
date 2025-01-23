module bitcoin_spv::btc_types;

use bitcoin_spv::math_utils::{btc_hash, to_u32, slices};

// === Errors ===

const EBlockHashNotMatch: u64 = 0;


public struct BlockHeader {
    internal: vector<u8>
}

public struct LightBlock {
    height: u32,
    header: BlockHeader
}

public struct Params has key, store{
    id: UID
}

public struct BTCLightClient has key, store{
    id: UID,
    params: Params,
}

// === Block header methods ===
fun slice(header: &BlockHeader, start: u64, end: u64) : vector<u8> {
    slices(header.internal, start, end)
}

public fun block_hash(header: &BlockHeader) : vector<u8> {
    return btc_hash(header.internal)
}
public fun version(header: &BlockHeader): u32 {
    return to_u32(header.slice(0, 4))
}

public fun prev_block(header: &BlockHeader): vector<u8> {
    return header.slice(4, 36)
}

public fun merkle_root(header: &BlockHeader): vector<u8> {
    return header.slice(36, 68)
}

public fun timestamp(header: &BlockHeader): u32 {
    return to_u32(header.slice(68, 72))
}

public fun bits(header: &BlockHeader): u32 {
    return to_u32(header.slice(72, 76))
}

public fun nonce(header: &BlockHeader): u32 {
    return to_u32(header.slice(76, 80))
}

public fun verify_next_block(current_header: &BlockHeader, next_header: &BlockHeader): bool {
    assert!(current_header.block_hash() == next_header.prev_block(), EBlockHashNotMatch);
    return true
}

// === Light Block methods ===

public fun height(lb: &LightBlock): u32 {
    return lb.height
}

public fun header(lb: &LightBlock): &BlockHeader {
    return &lb.header
}
