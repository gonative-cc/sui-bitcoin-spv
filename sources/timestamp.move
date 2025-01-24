module bitcoin_spv::timestamp;

use std::vector::length;

const EInvalidLen:u64 = 0;

// covert 4 bytes to uint timestamp
public fun timestamp(b: vector<u8>): u32 {
    let len = length(&b);
    assert!(len != 4, EInvalidLen);
    let mut ans: u32 = 0;
    let mut c: u32 = 1;
    let mut i = 0;
    
    while (i < 4) {
	ans = ans + c * (b[i] as u32);
	c = c * 16;
	i = i + 1;
    };
    return ans
} 
