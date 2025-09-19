// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::tx_verification_tests;

use bitcoin_parser::header;
use bitcoin_spv::light_client::{new_light_client, LightClient};
use bitcoin_spv::params;
use std::unit_test::assert_eq;
use sui::test_scenario;

#[test_only]
fun new_lc_for_test(ctx: &mut TxContext): LightClient {
    let start_block = 99993;
    let headers = vector[
        x"01000000acda3db591d5c2c63e8c09e7523a5b0581707ef3e3520d6ca180000000000000701179cb9a9e0fe709cc96261b6b943b31362b61dacba94b03f9b71a06cc2eff7d1c1b4d4c86041b75962f88",
        x"010000007cb25d910aa274ad3e520e80e1e37440a7a2914b34ccd827f806030000000000fae45c19a095c8c796acf7a07257822f4e3c42c9d2ce513ceabc0188c041b6f8a21c1b4d4c86041be1dc4463",
    ].map!(|h| header::new(h));
    // confirmation_depth=2 => block is "final" after second confirmation.
    new_light_client(params::mainnet(), start_block, headers, 0, 2, ctx)
}

#[test_only]
// a sample valid (height, tx_id, proof, tx_index)
fun sample_data(): (u64, vector<u8>, vector<vector<u8>>, u64) {
    let height = 99993; // block 99993 on mainnet
    let proof = vector[
        x"a2fff7e7aa4ffd33f8a05b3a9b6f3cba22826c0232c4784a2aca1c4fe47597f9",
        // this block have only one tx aka coinbase.
        x"9013cd2f322864fe9efd45955aacb36ee21efc4f49a4e2aa393a9ba029f0e6b8",
    ];
    let tx_id = x"8a9091a722fd88bf7a5e2efdff55d39937eff9ae7d69c700d19d795113a35312";
    let tx_index = 1;
    (height, tx_id, proof, tx_index)
}

#[test]
fun verify_tx_happy_cases() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let lc = new_lc_for_test(scenario.ctx());

    let (height, tx_id, proof, tx_index) = sample_data();
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, true);

    let (height, tx_id, proof, _) = sample_data();
    let tx_index = 100;
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    let (height, _, proof, tx_index) = sample_data();
    let tx_id = vector::tabulate!(32, |_| 0);
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    let (height, tx_id, _, tx_index) = sample_data();
    let proof = vector[];
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    // https://learnmeabitcoin.com/explorer/block/000000000003eea21d9f1b96fe87abfcd241cac75f3a2762a8f0a14c429c7901
    // confirmation_depth=2, this block is not finalized in the test.
    let res = lc.verify_tx(
        height + 1,
        // coinbase tx
        x"fae45c19a095c8c796acf7a07257822f4e3c42c9d2ce513ceabc0188c041b6f8",
        vector[],
        0,
    );
    assert_eq!(res, false);
    sui::test_utils::destroy(lc);
    scenario.end();
}
