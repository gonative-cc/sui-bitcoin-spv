// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::utils_test;

use bitcoin_spv::utils::{nth_element, EOutBoundIndex, slice, EInvalidSliceRange};
use std::unit_test::assert_eq;

#[test]
fun nth_element_happy_cases() {
    let mut v = vector[2, 8, 4, 3, 3];
    assert_eq!(nth_element(&mut v, 1), 3);
    assert_eq!(nth_element(&mut v, 0), 2);
    assert_eq!(nth_element(&mut v, 4), 8);

    assert_eq!(nth_element(&mut vector[1, 2, 3, 4, 5, 6], 0), 1);
    assert_eq!(nth_element(&mut vector[1, 2, 3, 4, 5, 6], 1), 2);
    assert_eq!(nth_element(&mut vector[1, 2, 3, 4, 5, 6], 2), 3);
    assert_eq!(nth_element(&mut vector[1, 2, 3, 4, 5, 6], 5), 6);
    assert_eq!(nth_element(&mut vector[9, 8, 7, 6, 5, 4], 0), 4);
    assert_eq!(nth_element(&mut vector[9, 8, 7, 6, 5, 4], 1), 5);
    assert_eq!(nth_element(&mut vector[9, 8, 7, 6, 5, 4], 2), 6);
    assert_eq!(nth_element(&mut vector[9, 8, 7, 6, 5, 4], 4), 8);
    assert_eq!(nth_element(&mut vector[9, 8, 7, 6, 5, 4], 5), 9);
    assert_eq!(nth_element(&mut vector[1], 0), 1);
    assert_eq!(nth_element(&mut vector[8, 3, 4, 5, 5, 5], 3), 5);
}

#[test, expected_failure(abort_code = EOutBoundIndex)]
fun test_nth_element_outbound_index() {
    nth_element(&mut vector[], 1);
}

#[test]
fun slice_happy_cases() {
    assert_eq!(slice(vector[1, 2, 3], 1, 2), vector[2]);
    assert_eq!(slice(vector[1, 2, 3, 9, 10], 2, 4), vector[3, 9]);
}

#[test, expected_failure(abort_code = EInvalidSliceRange)]
fun slice_invalid_slice_range_fail() {
    slice(vector[1, 2], 2, 2);
}

#[test, expected_failure(abort_code = EOutBoundIndex)]
fun slice_out_bound_index_fail() {
    slice(vector[1, 2], 2, 3);
}
