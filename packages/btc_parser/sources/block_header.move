// SPDX-License-Identifier: MPL-2.0

module btc_parser::header;

use btc_parser::crypto::hash256;
use btc_parser::reader;

// === Constants ===
const BLOCK_HEADER_SIZE: u64 = 80;

#[error]
const EInvalidBlockHeaderSize: vector<u8> = b"The block header must be exactly 80 bytes long";

public struct BlockHeader has copy, drop, store {
    version: u32,
    parent: vector<u8>,
    merkle_root: vector<u8>,
    timestamp: u32,
    bits: u32,
    nonce: u32,
    block_hash: vector<u8>,
}

// === Block header methods ===

/// New block header
public fun new(raw_block_header: vector<u8>): BlockHeader {
    assert!(raw_block_header.length() == BLOCK_HEADER_SIZE, EInvalidBlockHeaderSize);
    let mut r = reader::new(raw_block_header);
    BlockHeader {
        version: r.read_u32(),
        parent: r.read(32),
        merkle_root: r.read(32),
        timestamp: r.read_u32(),
        bits: r.read_u32(),
        nonce: r.read_u32(),
        block_hash: hash256(raw_block_header),
    }
}

public fun block_hash(header: &BlockHeader): vector<u8> {
    header.block_hash
}

public fun version(header: &BlockHeader): u32 {
    header.version
}

/// return parent block ID (hash)
public fun parent(header: &BlockHeader): vector<u8> {
    header.parent
}

public fun merkle_root(header: &BlockHeader): vector<u8> {
    header.merkle_root
}

public fun timestamp(header: &BlockHeader): u32 {
    header.timestamp
}

public fun bits(header: &BlockHeader): u32 {
    header.bits
}

public fun nonce(header: &BlockHeader): u32 {
    header.nonce
}
