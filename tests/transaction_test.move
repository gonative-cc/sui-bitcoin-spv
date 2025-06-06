// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::transaction_tests;

use bitcoin_spv::light_client::new_light_client;
use bitcoin_spv::params;
use bitcoin_spv::transaction::{make_transaction, parse_output};
use sui::test_scenario;

#[test]
fun decoded_transaction_tests() {
    // Tx: dc7ed74b93823c33544436cda1ea66761d708aafe08b80cd69c4f42d049a703c (Height 303,699)
    // from mainnet

    let tx =
        &make_transaction(
            x"01000000",
            1,
            x"c08ce0edcedc47becf03f923479bec4c184cda060452959f59d47ae8923da032010000006b483045022100cfdcc3fc354c8d2bbf22d708723e1c3836629c0ed6ef9485004d674ca06e0c6102204dee8d1180a309d22aa66e83554d992b751298208bc1b1e0d60f74fe834634330121036b4468fc9f4dc283365c70f7989b944586a260fca5358a91dfc50bf13c071b1effffffff",
            2,
            x"20a10700000000001976a9140fef69f3ac0d9d0473a318ae508875ad0eae3dcc88acc8ec7100000000001976a91451e6b602f387b4c5bb8a4d8cdf1b059c826374e388ac",
            x"00000000",
        );

    assert!(tx.tx_id() == x"3c709a042df4c469cd808be0af8a701d7666eaa1cd364454333c82934bd77edc");

    let outputs = tx.outputs();

    assert!(outputs[0].extract_public_key_hash() == x"0fef69f3ac0d9d0473a318ae508875ad0eae3dcc");
    assert!(outputs[0].amount() == 500000);
    assert!(outputs[1].extract_public_key_hash() == x"51e6b602f387b4c5bb8a4d8cdf1b059c826374e3");
    assert!(outputs[1].amount() == 7466184);

    // ported from summa-tx/bitcoin-spv
    // https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/test/ViewSPV.test.js#L56
    // https://github.com/summa-tx/bitcoin-spv/blob/master/testVectors.json#L1124
    let tx =
        &make_transaction(
            x"01000000",
            1,
            x"1746bd867400f3494b8f44c24b83e1aa58c4f0ff25b4a61cffeffd4bc0f9ba300000000000ffffffff",
            2,
            x"4897070000000000220020a4333e5612ab1a1043b25755c89b16d55184a42f81799e623e6bc39db8539c180000000000000000166a14edb1b5c2f39af0fec151732585b1049b07895211",
            x"00000000",
        );

    assert!(tx.tx_id() == x"48e5a1a0e616d8fd92b4ef228c424e0c816799a256c6a90892195ccfc53300d6");
}

#[test]
fun pkh_script_tests() {
    let output = &parse_output(100, x"76a91455ae51684c43435da751ac8d2173b2652eb6410588ac");
    assert!(output.is_P2PHK() == true);
    assert!(output.extract_public_key_hash() == x"55ae51684c43435da751ac8d2173b2652eb64105");
    let output = &parse_output(10, x"79a9140fef69f3ac0d9d0473a318ae508875ad0eae3dcc88ac");
    assert!(output.is_P2PHK() == false);
    let output = &parse_output(10, x"0014841b80d2cc75f5345c482af96294d04fdd66b2b7");
    assert!(output.is_P2WPHK() == true);
    assert!(output.extract_public_key_hash() == x"841b80d2cc75f5345c482af96294d04fdd66b2b7");
    let output = &parse_output(10, x"0101"); // arbitrary script
    assert!(output.is_P2PHK() == false);
    assert!(output.is_P2WPHK() == false);
    assert!(output.extract_public_key_hash() == vector[]);
}

#[test]
fun op_return_script_tests() {
    let data = vector[
        x"6a0b68656c6c6f20776f726c64",
        x"6a",
        x"6a4c0401020304",
        x"6a4d0300010203",
        x"6a4e03000000010203",
    ];
    let expected_result = vector[x"68656c6c6f20776f726c64", x"", x"01020304", x"010203", x"010203"];

    let mut i = 0;
    while (i < data.length()) {
        let o = &parse_output(0, data[i]);
        // this return error code at test index fails
        assert!(o.is_op_return(), i);
        assert!(o.op_return() == expected_result[i], i);
        i = i + 1;
    };

    let output = &parse_output(100, x"76a91455ae51684c43435da751ac8d2173b2652eb6410588ac");
    assert!(output.is_op_return() == false);
}
