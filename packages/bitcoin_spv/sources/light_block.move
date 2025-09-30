// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::light_block;

use bitcoin_parser::header::BlockHeader;

public struct LightBlock has copy, drop, store {
    height: u64,
    chain_work: u256, // total work
    header: BlockHeader,
}

public fun new_light_block(height: u64, header: BlockHeader, chain_work: u256): LightBlock {
    LightBlock {
        height,
        chain_work,
        header: header,
    }
}

/*
 * Light Block methods
 */

public fun height(lb: &LightBlock): u64 {
    lb.height
}

public fun header(lb: &LightBlock): &BlockHeader {
    &lb.header
}

public fun chain_work(lb: &LightBlock): u256 {
    lb.chain_work
}
