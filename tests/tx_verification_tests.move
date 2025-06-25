// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::tx_verification_tests;

use bitcoin_spv::light_client::{new_light_client, LightClient};
use bitcoin_spv::params;
use std::unit_test::assert_eq;
use sui::test_scenario;

#[test_only]
fun new_lc_for_test(ctx: &mut TxContext): LightClient {
    let start_block = 858816;
    let headers = vector[
        x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351",
        x"00202f28bb75702a5916b4014fe51cbaacbb0902a70f0be574e6010000000000000000006638ae669a2108e4e9440ed48cacc415b930138d3522652aa14c60434d21d2d16d37cf665b25031745505d4a",
        x"00800629c14379cf936cd31b9f5b1d176d4b55eb4bc0fa2c923900000000000000000000ea7ce3b2ff77392438b5328d6c53eb8c90fc74accee99e33080715b3474940387637cf665b2503178c58df66",
        x"006000268138f1b23ce293b438ce2f6ba73658fbddef5607ce3e01000000000000000000468b267b782a9bf25b419bf3035cb177a98c75dd0b961bce3036e822d0fa0ce88337cf665b250317b0f11b99",
    ];
    // finality = 4 => first block is finalized.
    new_light_client(params::mainnet(), start_block, headers, 0, 4, ctx)
}

#[test_only]
// a sample valid (height, tx_id, proof, tx_index)
fun sample_data(): (u64, vector<u8>, vector<vector<u8>>, u64) {
    let height = 858816;
    let tx_id = x"a1a81fcc85f94d84a7920aadf456c64a93ffab20dba7066124ba9bd7ef2b262a";
    let tx_index = 99;
    let proof = vector[
        x"3226b3fd4e459a18d8e354750ba7802721076ec2b9a0b62704a79362a46d969c",
        x"9f2d6dd28be8e5c90c2c17f23092c0a8837df337cebdead83f0ddee9f18c3bd6",
        x"37270251d5a59dc9e05605918ab701f5bd7a71b11959fd174e28481ec44ef6a2",
        x"6bf0dde760447a1814bdbefc775f1f2a9b1e2b365bf613ac2ed4b1fdd289eeb2",
        x"9337e33010702f63e20f0c3c716ca8c63916d0befb127f6c4049957a3cd46ee8",
        x"338ea697010d9a11a429bc0e251a7c4a42fb15fb3a865933b7af5ea466e80721",
        x"e3c08f9e74e19eff184911eadfff9fdbb8ea871ec9fbc70bff6dcf37ff5777b3",
        x"78497599745687885b63c489f0a9ded6b31137d15e4538a90e1c8a1481d00c53",
        x"ba162237f4c523b95b934b4964ec2906bd75820b6711308f7df7fdb51ad09372",
        x"9637f4b6c63fbdfcb3712f9f784f2e033f429494cb2a78e29c1b62e88c12bb04",
        x"d1bbfbb89045d883e42fe650f698f622219d570f260e8d2880c1597e226448ce",
        x"7e118f94a37ab7cdafd637c61d4eb6c9ade81cdbcd31d1d68d25e2118b712853",
    ];

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
    let tx_id = x"010203";
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    let (height, tx_id, _, tx_index) = sample_data();
    let proof = vector[];
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    let (_, tx_id, proof, tx_index) = sample_data();
    let height = 858817; // this block not finalize yet.
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert_eq!(res, false);

    sui::test_utils::destroy(lc);
    scenario.end();
}
