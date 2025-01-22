module bitcoin_spv::block_header;

// === Structs ===
public struct BlockHeader has key, store{
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
// === Constansts ===
const HASH_LEN: u64 = 32;

// === Errors ===

const EInvalidHashLen: u64 = 0;

// === Function ===

/// Create a new header
public fun new_block_header(
    version: u32,
    prev_block: vector<u8>,
    merkle_root: vector<u8>,
    timestamp: u32,
    bits: u32,
    nonce: u32,
    ctx: &mut TxContext
) : BlockHeader{
    assert!(prev_block.length() != HASH_LEN, EInvalidHashLen);
    assert!(merkle_root.length() != HASH_LEN, EInvalidHashLen);
    
    let header = BlockHeader {
	id: object::new(ctx),
	version,
	prev_block,
	merkle_root,
	timestamp,
	bits,
	nonce
    };
    
    return header
}

public fun new_light_block(height: u32, header: BlockHeader, ctx: &mut TxContext) : LightBlock{
    let lb = LightBlock {
	id: object::new(ctx),
	height,
	header,
    };

    return lb
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

public fun block_hash(header: &BlockHeader) : vector<u8> {
    return vector[]
}

