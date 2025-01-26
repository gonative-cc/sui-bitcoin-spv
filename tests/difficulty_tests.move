#[test_only]
module bitcoin_spv::difficulty_test;

use bitcoin_spv::bitcoin_spv::{mainnet_params, new_lc};
use bitcoin_spv::light_block::{new_light_block};
use bitcoin_spv::difficulty::{calc_next_block_difficulty};
use sui::dynamic_object_field as dof;
use sui::test_scenario;


#[test]
fun difficulty_computation_tests() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    
    let p = mainnet_params();
    let mut lc = new_lc(p, scenario.ctx());

    
    let first_block = new_light_block(
	860831u256,
	x"0040a320aa52a8971f61e56bf5a45117e3e224eabfef9237cb9a0100000000000000000060a9a5edd4e39b70ee803e3d22673799ae6ec733ea7549442324f9e3a790e4e4b806e1662000ffff807427ca",
	scenario.ctx()
    );

    dof::add(lc.client_id_mut(), 860831u256, first_block);
    
    let last_block = new_light_block(
	858816u256,
	x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
	scenario.ctx()
    );

    let last_block_bits = last_block.header().bits();
    
    dof::add(lc.client_id_mut(), 858816u256, last_block);
    
    let new_bits = calc_next_block_difficulty(&lc, dof::borrow(lc.client_id(), 860831u256), 0);

    std::debug::print(&last_block_bits);
    std::debug::print(&new_bits);
    assert!(new_bits == last_block_bits);
    sui::test_utils::destroy(lc);
    scenario.end();
}
