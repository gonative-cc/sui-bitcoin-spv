
#[test_only]
module bitcoin_spv::bitcoin_spv_tests;

use bitcoin_spv::bitcoin_spv::{insert_header, new_light_client, mainnet_params, LightClient, EBlockHashNotMatch, EDifficultyNotMatch};
use bitcoin_spv::light_block::new_light_block;
use bitcoin_spv::block_header::new_block_header;

use sui::test_scenario;

#[test_only]
fun new_lc_for_test(ctx: &mut TxContext) : LightClient {
    let p = mainnet_params();
    let mut lc = new_light_client(p, ctx);
    let first_block = new_light_block(
	    858816u256,
	    x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
	     ctx
     );

    lc.add_light_block(first_block);
    return lc
}

#[test]
fun test_set_get_block_happy_case() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let ctx = scenario.ctx();
    let lc = new_lc_for_test(ctx);
    let header = new_block_header(x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a");
    assert!(lc.latest_finalized_height() ==   858816);
    assert!(lc.latest_finalized_block().header().block_hash() == header.block_hash());

    sui::test_utils::destroy(lc);
    scenario.end();
}


#[test]
#[expected_failure]
fun test_set_get_block_failed_case() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let ctx = scenario.ctx();
    let lc = new_lc_for_test(ctx);

    lc.light_block_at_height(0);

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
fun test_insert_header_happy_cases() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = new_lc_for_test(ctx);

    let raw_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    lc.insert_header(raw_header, ctx);

    let latest_height = lc.latest_finalized_height();

    assert!(lc.light_block_at_height(latest_height).header() == new_block_header(raw_header));
    let last_block = new_light_block(
	    860831u256,
	    x"0040a320aa52a8971f61e56bf5a45117e3e224eabfef9237cb9a0100000000000000000060a9a5edd4e39b70ee803e3d22673799ae6ec733ea7549442324f9e3a790e4e4b806e1665b250317807427ca",
	    ctx
    );

    let latest_height = lc.latest_finalized_height();

    lc.add_light_block(last_block);

    let new_header = x"006089239c7c45da6d872c93dc9e8389d52b04bdd0a824eb308002000000000000000000fb4c3ac894ebc99c7a7b76ded35ec1c719907320ab781689ba1dedca40c5a9d7c50de1668c09031716c80c0d";
    lc.insert_header(new_header, ctx);
    assert!(lc.light_block_at_height(latest_height).header() == new_block_header(raw_header));

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EBlockHashNotMatch)] // ENotFound is a constant defined in the module
fun test_insert_header_failed_block_hash_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());
    let ctx = scenario.ctx();

    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000001530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    lc.insert_header(new_header, ctx);

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EDifficultyNotMatch)] // ENotFound is a constant defined in the module
fun test_insert_header_failed_difficulty_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());
    let ctx = scenario.ctx();

    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031880f1e351";
    lc.insert_header(new_header, ctx);
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test_only]
// returns a sample valid (height, tx_id, proof, tx_index)
fun sample_data(): (u256, vector<u8>, vector<vector<u8>>, u256) {
    let height = 858816u256;
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
        x"7e118f94a37ab7cdafd637c61d4eb6c9ade81cdbcd31d1d68d25e2118b712853"
    ];

    return (
        height, tx_id, proof, tx_index
    )
}

#[test]
fun test_verify_tx() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let lc = new_lc_for_test(scenario.ctx());

    let (height, tx_id, proof, tx_index) = verify_tx_test_data();
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert!(res == true);

    let (height, tx_id, proof, _) = verify_tx_test_data();
    let tx_index = 100;
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert!(res == false);

    let (height, _, proof, tx_index) = verify_tx_test_data();
    let tx_id = x"010203";
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert!(res == false);


    let (height, tx_id, _, tx_index) = verify_tx_test_data();
    let proof = vector[];
    let res = lc.verify_tx(height, tx_id, proof, tx_index);
    assert!(res == false);

    sui::test_utils::destroy(lc);
    scenario.end();
}
