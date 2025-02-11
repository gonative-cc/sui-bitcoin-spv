#[test_only]
module bitcoin_spv::utils_test;

use bitcoin_spv::utils::nth_element;

#[test]
fun test_nth_element() {
    let mut v = vector[2, 8, 4, 3, 3];
    assert!(nth_element(&mut v, 1) == 3);
    assert!(nth_element(&mut v, 0) == 2);
    assert!(nth_element(&mut v, 4) == 8);

}
