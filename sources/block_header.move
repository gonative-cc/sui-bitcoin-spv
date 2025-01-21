module bitcoin_spv::block_header;

public struct BlockHeader has key, store {
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
    header: BlockHeader,
}


// === Query data from light block ===
public fun height(lb: &LightBlock): u32 {
    return lb.height
}

public fun bits(lb: &LightBlock): u32 {
    return lb.header.bits
}

public fun timestamp(lb: &LightBlock): u32 {
    return lb.header.timestamp
}

public fun merkle_root(lb: &LightBlock): vector<u8> {
    return lb.header.merkle_root
}

public fun prev_block(lb: &LightBlock): vector<u8> {
    return lb.header.prev_block
}

public fun version(lb: &LightBlock): u32 {
    return lb.header.version
}

public fun nonce(lb: &LightBlock): u32 {
    return lb.header.nonce
}

