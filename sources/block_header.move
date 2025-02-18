module bitcoin_spv::block_header;

use bitcoin_spv::btc_math::{btc_hash, to_u32, bits_to_target, to_u256};
use bitcoin_spv::utils;

// === Constants ===
const BLOCK_HEADER_SIZE: u64 = 80;

// === Errors ===
const EInvalidBlockHeaderSize: u64 = 1;
const EPoW: u64 = 2;

public struct BlockHeader has copy, drop, store {
    internal: vector<u8>,
}

// === Block header methods ===

/// New block header
public fun new_block_header(raw_block_header: vector<u8>): BlockHeader {
    assert!(raw_block_header.length() == BLOCK_HEADER_SIZE, EInvalidBlockHeaderSize);
    return BlockHeader {
        internal: raw_block_header,
    }
}

public fun block_hash(header: &BlockHeader): vector<u8> {
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

public fun target(header: &BlockHeader): u256 {
    bits_to_target(header.bits())
}

public fun calc_work(header: &BlockHeader): u256 {
    // We compute the total expected hashes or expected "calc_work".
    //    calc_work of header = 2**256 / (target+1).
    // This is a very clever way to compute this value from bitcoin core. Comments from the bitcoin core:
    // We need to compute 2**256 / (bnTarget+1), but we can't represent 2**256
    // as it's too large for an arith_uint256. However, as 2**256 is at least as large
    // as bnTarget+1, it is equal to ((2**256 - bnTarget - 1) / (bnTarget+1)) + 1,
    // or ~bnTarget / (bnTarget+1) + 1.
    //
    // movelang don't support ~ operator. However, we have 2**256 - 1 = 2**255 + 1.
    // so we have formula bellow:
    let target = header.target();
    return (((1 << 255) + 1 - target) / (target + 1)) + 1
}

// fails if block hash doesn't meet target requirement
public fun pow_check(header:BlockHeader) {
    let work = header.block_hash();
    let target = header.target();
    assert!(target >= to_u256(work), EPoW);
}

fun slice(header: &BlockHeader, start: u64, end: u64): vector<u8> {
    utils::slice(header.internal, start, end)
}
