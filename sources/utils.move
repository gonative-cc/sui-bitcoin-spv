module bitcoin_spv::utils;

/// slice() extracts up to but not including end.
public fun slice(v: vector<u8>, start: u64, end: u64): vector<u8> {
    // TODO: handle error when start,end position > length's v.
    let mut ans = vector[];
    let mut i = start;
    while (i < end) {
        ans.push_back(v[i]);
        i = i + 1;
    };

    return ans
}


public fun nth_element(v: &mut vector<u64>, n: u64): u64 {
    let mut i = 0;
    let len = v.length();

    assert!(n < len, 0);
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
