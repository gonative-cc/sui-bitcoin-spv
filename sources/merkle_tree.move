// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::merkle_tree;

use bitcoin_spv::btc_math::btc_hash;
use std::hash::sha2_256;

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
/// BTC doesn't recognize different between 64 bytes Tx and internal merkle tree node, that reduces the security of SPV proofs.
/// For more details:
/// - https://bitslog.com/2018/06/09/leaf-node-weakness-in-bitcoin-merkle-tree-design
/// We modified the merkle tree verify algorithm inspire by this solution:
/// - https://bitslog.com/2018/08/21/simple-change-to-the-bitcoin-merkleblock-command-to-protect-from-leaf-node-weakness-in-transaction-merkle-tree/
/// The main idea instead of compute new merkle node = HASH256(X||Y) with X, Y is children nodes.
/// We compute new merkle node = HASH256(SHA256(M), Y) which X = SHA256(M) or HASH256(X, SHA256(N)),
/// depends on the current not is right or left.
/// Send N(M) make the space is huge for attacker.
/// The trade off here is we need more hash execution.
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

        let h = sha2_256(merkle_value);
        let parent_hash = if (index % 2 == 1) {
            merkle_hash(h, child_hash)
        } else {
            merkle_hash(child_hash, h)
        };
        index = index >> 1;
        parent_hash
    });
    merkle_root == root
}
