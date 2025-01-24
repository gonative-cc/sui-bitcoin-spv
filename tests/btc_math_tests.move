#[test_only]
module bitcoin_spv::btc_math_tests;
use bitcoin_spv::btc_math;


#[test]
fun btc_hash_test() {
    let pre_image = x"00000020acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000dd0258540ffa51df2af80bd4e3ae82b7781c167ec84d4001e09c2e4053cdc4410d0f8864697e0517893b3045";
    let result = x"37ed684e163e76275a38fc0a318730c0aed92967f64c03000000000000000000";

    assert!(btc_math::btc_hash(pre_image) == result);
}

#[test]
fun to_u32_test() {    
    assert!(btc_math::to_u32(x"00000000") == 0u32);
    assert!(btc_math::to_u32(x"00000001") == 1u32);
    assert!(btc_math::to_u32(x"000000ff") == 255u32);
    assert!(btc_math::to_u32(x"00000100") == 256u32);
    assert!(btc_math::to_u32(x"ffffffff") == 4294967295u32);
    assert!(btc_math::to_u32(x"01020304") == 67305985u32);
}
