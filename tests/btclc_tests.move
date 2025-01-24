/*
#[test_only]
module bitcoin_spv::bitcoin_spv_tests;
// uncomment this line to import the module
// use bitcoin_spv::bitcoin_spv;

const ENotImplemented: u64 = 0;

#[test]
fun test_bitcoin_spv() {
    // pass
}

#[test, expected_failure(abort_code = ::bitcoin_spv::bitcoin_spv_tests::ENotImplemented)]
fun test_bitcoin_spv_fail() {
    abort ENotImplemented
}
*/

module bitcoin_spv::bitcoin_spv_tests;

#[test]
public fun test_mul() {
    let a = 10 as u256;
    let b = 0xfffffffffffffffffffffffffffffffffffffffffff;
    let c = a * b;
}

