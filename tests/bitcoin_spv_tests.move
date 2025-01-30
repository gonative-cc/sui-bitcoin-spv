
#[test_only]
module bitcoin_spv::bitcoin_spv_tests;

use bitcoin_spv::bitcoin_spv::{insert_header, new_light_client, mainnet_params, LightClient, EBlockHashNotMatch, EDifficultyNotMatch};
use bitcoin_spv::light_block::new_light_block;

use sui::test_scenario;

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
fun test_insert_header_happy_cases() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let mut lc = new_lc_for_test(scenario.ctx());

    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    lc.insert_header(new_header);

    let last_block = new_light_block(
	    860831u256,
	    x"0040a320aa52a8971f61e56bf5a45117e3e224eabfef9237cb9a0100000000000000000060a9a5edd4e39b70ee803e3d22673799ae6ec733ea7549442324f9e3a790e4e4b806e1665b250317807427ca",
	    scenario.ctx()
    );

    lc.add_light_block(last_block);

    let new_header = x"006089239c7c45da6d872c93dc9e8389d52b04bdd0a824eb308002000000000000000000fb4c3ac894ebc99c7a7b76ded35ec1c719907320ab781689ba1dedca40c5a9d7c50de1668c09031716c80c0d";
    lc.insert_header(new_header);
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EBlockHashNotMatch)] // ENotFound is a constant defined in the module
fun test_insert_header_failed_block_hash_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());

    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000001530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    lc.insert_header(new_header);

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EDifficultyNotMatch)] // ENotFound is a constant defined in the module
fun test_insert_header_failed_difficulty_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());

    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031880f1e351";
    lc.insert_header(new_header);

    sui::test_utils::destroy(lc);
    scenario.end();
}
