module bitcoin_spv::btc_math;

use std::hash;

/// === Errors ===
const EInvalidLength: u64 = 0;


/// convert 4 bytes in little endian format to u32 number
public fun to_u32(v: vector<u8>): u32 {
    assert!(v.length() == 4, EInvalidLength);
    let mut ans = 0u64;
    let mut i = 0;
    let mut c = 1u64;
    while (i < 4) {
        ans = ans + (v[i] as u64) * c;
        c = c * 256u64;
        i = i + 1;
    };

    ans as u32
}

/// double hash of value
public fun btc_hash(data: vector<u8>): vector<u8> {
    let first_hash = hash::sha2_256(data);
    let second_hash = hash::sha2_256(first_hash);
    return second_hash
}
