#[test_only]
module btclc::btc_math_tests;

#[test]
fun target_to_bits_test() {
    let bits = btclc::btc_math::target_to_bits(0x000000000000000000028c610000000000000000000000000000000000000000);
    assert!(bits == 0x17028c61)
}
