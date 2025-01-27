#[test_only]
module bitcoin_spv::btc_math_tests;

use bitcoin_spv::btc_math;

#[test]
fun btc_hash_test() {
    let pre_image =
        x"00000020acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000dd0258540ffa51df2af80bd4e3ae82b7781c167ec84d4001e09c2e4053cdc4410d0f8864697e0517893b3045";
    let result = x"37ed684e163e76275a38fc0a318730c0aed92967f64c03000000000000000000";

    assert!(btc_math::btc_hash(pre_image) == result);
}

#[test]
fun to_u32_test() {
    //  Bytes vector is in little-endian format.
    assert!(btc_math::to_u32(x"00000000") == 0u32);
    assert!(btc_math::to_u32(x"01000000") == 1u32);
    assert!(btc_math::to_u32(x"ff000000") == 255u32);
    assert!(btc_math::to_u32(x"00010000") == 256u32);
    assert!(btc_math::to_u32(x"ffffffff") == 4294967295u32);
    assert!(btc_math::to_u32(x"01020304") == 67305985u32);
}

#[test]
fun to_u256_test() {
    //  Bytes vector is in little-endian format.
    assert!(
        btc_math::to_u256(x"0000000000000000000000000000000000000000000000000000000000000000") == 0,
    );
    assert!(
        btc_math::to_u256(x"0100000000000000000000000000000000000000000000000000000000000000") == 1,
    );
    assert!(
        btc_math::to_u256(x"ff00000000000000000000000000000000000000000000000000000000000000") == 255,
    );
    assert!(
        btc_math::to_u256(x"0001000000000000000000000000000000000000000000000000000000000000") == 256,
    );
    assert!(
        btc_math::to_u256(x"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff") == (1 << 255) - 1 + (1 << 255),
    );
    assert!(
        btc_math::to_u256(x"0102030400000000000000000000000000000000000000000000000000000000") == 67305985,
    );
}
