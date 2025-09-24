// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::btc_math_tests;

use bitcoin_spv::btc_math::{Self, target_to_bits, bits_to_target};
use std::unit_test::assert_eq;

#[test]
fun to_u256_happy_cases() {
    //  Bytes vector is in little-endian format.
    assert_eq!(
        btc_math::to_u256(
            x"0000000000000000000000000000000000000000000000000000000000000000",
        ),
        0,
    );
    assert_eq!(
        btc_math::to_u256(
            x"0100000000000000000000000000000000000000000000000000000000000000",
        ),
        1,
    );
    assert_eq!(
        btc_math::to_u256(
            x"ff00000000000000000000000000000000000000000000000000000000000000",
        ),
        255,
    );
    assert_eq!(
        btc_math::to_u256(
            x"0001000000000000000000000000000000000000000000000000000000000000",
        ),
        256,
    );
    // 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff  = 2^256 - 1 = 2^255 - 1 + 2^255.
    // we avoid overflow when compare 2 number in this case
    assert_eq!(
        btc_math::to_u256(
            x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        ),
        (1 << 255) - 1 + (1 << 255),
    );
    assert_eq!(
        btc_math::to_u256(
            x"0102030400000000000000000000000000000000000000000000000000000000",
        ),
        67305985,
    );
}

#[test, expected_failure(abort_code = btc_math::EInvalidLength)]
fun to_u256_invalid_length_should_fail() {
    btc_math::to_u256(x"");
}

#[test]
fun bits_to_target_happy_cases() {
    // Data get from btc main net at block 880,086
    let bits = 0x17028c61;
    let target = bits_to_target(bits);
    assert_eq!(target, 0x000000000000000000028c610000000000000000000000000000000000000000);
    assert_eq!(bits, target_to_bits(target));

    // data from block 489,888
    let bits = 0x1800eb30;
    let target = bits_to_target(bits);
    assert_eq!(target, 0x000000000000000000eb30000000000000000000000000000000000000000000);
    assert_eq!(bits, target_to_bits(target));

    // block 860832
    let bits = 0x1703098c;
    let target = bits_to_target(bits);
    assert_eq!(target, 0x00000000000000000003098c0000000000000000000000000000000000000000);
    assert_eq!(bits, target_to_bits(target));

    let bits = 0x2000ffff;
    let target = bits_to_target(bits);
    assert_eq!(target, 0x00ffff0000000000000000000000000000000000000000000000000000000000);
    assert_eq!(bits, target_to_bits(target));

    // https://learnmeabitcoin.com/explorer/block/0000000000519051eb5f3c5943cdbc176a0eff4e1fbc3e08287bdb76299b8e5c
    let bits = 0x1c0168fd;
    let target = bits_to_target(bits);
    assert_eq!(target, 0x000000000168fd00000000000000000000000000000000000000000000000000);
    assert_eq!(bits, target_to_bits(target));
}
