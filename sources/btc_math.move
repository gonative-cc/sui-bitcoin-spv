module bitcoin_spv::btc_math;

use std::hash;

/// === Errors ===
const EInvalidLength: u64 = 0;


/// convert 4 bytes in little endian format to u32 number
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

/// convert 32 bytes in little endian format to u256 number.
// TODO: check can we generic to_u32 and to_u256 
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

/// double hash of value
public fun btc_hash(data: vector<u8>): vector<u8> {
    let first_hash = hash::sha2_256(data);
    let second_hash = hash::sha2_256(first_hash);
    return second_hash
}

