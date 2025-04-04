// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::utils;

/// === Errors ===
#[error]
const EOutBoundIndex: vector<u8> = b"The index 'n' is out of bounds for the vector";


/// slice() extracts up to but not including end.
public fun slice(v: vector<u8>, start: u64, end: u64): vector<u8> {
    assert!(end <= v.length(), EOutBoundIndex);
    let mut ans = vector[];
    let mut i = start;
    while (i < end) {
        ans.push_back(v[i]);
        i = i + 1;
    };

    ans
}


/// returns nth smallest element in the vector v.
/// NOTE: it mutates the vector v.
public fun nth_element(v: &mut vector<u32>, n: u64): u32 {
    let mut i = 0;
    let len = v.length();

    assert!(n < len, EOutBoundIndex);
    while (i <= n) {
        let mut j = i + 1;
        while (j < len) {
            if (v[i] > v[j]) {
                v.swap(i, j);
            };
            j = j + 1;
        };
        i = i + 1;
    };

    v[n]
}
