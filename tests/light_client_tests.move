#[test_only]
module bitcoin_spv::light_client_tests;

use bitcoin_spv::block_header::new_block_header;
use bitcoin_spv::light_block::new_light_block;
use bitcoin_spv::light_client::{
    insert_header,
    new_light_client_with_params_int,
    new_light_client_with_params,
    LightClient,
    EWrongParentBlock,
    EDifficultyNotMatch,
    ETimeTooOld,
    EInvalidStartHeight
};
use bitcoin_spv::params;
use sui::test_scenario;

#[test_only]
fun new_lc_for_test(ctx: &mut TxContext): LightClient {
    let start_block = 858806;
    let headers = vector[
        x"00a0b434e99097082da749068bd8cc81f7ddd017f3153e1f25b000000000000000000000fbef99870f826601fed79703773deb9122f03b5167c0b7554c00112f9fa99e171320cf66763d03175c560dcc",
        x"00205223ce8791e22d0a1b64cfb0b485af2ddba566cb54292e0c030000000000000000003f5d648740a3a0519c56fce7f230d4c35aa83c9df0478b77be3fc89f0acfb8cc9524cf66763d03171746f213",
        x"0000c72367c8c7e8515c552d74707468a84d2fda2da63d65cbec01000000000000000000ec9d236ac946e604e3272ab775a501ebe05e8b06a8ec70b8c51b7ccba38af21b1c26cf66763d0317c3442435",
        x"00c057251d6ff0cb1d8eb9452f6578fafd41c5435dbfae6dbd5a01000000000000000000a8c4158d905a4fd766328c4717222737d4105220ee3aae80fbe57928689a7544cb27cf66763d0317a29c9617",
        x"00800a2088931286b1c6af1e23730089387def8a89e248de2a6501000000000000000000a6d9635ee5e71023ee76c5569e770d432302593757a0e2e343f083764cd8f3155328cf66763d03175a15982c",
        x"00a06b23d73ad1793c6b81cb331b00023a1c84611ae6fe46b08f00000000000000000000dd4c22396df46efc796ebbdfd82cb74d4c3eaf5e8e18134b7fda9379e82ebd2a752bcf66763d031766c189d5",
        x"00e06c2e314994230081f451d0fba9016cea4be4afd3b4c20d46010000000000000000006e110e2bc3bb80af0fa41dada4829fe5bc8a7a6269b588fff5f708d551130d649d2bcf66763d0317c530dcc8",
        x"00000028f1b88a82b706583e794319f23feb40ef6d9b42ee9817020000000000000000003a899be6d63b05795d9b5da4d091fb9e37a5bf4783faaf1ae9e8aafa861462e7682dcf66763d0317844b2ed2",
        x"00007f300670de9a5071f41ff3efdfede97d98b9044d71d77dd700000000000000000000835f42b3d177c5d7b5b844efa4a6ac682bacc4d2862169ee8607da3ec5f4ef3ab32dcf66763d031759921deb",
        x"00800120451bed6d330bd942a708b0858fdbb7d265e5b7caa3c00000000000000000000025ba876f2efbd1522e36a7cd807879eeec843f95da8a01993556100e3226900b8d30cf66763d0317bd91acc5",
        x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
    ];
    let lc = new_light_client_with_params_int(params::mainnet(), start_block, headers, 0, 8, ctx);
    return lc
}

#[test_only]
fun new_lc_for_test_trusted_headers(
    ctx: &mut TxContext,
    trusted_headers: vector<vector<u8>>,
    start_height: u64,
): LightClient {
    let lc = new_light_client_with_params_int(
        params::testnet(),
        start_height,
        trusted_headers,
        0,
        8,
        ctx,
    );
    return lc
}

