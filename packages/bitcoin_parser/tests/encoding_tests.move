// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_parser::encoding_tests;

use bitcoin_parser::encoding::{u32_to_le_bytes, u64_to_le_bytes, u64_to_varint_bytes};
use std::unit_test::assert_eq;

#[test]
fun test_u32_to_le_bytes() {
    assert_eq!(u32_to_le_bytes(0x12345678), x"78563412");
    assert_eq!(u32_to_le_bytes(1), x"01000000");
}

#[test]
fun test_u64_to_le_bytes() {
    assert_eq!(u64_to_le_bytes(0x123456789abcdef0), x"f0debc9a78563412");
    assert_eq!(u64_to_le_bytes(1), x"0100000000000000");
}

#[test]
fun test_u64_to_varint_bytes() {
    assert_eq!(u64_to_varint_bytes(0), x"00");
    assert_eq!(u64_to_varint_bytes(10), x"0a");
    assert_eq!(u64_to_varint_bytes(252), x"fc");
    assert_eq!(u64_to_varint_bytes(253), x"fdfd00");
    assert_eq!(u64_to_varint_bytes(1000), x"fde803");
    assert_eq!(u64_to_varint_bytes(65535), x"fdffff");
    assert_eq!(u64_to_varint_bytes(65536), x"fe00000100");
    assert_eq!(u64_to_varint_bytes(4294967295), x"feffffffff");
    assert_eq!(u64_to_varint_bytes(4294967296), x"ff0000000001000000");
}
