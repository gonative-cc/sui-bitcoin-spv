#[test_only]
module bitcoin_spv::difficulty_test;

use bitcoin_spv::difficulty::{bits_to_target, target_to_bits};
use sui::test_scenario;

#[test]
fun bits_to_target_tests() {
    // Data get from btc main net at block 880,086
    let bits = 0x17028c61;
    let target = bits_to_target(bits);
    assert!(target == 0x000000000000000000028c610000000000000000000000000000000000000000);
    assert!(bits == target_to_bits(target));
    
    // data from block 489,888
    let bits = 0x1800eb30;
    let target = bits_to_target(bits);
    assert!(target == 0x000000000000000000eb30000000000000000000000000000000000000000000);
    assert!(bits == target_to_bits(target));
}

#[test]
fun difficulty_computation_tests() {
    let sender = @0x01;
    let scenario = test_scenario::begin(sender);
    
    test_scenario::end(scenario);
}
