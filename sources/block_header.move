module btclc::block_header;

public struct Header has key, store {
    id: UID,
    version: u32,
    prev_block: vector<u8>,
    merkle_root: vector<u8>,
    bits: u32,
    nonce: u32
}

fun calc_next_block_difficulty(lastHeader: &Header, new_block_time: u32) : u32 {
    return 0
}
