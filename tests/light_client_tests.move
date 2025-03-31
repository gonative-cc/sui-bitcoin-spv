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
fun testnet_new_lc_for_test(ctx: &mut TxContext): LightClient {
    let start_block = 485;
    let headers = vector[
        x"0100000078eea9a9282653e1e213c716004ee3c5b7d323c37bdec7a64565831200000000ac37dfa5948ecb63e944a61eb0e83cbf7dff61cd61cf66d21f447d9a97bcbec123c44a4dffff001d05c7a466",
        x"010000006c0d72985fd57581d55754a3dc631a89e6e4e1edbad1696ec271d6c200000000c1d26e829e285126d03a1943bc46d72c7e68f7fe1855393079dcc6406328ebc53ac44a4dffff001d01ec1ff0",
        x"0100000060f628c70ffabdde8c265ff6aa1b49e0f42d250a0645ac0fa2963ffc0000000074f7d49e03dd5ccae2109db1e4ff11507238642d86fc771aaa999ae48b06f3d26fc44a4dffff001d044b6b47",
        x"01000000f2c8d522c94e93a8ff5d947c057e4125a4deb167e5eabed5dfb56736000000005127f86da79df2980cedb16ab9a4b167e6daeadcda0d645f83deb48a3dcc065eb8c44a4dffff001d0561c0ee",
        x"01000000e6c388d72c717914e507f11c58a139137fd483dbd746e9c5f2a1eb0f00000000afa8dd6f0e319d4ddedfa1425f6c03e461dfa005d42d3f355a04cae42626c9b121c64a4dffff001d059f05b2",
        x"010000001b354bd6d10f5a24879851bb2aff42548cb66cebda04e7103bc2521900000000622c689b318941bef087640fddab2c5ef6dd6024f133ac28c1ccfaf30e380bfa4dc64a4dffff001d00484506",
        x"010000003e226e00e126f0a4a35b1c6c09509e0d999122428262a5303e563c6000000000d7432b21fd48689d7e79f9b6f7f624aefe8b72503fca13b814d355618b9023cf23c74a4dffff001d0247f874",
        x"01000000fbb3060018eb1f40d734cc64744134d96536c4a331e00d4c05e2cf9b0000000061b34d561ddfd18ea3381d48a8bbe4627727c6ead00a84030e7f76eeb788148a71c74a4dffff001d012e783d",
        x"01000000fff008ec46c2d35cf469eded16dfadc77ca6e9a9680cea0b0611661b000000001d1e1087d20d41da1f0b4a5423aeb281ecd48cfc434feb45a4c6c31b6b61398124c84a4dffff001d05928767",
        x"0100000093ebaafdaac804feef3ec352e40cc78be60e7ef1edb167891ccd99cc000000006bf225e961b1f1b8e042c45966c2118f20871551e0996eaf51bb628cd9d49b7a45c84a4dffff001d00381daf",
        x"01000000e85fb976eb4817418c0ed2987dba1674c0fd757f70b470f83d01a2d300000000fd6717e5d49bf303d41d861fc50503aa8575eb52243f426de308869a8cd57c57f5c74a4dffff001d033a590f",
    ];
    let lc = new_light_client_with_params_int(params::testnet(), start_block, headers, 0, 8, ctx);
    return lc
}

#[test]
fun test_insert_header_testnet_exception() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = testnet_new_lc_for_test(ctx);

    let raw_headers = vector[
        x"010000009cf5f976b9ae634b4c867bf78cb602bee8150ea1838d0ef3d06ce94700000000fe6ce75c462d7d09aa8d917fa90a49bd6a4c41f02457ff40ca47ded089021042b0c84a4dffff001d03a5f6aa",
    ];
    lc.insert_headers(raw_headers);
    // let head_block = lc.get_light_block_by_hash(lc.head_hash()).header();

    // assert!(head_block == new_block_header(raw_headers[0]));
    // assert!(head_block == lc.head().header());

    // let last_block_header = new_block_header(
    //     x"0040a320aa52a8971f61e56bf5a45117e3e224eabfef9237cb9a0100000000000000000060a9a5edd4e39b70ee803e3d22673799ae6ec733ea7549442324f9e3a790e4e4b806e1665b250317807427ca",
    // );
    // let last_block = new_light_block(
    //     860831,
    //     last_block_header,
    //     0,
    // );

    // lc.append_block(last_block);
    // let headers = vector[
    //     x"006089239c7c45da6d872c93dc9e8389d52b04bdd0a824eb308002000000000000000000fb4c3ac894ebc99c7a7b76ded35ec1c719907320ab781689ba1dedca40c5a9d7c50de1668c09031716c80c0d",
    // ];

    // lc.insert_headers(headers);
    // assert!(lc.head().header() == new_block_header(headers[0]));
    sui::test_utils::destroy(lc);
    scenario.end();
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
