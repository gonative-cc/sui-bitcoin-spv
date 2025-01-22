#[test_only]
module bitcoin_spv::btc_math_tests;

use bitcoin_spv::difficulty::{bits_to_target, target_to_bits};

#[test]
fun target_to_bits_test() {
    // Data get from btc main net at block 880,086
    let bits = target_to_bits(0x000000000000000000028c610000000000000000000000000000000000000000);
    assert!(bits == 0x17028c61)
}

#[test]
fun bits_to_target_test() {
    // Data get from btc main net at block 880,086
    let target = bits_to_target(0x17028c61);
    assert!(target == 0x000000000000000000028c610000000000000000000000000000000000000000)
}
