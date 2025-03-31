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
fun testnet_exception_1(ctx: &mut TxContext): LightClient {
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
fun test_insert_header_testnet_exception1() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = testnet_exception_1(ctx);

    let raw_headers = vector[
        x"010000009cf5f976b9ae634b4c867bf78cb602bee8150ea1838d0ef3d06ce94700000000fe6ce75c462d7d09aa8d917fa90a49bd6a4c41f02457ff40ca47ded089021042b0c84a4dffff001d03a5f6aa",
    ];
    lc.insert_headers(raw_headers);
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test_only]
fun testnet_exception_2(ctx: &mut TxContext): LightClient {
    let start_block = 0;
    let headers = vector[
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4adae5494dffff001d1aa4ae18",
        x"0100000043497fd7f826957108f4a30fd9cec3aeba79972084e90ead01ea330900000000bac8b0fa927c0ac8234287e33c5f74d38d354820e24756ad709d7038fc5f31f020e7494dffff001d03e4b672",
        x"0100000006128e87be8b1b4dea47a7247d5528d2702c96826c7a648497e773b800000000e241352e3bec0a95a6217e10c3abb54adfa05abb12c126695595580fb92e222032e7494dffff001d00d23534",
        x"0100000020782a005255b657696ea057d5b98f34defcf75196f64f6eeac8026c0000000041ba5afc532aae03151b8aa87b65e1594f97504a768e010c98c0add79216247186e7494dffff001d058dc2b6",
        x"0100000010befdc16d281e40ecec65b7c9976ddc8fd9bc9752da5827276e898b000000004c976d5776dda2da30d96ee810cd97d23ba852414990d64c4c720f977e651f2daae7494dffff001d02a97640",
        x"01000000dde5b648f594fdd2ec1c4083762dd13b197bb1381e74b1fff90a5d8b00000000b3c6c6c1118c3b6abaa17c5aa74ee279089ad34dc3cec3640522737541cb016818e8494dffff001d02da84c0",
        x"01000000a1213bd4754a6606444b97b5e8c46e9b7832773ff434bd5f87ac45bc00000000d1e7026986a9cd247b5b85a3f30ecbabb6d61840d0abb81f905c411d5fc145e831e8494dffff001d004138f9",
        x"010000007b0a09f26fdde2c432167d8349681c7801d0128f4dfae4dc5e68336600000000c1d71f59ce4419c793eb829380a41dc1ad48c19fcb0083b8f67094d5cae263ad81e8494dffff001d004ddad5",
        x"01000000a62bc0c08afc1d12e6c6a7eb4a464c848190ac0e44123d5fa63a9ee2000000000214335cde9edeb6aa0195f68c08e5e46b07043e24aeff51fd9a3ff992ce6976a0e8494dffff001d02f33927",
        x"01000000f9e2142a93185496f7b21314d8b6fa736d0a30fa3a6d339ab3a1ba9c0000000061974472615d348df6de106dbaaa08cf4dec65e39cefc62af6097b967b9bea52fde8494dffff001d00ca48a2",
        x"010000001e93aa99c8ff9749037d74a2207f299502fa81d56a4ea2ad5330ff50000000002ec2266c3249ce2e079059e0aec01a2d8d8306a468ad3f18f06051f2c3b1645435e9494dffff001d008918cf",
    ];
    let lc = new_light_client_with_params_int(params::testnet(), start_block, headers, 0, 8, ctx);
    return lc
}

#[test]
fun test_insert_header_testnet_exception2() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = testnet_exception_2(ctx);

    let raw_headers = vector[
        x"010000002e9afd58b91f15c3ec9eb0f01ed9d503134da1918b6bb416a9920e700000000029fb495afdb58f3a26d1c90fafec93aed840e2fa37ad6173ba1e7fadb7121ee57de9494dffff001d02e7f318",
    ];
    lc.insert_headers(raw_headers);
    sui::test_utils::destroy(lc);
    scenario.end();
}

#[test_only]
fun testnet_exception_3(ctx: &mut TxContext): LightClient {
    let start_block = 489;
    let headers = vector[
        x"01000000e6c388d72c717914e507f11c58a139137fd483dbd746e9c5f2a1eb0f00000000afa8dd6f0e319d4ddedfa1425f6c03e461dfa005d42d3f355a04cae42626c9b121c64a4dffff001d059f05b2",
        x"010000001b354bd6d10f5a24879851bb2aff42548cb66cebda04e7103bc2521900000000622c689b318941bef087640fddab2c5ef6dd6024f133ac28c1ccfaf30e380bfa4dc64a4dffff001d00484506",
        x"010000003e226e00e126f0a4a35b1c6c09509e0d999122428262a5303e563c6000000000d7432b21fd48689d7e79f9b6f7f624aefe8b72503fca13b814d355618b9023cf23c74a4dffff001d0247f874",
        x"01000000fbb3060018eb1f40d734cc64744134d96536c4a331e00d4c05e2cf9b0000000061b34d561ddfd18ea3381d48a8bbe4627727c6ead00a84030e7f76eeb788148a71c74a4dffff001d012e783d",
        x"01000000fff008ec46c2d35cf469eded16dfadc77ca6e9a9680cea0b0611661b000000001d1e1087d20d41da1f0b4a5423aeb281ecd48cfc434feb45a4c6c31b6b61398124c84a4dffff001d05928767",
        x"0100000093ebaafdaac804feef3ec352e40cc78be60e7ef1edb167891ccd99cc000000006bf225e961b1f1b8e042c45966c2118f20871551e0996eaf51bb628cd9d49b7a45c84a4dffff001d00381daf",
        x"01000000e85fb976eb4817418c0ed2987dba1674c0fd757f70b470f83d01a2d300000000fd6717e5d49bf303d41d861fc50503aa8575eb52243f426de308869a8cd57c57f5c74a4dffff001d033a590f",
        x"010000009cf5f976b9ae634b4c867bf78cb602bee8150ea1838d0ef3d06ce94700000000fe6ce75c462d7d09aa8d917fa90a49bd6a4c41f02457ff40ca47ded089021042b0c84a4dffff001d03a5f6aa",
        x"010000002eff16b6669f88de6f40810c57349804014f734c692a44ee822b7f1200000000c095ce4ab7e0e02110b75a33012da97d75e26b83de5ae0bd392fc3b8191b77e8e8c84a4dffff001d032c2bf6",
        x"0100000001aa2c494f2d4b7ecf367734c734b931d3592b1572dcff557186ece700000000a10e60b120c06cd1be1d2153abb7901e2d9f1a3f43de9e6642ad269be1cae22e44c94a4dffff001d01f2005b",
        x"010000003d04e058642d22428704ad4337f372bb8574cae072c2a4b469b2e1dd00000000bff07e723c3859fe85bb849d860b21a325b1baf1494a3c1e73435dd7992bf8e53dc94a4dffff001d00262757",
    ];
    let lc = new_light_client_with_params_int(params::testnet(), start_block, headers, 0, 8, ctx);
    return lc
}

#[test]
fun test_insert_header_testnet_exception3() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);

    let ctx = scenario.ctx();
    let mut lc = testnet_exception_3(ctx);

    let raw_headers = vector[
        x"01000000272ecd270665dc39e924838516da62f8588270f1e37812aabdb1d48c000000001725d4769aaca3cf86c5b0dd199bf93f2d16dbb13fbd4029633bdd1085283fdd13c94a4dffff001d02f79a8a",
    ];
    lc.insert_headers(raw_headers);
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