#[test]
#[expected_failure(abort_code = EInvalidStartHeight)]
fun test_new_light_client_with_params_wrong_start_height() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let ctx = scenario.ctx();
    let headers = vector[
        x"00a0b434e99097082da749068bd8cc81f7ddd017f3153e1f25b000000000000000000000fbef99870f826601fed79703773deb9122f03b5167c0b7554c00112f9fa99e171320cf66763d03175c560dcc",
        x"00205223ce8791e22d0a1b64cfb0b485af2ddba566cb54292e0c030000000000000000003f5d648740a3a0519c56fce7f230d4c35aa83c9df0478b77be3fc89f0acfb8cc9524cf66763d03171746f213",
    ];
    new_light_client_with_params(params::mainnet(), 2, headers, 8, ctx);
    scenario.end();
}

#[test]
fun test_new_light_client_with_params() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let ctx = scenario.ctx();
    let headers = vector[
        x"00a0b434e99097082da749068bd8cc81f7ddd017f3153e1f25b000000000000000000000fbef99870f826601fed79703773deb9122f03b5167c0b7554c00112f9fa99e171320cf66763d03175c560dcc",
        x"00205223ce8791e22d0a1b64cfb0b485af2ddba566cb54292e0c030000000000000000003f5d648740a3a0519c56fce7f230d4c35aa83c9df0478b77be3fc89f0acfb8cc9524cf66763d03171746f213",
    ];
    new_light_client_with_params(params::mainnet(), 2016, headers, 8, ctx);
    scenario.end();
}

#[test]
fun test_set_get_block_happy_case() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let ctx = scenario.ctx();
    let lc = new_lc_for_test(ctx);
    let header = new_block_header(
        x"0060b0329fd61df7a284ba2f7debbfaef9c5152271ef8165037300000000000000000000562139850fcfc2eb3204b1e790005aaba44e63a2633252fdbced58d2a9a87e2cdb34cf665b250317245ddc6a",
    );
    assert!(lc.head_height() == 858816);
    assert!(lc.head().header().block_hash() == header.block_hash());
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

    lc.get_light_block_by_hash(x"011011");

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
fun test_insert_header_happy_cases() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = new_lc_for_test(ctx);

    let raw_headers = vector[
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351",
    ];
    lc.insert_headers(raw_headers);
    let head_block = lc.get_light_block_by_hash(lc.head_hash()).header();

    assert!(head_block == new_block_header(raw_headers[0]));
    assert!(head_block == lc.head().header());

    let last_block_header = new_block_header(
        x"0040a320aa52a8971f61e56bf5a45117e3e224eabfef9237cb9a0100000000000000000060a9a5edd4e39b70ee803e3d22673799ae6ec733ea7549442324f9e3a790e4e4b806e1665b250317807427ca",
    );
    let last_block = new_light_block(
        860831,
        last_block_header,
        0,
    );

    lc.append_block(last_block);
    let headers = vector[
        x"006089239c7c45da6d872c93dc9e8389d52b04bdd0a824eb308002000000000000000000fb4c3ac894ebc99c7a7b76ded35ec1c719907320ab781689ba1dedca40c5a9d7c50de1668c09031716c80c0d",
    ];

    lc.insert_headers(headers);
    assert!(lc.head().header() == new_block_header(headers[0]));
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
fun test_insert_header_testnet_exception_2007936() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();

    let headers = vector[
        x"0000002095a31b36c687f82dd9056451faebbc11c84d7ce3d3606f4a1000000000000000dd26ab631e10b32c602a20ffd2f5ef16cfafe1b5a0d05a7fcac86e98b6cefd187782e660ffff001d35606edc",
        x"0000c020c8504100f5e206a1691a1e08be25baef8659184b1d08282bcc04daa1000000008f6fa2cc23d840525fab94a484b4b338d3e6c207735048f9cb484617b30f0ca73f83e66031524b191942e7b6",
        x"0000c020c75651cea771c61503b96246d0e35c845a2557e7204783ab2e0000000000000070f2576583c899da39086405e44949fdd26bf676dd74054582d1ea33883bb45e6583e66031524b198da2e8c3",
        x"0000202080c02cc43e057862dbda8dff23e322b83711e7842420938425000000000000002c5672e01557414e0962576508050f4eb0f4d581f63cd56abc625ce8b1e83d05ab85e66031524b196b7883ea",
        x"00000020e6e51f36b60069390f7f832beaa5c9cbc12cf93f5e5916612f000000000000006b3c51aa6d2fd1bebbf7f51b687bef924c695932bb261c6c61a8735b699e619f728ae660ffff001d96329a13",
        x"00000020db6db069e32fab69fa93dda9d242f9e4baecfdd009aaaf8f98b6623800000000d3e915876fe16d063c0278f26943560de27870c7c66f1f45df621d8334d9660f468fe660ffff001deea71875",
        x"00000020f7e58b60c891a46066f4f0ba74f379286f36c54e98ec38e1bce366e00000000035a8194862f1c76499eaf665df54d34a2684f8d24619a4ba7b2a5065b4e9bf5d1290e66031524b1986d56ebe",
        x"0000402017d6493b941d517fae4265404b30c8fce67064f64f21c1f90c00000000000000cfcae4915e96c9d8151bda3c7e507c84856ec6f710aa2e66000df2a2f747fc6ca790e66031524b19453b9624",
        x"00008020a84139188ac94374d6cb9b076f46acfe2543a05909e73e58310000000000000004e66a2fcce7a3a964cd31d5ce978486bbf84f5773d99f95bc0024d5bcccbbfb8e91e66031524b19693bc4c9",
        x"0000002025fb6784455f4ad12bc6bded758efb52265828ebc88bac904a000000000000006dfd5f97f9e2e70b0ff57fb97dbf5c1b8aa96b3a7118eceb538550009bae53a74896e660ffff001d9a4232f6",
        x"00000020a0104c1b74a56beeaf96594071f21605c8f218e2ce0b3409a71aa68200000000b6913d15445a5572e35dab23968af328d0f73e223d8b3ec3239a550564ae5b50009be660ffff001d9e5c4fdd",
    ];

    let mut lc = new_lc_for_test_trusted_headers(ctx, headers, 2007936);

    let raw_header_2007936 = vector[
        x"0000e020117b05968a89a9f98941f7c796f9ff5b7bf41c7126c6204549e22b9800000000cabe7de08abecf44b41ab6b04737fdc2689846c9faae9e36d89316a90461d9b6de9ae660ffff001d719b634c",
    ];
    lc.insert_headers(raw_header_2007936);
    let head_block = lc.get_light_block_by_hash(lc.head_hash()).header();
    sui::test_utils::destroy(lc);
    scenario.end();
}

