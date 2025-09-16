#[test_only]
module btc_parser::output_tests;

use btc_parser::output;
use std::unit_test::assert_eq;

#[test]
fun pkh_script_happy_cases() {
    let output = &output::new(100, x"76a91455ae51684c43435da751ac8d2173b2652eb6410588ac");
    assert_eq!(output.is_P2PHK(), true);
    assert_eq!(
        output.extract_public_key_hash(),
        option::some(x"55ae51684c43435da751ac8d2173b2652eb64105"),
    );
    let output = &output::new(10, x"79a9140fef69f3ac0d9d0473a318ae508875ad0eae3dcc88ac");
    assert_eq!(output.is_P2PHK(), false);
    let output = &output::new(10, x"0014841b80d2cc75f5345c482af96294d04fdd66b2b7");
    assert_eq!(output.is_P2WPHK(), true);
    assert_eq!(
        output.extract_public_key_hash(),
        option::some(x"841b80d2cc75f5345c482af96294d04fdd66b2b7"),
    );
    let output = &output::new(10, x"0101"); // arbitrary script
    assert_eq!(output.is_P2PHK(), false);
    assert_eq!(output.is_P2WPHK(), false);
    assert_eq!(output.extract_public_key_hash(), option::none());
}

#[test]
fun op_return_script_happy_cases() {
    let data = vector[
        x"6a0b68656c6c6f20776f726c64",
        x"6a",
        x"6a4c0401020304",
        x"6a4d0300010203",
        x"6a4e03000000010203",
    ];
    let expected_result = vector[
        option::some(x"68656c6c6f20776f726c64"),
        option::none(),
        option::some(x"01020304"),
        option::some(x"010203"),
        option::some(x"010203"),
    ];

    data.length().do!(|i| {
        let o = &output::new(0, data[i]);
        // this return error code at test index fails
        assert_eq!(o.is_op_return(), true);
        assert_eq!(o.op_return(), expected_result[i]);
    });

    let output = &output::new(100, x"76a91455ae51684c43435da751ac8d2173b2652eb6410588ac");
    assert_eq!(output.is_op_return(), false);
}

#[test]
fun P2HS_happy_cases() {
    let output = &output::new(100, x"a914b4acb9d78d6a6256964a60484c95de490eaaae7587");
    assert_eq!(output.is_P2SH(), true);
    assert_eq!(
        output.extract_script_hash(),
        option::some(x"b4acb9d78d6a6256964a60484c95de490eaaae75"),
    );
    // add 00 to script
    let output = &output::new(100, x"a914b4acb9d78d6a6256964a60484c95de490eaaae758700");
    assert_eq!(output.is_P2SH(), false);
    assert_eq!(output.extract_script_hash(), option::none());
}

#[test]
fun P2WHS_happy_cases() {
    let output =
        &output::new(100, x"002065f91a53cb7120057db3d378bd0f7d944167d43a7dcbff15d6afc4823f1d3ed3");
    assert_eq!(output.is_P2WSH(), true);
    assert_eq!(
        output.extract_witness_script_hash(),
        option::some(x"65f91a53cb7120057db3d378bd0f7d944167d43a7dcbff15d6afc4823f1d3ed3"),
    );
    // add 00 to script
    let output =
        &output::new(
            100,
            x"002065f91a53cb7120057db3d378bd0f7d944167d43a7dcbff15d6afc4823f1d3ed300",
        );
    assert_eq!(output.is_P2WSH(), false);
    assert_eq!(output.extract_witness_script_hash(), option::none());
}

#[test]
fun taproot_happy_cases() {
    let output =
        &output::new(100, x"51200f0c8db753acbd17343a39c2f3f4e35e4be6da749f9e35137ab220e7b238a667");
    assert_eq!(output.is_taproot(), true);
    assert_eq!(
        output.extract_taproot(),
        option::some(x"0f0c8db753acbd17343a39c2f3f4e35e4be6da749f9e35137ab220e7b238a667"),
    );
    // add 00 to script
    let output =
        &output::new(
            100,
            x"0051200f0c8db753acbd17343a39c2f3f4e35e4be6da749f9e35137ab220e7b238a667",
        );
    assert_eq!(output.is_taproot(), false);
    assert_eq!(output.extract_witness_script_hash(), option::none());
}
