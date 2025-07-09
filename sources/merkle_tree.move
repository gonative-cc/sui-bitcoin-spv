// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::merkle_tree;

use bitcoin_spv::btc_math::btc_hash;

#[error]
const EInvalidMerkleHashLengh: vector<u8> = b"Invalid merkle element hash length";

const HASH_LENGTH: u64 = 32;

/// Internal merkle hash computation for BTC merkle tree
fun merkle_hash(x: vector<u8>, y: vector<u8>): vector<u8> {
    let mut z = x;
    z.append(y);
    btc_hash(z)
}

/// Verifies if tx_id belongs to the merkle tree
public fun verify_merkle_proof(
    root: vector<u8>,
    merkle_path: vector<vector<u8>>,
    tx_id: vector<u8>,
    tx_index: u64,
): bool {
    assert!(root.length() == HASH_LENGTH, EInvalidMerkleHashLengh);
    assert!(tx_id.length() == HASH_LENGTH, EInvalidMerkleHashLengh);
    let mut index = tx_index;

    let merkle_root = merkle_path.fold!(tx_id, |child_hash, merkle_value| {
        assert!(merkle_value.length() == HASH_LENGTH, EInvalidMerkleHashLengh);
        let parent_hash = if (index % 2 == 1) {
            merkle_hash(merkle_value, child_hash)
        } else {
            merkle_hash(child_hash, merkle_value)
        };
        index = index >> 1;
        parent_hash
    });

    merkle_root == root
}