// Test case: chain=[X, Y, Z], inserting [A, A], where A.parent()=Z. It should fail, because it
// doesn't create a chain, but a tree under node Z:
// X-Y-Z-A
//     \-A
#[test]
#[expected_failure(abort_code = EWrongParentBlock)]
fun test_insert_headers_that_dont_form_a_chain() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = new_lc_for_test(ctx);

    let h =
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351";
    let raw_headers = vector[h, h];
    lc.insert_headers(raw_headers);

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EWrongParentBlock)]
fun test_insert_header_failed_block_hash_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());
    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = new_block_header(
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000001530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031780f1e351",
    );
    let h = *lc.head();
    lc.insert_header(&h, new_header);

    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = EDifficultyNotMatch)]
fun test_insert_header_failed_difficulty_not_match() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());

    // we changed the block hash to make new header previous hash not match with last hash
    let new_header = new_block_header(
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f601c35cf665b25031880f1e351",
    );
    let h = *lc.head();
    lc.insert_header(&h, new_header);
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test]
#[expected_failure(abort_code = ETimeTooOld)]
fun test_insert_header_failed_timestamp_too_old() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let mut lc = new_lc_for_test(scenario.ctx());

    // we changed timestamp from 1c35cf66 to 0c35cf46
    let new_header = new_block_header(
        x"00801e31c24ae25304cbac7c3d3b076e241abb20ff2da1d3ddfc00000000000000000000530e6745eca48e937428b0f15669efdce807a071703ed5a4df0e85a3f6cc0f600c35cf465b25031780f1e351",
    );
    let h = *lc.head();
    lc.insert_header(&h, new_header);
    sui::test_utils::destroy(lc);
    scenario.end();
}
