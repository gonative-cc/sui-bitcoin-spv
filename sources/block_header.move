module bitcoin_spv::block_header;

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

