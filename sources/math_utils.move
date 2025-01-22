module bitcoin_spv::math_utils;

use std::hash;

/// return bytes represent of number in litle endian format.
public fun u32_to_LE_bytes(number: u32): vector<u8> {
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

/// double hash of value
public fun btc_hash(data: vector<u8>): vector<u8> {
    let first_hash = hash::sha2_256(data);
    let second_hash = hash::sha2_256(first_hash);
    return second_hash
}
