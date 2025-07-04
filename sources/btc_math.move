// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::btc_math;

use std::hash;
use std::u64::do;

#[test_only]
use std::unit_test::assert_eq;

/// === Errors ===
#[error]
const EInvalidLength: vector<u8> = b"The input vector has an invalid length";
#[error]
const EInvalidCompactSizeDecode: vector<u8> = b"Invalid compact size encoding during decoding";
#[error]
const EInvalidCompactSizeEncode: vector<u8> = b"Invalid compact size encoding during encoding";
#[error]
const EInvalidNumberSize: vector<u8> = b"Input vector size does not match with expected size";

/// Converts 4 bytes in little endian format to u32 number
public fun to_u32(v: vector<u8>): u32 {
    assert!(v.length() == 4, EInvalidLength);
    let mut ans = 0u32;
    let mut i = 0u8;
    while (i < 4) {
        ans = ans + ((v[i as u64] as u32) << i*8);
        i = i + 1;
    };

    ans
}

/// Converts 32 bytes in little endian format to u256 number.
public fun to_u256(v: vector<u8>): u256 {
    assert!(v.length() == 32, EInvalidLength);
    let mut ans = 0u256;
    let mut i = 0;

    while (i < 32) {
        ans = ans +  ((v[i] as u256)  << (i * 8 as u8));
        i = i + 1;
    };
    ans
}

public fun extract_u64(v: vector<u8>, start: u64, end: u64): u64 {
    let size = end - start;
    assert!(size <= 8, EInvalidNumberSize);
    assert!(end <= v.length(), EInvalidLength);
    let mut ans = 0;
    let mut i = start;
    let mut j = 0;
    while (i < end) {
        ans = ans +  ((v[i] as u64)  << (j * 8 as u8));
        i = i + 1;
        j = j + 1;
    };
    ans
}

/// Double hashes the value
public fun btc_hash(data: vector<u8>): vector<u8> {
    let first_hash = hash::sha2_256(data);
    let second_hash = hash::sha2_256(first_hash);
    second_hash
}

/// Calculates offset for decoding a Bitcoin compact size integer.
fun compact_size_offset(start_byte: u8): u64 {
    if (start_byte <= 0xfc) {
        return 0
    };
    if (start_byte == 0xfd) {
        return 2
    };
    if (start_byte == 0xfe) {
        return 4
    };
    // 0xff
    8
}

/// Decodes a compact number - number of integer bytes, from the vector `v`.
/// Returns the decoded number and the first index in `v` after the number.
public fun compact_size(v: vector<u8>, start: u64): (u64, u64) {
    let offset = compact_size_offset(v[start]);
    assert!(start + offset < v.length(), EInvalidCompactSizeDecode);
    if (offset == 0) {
        return (v[start] as u64, start + 1)
    };
    (extract_u64(v, start + 1, start + offset + 1), start + offset + 1)
}

/// number of bytes to represent number.
fun bytes_of(number: u256): u8 {
    let mut b: u8 = 255;
    while (number & (1 << b) == 0 && b > 0) {
        b = b - 1;
    };
    // Follow logic in bitcoin core
    ((b as u32) / 8 + 1) as u8
}

/// Returns last 32 bits of a number.
fun get_last_32_bits(number: u256): u32 {
    (number & 0xffffffff) as u32
}

/// target => bits conversion function.
/// target is the number you need to get below to mine a block - it defines the difficulty.
/// The bits field contains a compact representation of the target.
/// format of bits = <1 byte for exponent><3 bytes for coefficient>
/// target = coefficient * 2^ (coefficient - 3) (note: 3 = bytes length of the coefficient).
/// Caution:
///    The first significant byte for the coefficient must be below 80. If it's not, you have to take the preceding 00 as the first byte.
/// More & examples: https://learnmeabitcoin.com/technical/block/bits.
public fun target_to_bits(target: u256): u32 {
    // TODO: Handle case nagative target?
    // I checked bitcoin-code. They did't create any negative target.

    let mut exponent = bytes_of(target);
    let mut coefficient;
    if (exponent <= 3) {
        let bits_shift: u8 = 8 * ( 3 - exponent);
        coefficient = get_last_32_bits(target) << bits_shift;
    } else {
        let bits_shift: u8 = 8 * (exponent - 3);
        let bn = target >> bits_shift;
        coefficient = get_last_32_bits(bn)
    };

    // handle case target is negative number.
    // 0x00800000 is set then it indicates a negative value
    // and target can be negative
    if (coefficient & 0x00800000 > 0) {
        // we push 00 before coefficet
        coefficient = coefficient >> 8;
        exponent = exponent + 1;
    };

    let compact = coefficient | ((exponent as u32) << 24);

    // TODO: Check case target is a negative number.
    // However, the target mustn't be a negative number

    compact
}

