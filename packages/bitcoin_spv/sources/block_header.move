// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::block_header;

use bitcoin_spv::btc_math::{bits_to_target, to_u256};
use btc_parser::header::BlockHeader;

// === Errors ===

#[error]
const EPoW: vector<u8> =
    b"The block hash does not meet the target difficulty (Proof-of-Work check failed)";

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
    // More information: https://github.com/bitcoin/bitcoin/blob/28.x/src/chain.cpp#L139.

    // we have bitwise_not is ~ operation in move
    let target = target(header);
    (target.bitwise_not() / (target + 1)) + 1
}

/// checks if the block headers meet PoW target requirements. Panics otherewise.
public fun pow_check(header: &BlockHeader) {
    let work = header.block_hash();
    let target = target(header);
    assert!(target >= to_u256(work), EPoW);
}
