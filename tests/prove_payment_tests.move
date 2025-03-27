#[test_only]
module bitcoin_spv::prove_payment_tests;

use bitcoin_spv::params;
use bitcoin_spv::light_client::{new_light_client_with_params_int};
use bitcoin_spv::transaction::{make_transaction, parse_output};
use sui::test_scenario;


#[test]
fun prove_payment_test() {
    let sender = @0x01;
    let mut scenario = test_scenario::begin(sender);
    let start_block_height = 325001;
    let headers = vector[
        x"020000005d42717a33dd7046b6ca5fa33f14a7318b8221ce5b6909040000000000000000d7ee3bfa38399e87f302a41b388f33df29bf3ecb3552ed208a4869e17870a74d5c843a5473691f184c13685d"
    ];
    let ctx = scenario.ctx();
    let lc = new_light_client_with_params_int(params::mainnet(), start_block_height, headers, 0, 8, ctx);

    // merkle proof of transaction id gen by proof.py in scripts folder.
    let proof = vector[
        x"54b37ab185afd67209bd0788a11a82dfb161ecd76f366e5fa8130ab74e11a5a7",
        x"3e19ed90a5d77f57b8237905c32a0629c558ae371a7c05afc47955589226b478",
        x"8d05f8415375a5069054cc39912759a3d5059300cd98354f82f958f086e057aa",
        x"dbde00ca9c3695c40bf6d7f4abd929cf8f385422d8a6e92c046f04e16fdafef1",
        x"0872911bd9c77c528f448ab4b3dcf794ceaf925384c5b1b78ba48c035a10e3eb",
        x"3f335c1ed5bfee45640f9c32611fffe9070974419e0ed0c850533be9c30dc82b",
        x"4f8c12cf241447aeaabe794dee1dd9e7caee23a93ff33c33aa0c81fe2fc3b0b1",
        x"b95b666c9b6ae55cede0667f6de31430997eacdc264e9e50a0f93aef35d83104",
        x"6efa6c0e97e8d9cf95577e088f5bf27d0c5e08523944b15694b1e6681a323553",
        x"b88d2e3a29eb772ae27aec10f33e594c0a108db5d4cbb8ea6a383371cd2e346a",
        x"2e7ed7831d341177f75647c7ce999efede045099c396c18be790b0d1a5ae83cb"
    ];

    let tx_index = 604;

    let transaction = make_transaction(
        x"01000000",
        1,
        x"8c0bfefccb5755874ea0872a17b0d682c84981eed93fccd3ef86556f51f21522010000006a47304402204bbbefdc49e7289b0f36fe8c7623e93ff7ff751664d63caf49c1d9d8a4cbefd402200582f12a9490bdf8e6980025c08f83c43c50bc472706e3a38e7f1a972404bc4d0121035533036f3a7e9dc4c76e9d3697eb9d573aa76844baaadda347893a793797b639ffffffff",
        4,
        x"10270000000000001976a914303962c3ad29f08d13d98218ceeb7057e9bc184888ac10270000000000001976a914c6a3b95415d3fe9a9161c4b5100c1b6f2ad1e90c88ac00000000000000000d6a0b68656c6c6f20776f726c64e5490600000000001976a914e6228f7a5ee6b15c7cccfd9f9cb7e8699261084588ac",
        x"00000000"
    );
    // Tx: dc7ed74b93823c33544436cda1ea66761d708aafe08b80cd69c4f42d049a703c (Height 303,699)
    // from mainnet
    let (amount, message, tx_id) = lc.prove_payment(
        start_block_height,
        proof,
        tx_index,
        &transaction,
        x"e6228f7a5ee6b15c7cccfd9f9cb7e86992610845"
    );

    assert!(tx_id == x"754e4a84a89272e24d8968a37222648ced57d533e4d8cf2b24980658dd16fb6d");
    assert!(amount == 412133);
    assert!(message == x"68656c6c6f20776f726c64");
    sui::test_utils::destroy(lc);
    scenario.end();
}