/// Converts bits to target. See documentation to the function above for more details.
public fun bits_to_target(bits: u32): u256 {
    let exponent = bits >> 3*8;

    // extract coefficient path or get last 24 bit of `bits`
    let mut target = (bits & 0x007fffff) as u256;

    if (exponent <= 3) {
        let bits_shift = (8 * (3 - exponent)) as u8;
        target = target >> bits_shift;
    } else {
        let bits_shift = (8 * (exponent - 3)) as u8;
        target = target << bits_shift;
    };
    target
}

/// Encodes a u256 into VarInt format.
/// https://learnmeabitcoin.com/technical/general/compact-size/
public fun u256_to_compact(number: u256): vector<u8> {
    let mut ans = vector[];
    let mut n = number;
    if (n <= 252) {
        ans.push_back(n as u8);
    } else if (n <= 65535) {
        ans.push_back(0xfd);
        do!(2, |_i| {
            ans.push_back((n & 0xff) as u8);
            n = n >> 8;
        });
    } else if (n <= 4294967295) {
        ans.push_back(0xfe);
        do!(4, |_i| {
            ans.push_back((n & 0xff) as u8);
            n = n >> 8;
        });
    } else if (n <= 18446744073709551615) {
        ans.push_back(0xff);
        do!(8, |_i| {
            ans.push_back((n & 0xff) as u8);
            n = n >> 8;
        });
    } else {
        abort EInvalidCompactSizeEncode
    };

    ans
}

// internal test
// TODO: Check best practice to improve test
#[test]
fun bytes_of_happy_cases() {
    assert_eq!(bytes_of(1), 1);
    assert_eq!(bytes_of(7), 1);
    assert_eq!(bytes_of(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), 32);
}

#[test]
/// get last 32 bits of number
fun get_last_32_bits_happy_cases() {
    assert_eq!(get_last_32_bits(0), 0);
    assert_eq!(
        get_last_32_bits(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
        0xffffffff,
    );
    assert_eq!(get_last_32_bits(0x0123456789), 0x23456789);
}

#[test]
fun check_compact_size_format_happy_cases() {
    let inputs = vector[0x0a, 0xfc, 0xfd, 0xfe, 0xff];
    let outputs = vector[0, 0, 2, 4, 8];

    let mut i = 0;
    while (i < inputs.length()) {
        assert_eq!(compact_size_offset(inputs[i]), outputs[i]);
        i = i + 1;
    }
}

#[test]
fun u256_to_compact_happy_cases() {
    assert_eq!(u256_to_compact(0), x"00");
    assert_eq!(u256_to_compact(10), x"0a");
    assert_eq!(u256_to_compact(252), x"fc");
    assert_eq!(u256_to_compact(253), x"fdfd00");
    assert_eq!(u256_to_compact(1000), x"fde803");
    assert_eq!(u256_to_compact(65535), x"fdffff");
    assert_eq!(u256_to_compact(65536), x"fe00000100");
    assert_eq!(u256_to_compact(4294967295), x"feffffffff");
    assert_eq!(u256_to_compact(4294967296), x"ff0000000001000000");
    assert_eq!(u256_to_compact(0xff), x"fdff00");
    assert_eq!(u256_to_compact(0xfe), x"fdfe00");
    assert_eq!(u256_to_compact(0xff00), x"fd00ff");
}

#[test, expected_failure(abort_code = EInvalidCompactSizeEncode)]
fun u256_to_compact_invalid_compact_size_should_fail() {
    u256_to_compact(18446744073709551615 + 1);
}
