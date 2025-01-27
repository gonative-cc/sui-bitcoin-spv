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
