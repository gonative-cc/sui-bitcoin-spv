#[test_only]
module bitcoin_spv::difficulty_test;

use bitcoin_spv::difficulty::{bits_to_target, target_to_bits};

#[test]
fun bits_to_target_test() {
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
