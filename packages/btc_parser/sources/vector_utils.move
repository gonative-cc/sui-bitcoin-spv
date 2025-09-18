// SPDX-License-Identifier: MPL-2.0

module btc_parser::vector_utils;

#[error]
const EOutOfBounds: vector<u8> = b"Slice out of bounds";

/// Returns slice of a vector for a given range [start_index ,end_index).
public fun vector_slice<T: copy + drop>(
    source: &vector<T>,
    start_index: u64,
    end_index: u64,
): vector<T> {
    assert!(start_index <= end_index, EOutOfBounds);
    assert!(end_index <= source.length(), EOutOfBounds);

    let mut slice = vector::empty<T>();
    let mut i = start_index;
    while (i < end_index) {
        slice.push_back(source[i]);
        i = i + 1;
    };
    slice
}
