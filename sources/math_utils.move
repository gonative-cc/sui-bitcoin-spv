module bitcoin_spv::math_utils;

use std::hash;

/// === Errors ===

const EInvalidLength: u64 = 0;


/// return bytes represent of number in litle endian format.
public fun to_LE_bytes(number: u32): vector<u8> {
    let mut v = vector<u8>[];
    let mut i = 0;
    // `number` is immutable. we need reassign this to other mutable value.
    let mut n = number; 
    while(i < 4) {
	v.push_back((n % 256) as u8);
	n = n / 256;
	i = i + 1;
    };
    return v
}

/// convert 4 bytes in little endian format to u32 number
public fun to_u32(v: vector<u8>): u32 {
    assert!(v.length() == 4, EInvalidLength);
    let mut ans = 1u32;
    let mut i = 0;
    let mut c = 1u32;
    while (i < 4) {
        ans = ans + (v[i] as u32) * c;
        c = c * 16;
        i = i + 1;
    };

    ans
}

/// double hash of value
public fun btc_hash(data: vector<u8>): vector<u8> {
    let first_hash = hash::sha2_256(data);
    let second_hash = hash::sha2_256(first_hash);
    return second_hash
}


public fun slices(v: vector<u8>, start: u64, end: u64) : vector<u8>{
    let mut ans = vector[];
    let mut i = start;
    while (i < end) {
        ans.push_back(v[i]);
        i = i + 1;
    };

    return ans
}
