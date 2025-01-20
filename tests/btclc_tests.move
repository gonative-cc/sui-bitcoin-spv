/*
#[test_only]
module btclc::btclc_tests;
// uncomment this line to import the module
// use btclc::btclc;

const ENotImplemented: u64 = 0;

#[test]
fun test_btclc() {
    // pass
}

#[test, expected_failure(abort_code = ::btclc::btclc_tests::ENotImplemented)]
fun test_btclc_fail() {
    abort ENotImplemented
}
*/

module btclc::btclc_tests;

#[test]
public fun test_mul() {
    let a = 10 as u256;
    let b = 0xfffffffffffffffffffffffffffffffffffffffffff;
    let c = a * b;
}

