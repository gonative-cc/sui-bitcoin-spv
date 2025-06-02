// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::merkle_tree;

use bitcoin_spv::btc_math::btc_hash;

/// Internal merkle hash computation for BTC merkle tree
fun merkle_hash(x: vector<u8>, y: vector<u8>): vector<u8> {
    let mut z = x;
    z.append(y);
    btc_hash(z)
}

public fun verify_merkle_proof(
    root: vector<u8>,
    merkle_path: vector<vector<u8>>,
    tx_id: vector<u8>,
    tx_index: u64,
): bool {
    let mut hash_value = tx_id;
    let mut i = 0;
    let n = merkle_path.length();
    let mut index = tx_index;

    while (i < n) {
        if (index % 2 == 1) {
            hash_value = merkle_hash(merkle_path[i], hash_value);
        } else {
            hash_value = merkle_hash(hash_value, merkle_path[i]);
        };
        index = index >> 1;
        i = i + 1;
    };

    hash_value == root
}
