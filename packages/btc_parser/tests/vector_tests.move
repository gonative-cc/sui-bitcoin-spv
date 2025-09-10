#[test_only]
module btc_parser::vector_tests;

use btc_parser::vector_utils::vector_slice;
use std::unit_test::assert_eq;

// TODO: add more tests for slice
#[test]
fun test_vector_slice() {
    let v = vector[1, 2, 3, 4, 5];
    assert_eq!(vector_slice(&v, 1, 4), vector[2, 3, 4]); // [1, 2, 3, 4, 5] -> [2, 3, 4]
}
