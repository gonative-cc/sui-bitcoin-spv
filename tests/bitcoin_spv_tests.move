
#[test_only]
module bitcoin_spv::bitcoin_spv_tests;

use bitcoin_spv::bitcoin_spv::{insert_header, new_light_client, mainnet_params};
use bitcoin_spv::light_block::new_light_block;

use sui::test_scenario;

#[test]
fun test_insert_header_happy_case() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let p = mainnet_params();
    let mut lc = new_light_client(p, scenario.ctx());

    let first_block = new_light_block(
	    858816u256,
	    x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
	    scenario.ctx()
    );

    lc.add_light_block(first_block);

    let new_header = x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    lc.insert_header(new_header);

    sui::test_utils::destroy(lc);
    scenario.end();
}
