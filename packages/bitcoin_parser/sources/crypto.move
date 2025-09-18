// SPDX-License-Identifier: MPL-2.0

module bitcoin_parser::crypto;

use std::hash::sha2_256;

/// Computes sha2_256(sha2_256(data)).
public fun hash256(data: vector<u8>): vector<u8> {
    sha2_256(sha2_256(data))
}
