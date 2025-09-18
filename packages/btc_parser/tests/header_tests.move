// SPDX-License-Identifier: MPL-2.0

#[test_only]
module btc_parser::header_tests;

use btc_parser::encoding::u32_to_le_bytes;
use btc_parser::header::{new, EInvalidBlockHeaderSize};
use std::unit_test::assert_eq;

#[test]
fun block_header_happy_case() {
    // data get from block 0000000000000000000293bf6e86820d867cc4ca13cd98326af85bb3bebab9ac from mainnet
    // or block 794143
    let raw_header =
        x"000080200e102b98a160f4416c8ff0198db9b177523525c9de8a000000000000000000003b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b560e8864697e051767c0c9fd";
    let header = new(raw_header);

    // verify data extract from header
    assert_eq!(u32_to_le_bytes(header.version()), x"00008020");
    assert_eq!(
        header.parent(),
        x"0e102b98a160f4416c8ff0198db9b177523525c9de8a00000000000000000000",
    );
    assert_eq!(
        header.merkle_root(),
        x"3b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b",
    );
    assert_eq!(u32_to_le_bytes(header.timestamp()), x"560e8864");
    assert_eq!(u32_to_le_bytes(header.bits()), x"697e0517");
    assert_eq!(u32_to_le_bytes(header.nonce()), x"67c0c9fd");
    assert_eq!(
        header.block_hash(),
        x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000",
    );
}
#[test, expected_failure(abort_code = EInvalidBlockHeaderSize)]
fun block_header_size_too_short_should_fail() {
    new(x"0123456789abcdef");
}

#[test, expected_failure(abort_code = EInvalidBlockHeaderSize)]
fun block_header_size_too_long_should_fail() {
    new(
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d00000000ffff",
    );
}
