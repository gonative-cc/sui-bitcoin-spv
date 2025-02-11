#[test_only]
module bitcoin_spv::utils_test;

use bitcoin_spv::utils::{nth_element, EOutBoundIndex};

#[test]
fun test_nth_element() {
    let mut v = vector[2, 8, 4, 3, 3];
    assert!(nth_element(&mut v, 1) == 3);
    assert!(nth_element(&mut v, 0) == 2);
    assert!(nth_element(&mut v, 4) == 8);

    assert!(nth_element(&mut vector[1,2,3,4,5,6], 0) == 1);
    assert!(nth_element(&mut vector[1,2,3,4,5,6], 1) == 2);
    assert!(nth_element(&mut vector[1,2,3,4,5,6], 2) == 3);
    assert!(nth_element(&mut vector[1,2,3,4,5,6], 5) == 6);
    assert!(nth_element(&mut vector[9,8,7,6,5,4], 0) == 4);
    assert!(nth_element(&mut vector[9,8,7,6,5,4], 1) == 5);
    assert!(nth_element(&mut vector[9,8,7,6,5,4], 2) == 6);
    assert!(nth_element(&mut vector[9,8,7,6,5,4], 4) == 8);
    assert!(nth_element(&mut vector[9,8,7,6,5,4], 5) == 9);
    assert!(nth_element(&mut vector[1], 0) == 1);
    assert!(nth_element(&mut vector[8, 3, 4, 5, 5, 5], 3) == 5);
}

#[test]
#[expected_failure(abort_code = EOutBoundIndex)]
fun test_nth_element_outbound_index() {
    nth_element(&mut vector[], 1);
}
