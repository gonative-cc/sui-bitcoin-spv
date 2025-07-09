// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::verify_payment_tests {
    use bitcoin_spv::{light_client::{new_light_client, ETxNotInBlock}, params};
    use btc_parser::{reader, tx};
    use std::unit_test::assert_eq;
    use sui::test_scenario;

    #[test]
    fun verify_payment_happy_cases() {
        let sender = @0x01;
        let mut scenario = test_scenario::begin(sender);
        let start_block_height = 325001;
        let headers = vector[
            x"020000005d42717a33dd7046b6ca5fa33f14a7318b8221ce5b6909040000000000000000d7ee3bfa38399e87f302a41b388f33df29bf3ecb3552ed208a4869e17870a74d5c843a5473691f184c13685d",
            x"02000000467aa6383f1aad95ed5c4eee2dc10a97ebb1f79760446a0000000000000000004586bab85aa954c20675b8603c2bc68b53a3da5b0d25a8a03dc3a274ab8c981409863a5473691f186b9c6345",
            x"020000002e4fd5261bc0c9e663d32f4bbbb3253e3a8f8e5759f7ae070000000000000000046c024dcdabcc5f3071d8f44e030dba6b9ae7e30336523be2a767c68b0e3ba684863a5473691f180220726b",
            x"02000000ae4bcf449c0e9ea803a663bb09c45f221b62b206353e1e0f000000000000000010638f6182860aa213236fbce7bafc9b68a6f8826d3f05482c4e8cd7465ec9824c8c3a5473691f185c90957a",
            x"02000000c331af5f49fd96014b398d9541b4d252a8a4235c2797d90b00000000000000003ac10882c715806ec7b557b9de9fd786c0380718335e2ae2c1fbee9fb1465aa03b8c3a5473691f187cd8568e",
        ];

        let ctx = scenario.ctx();
        let finality = 4; // => the block 325001 is finally in this case
        let lc = new_light_client(
            params::mainnet(),
            start_block_height,
            headers,
            0,
            finality,
            ctx,
        );

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
            x"2e7ed7831d341177f75647c7ce999efede045099c396c18be790b0d1a5ae83cb",
        ];

        let tx_index = 604;
        let mut r = reader::new(
            x"01000000018c0bfefccb5755874ea0872a17b0d682c84981eed93fccd3ef86556f51f21522010000006a47304402204bbbefdc49e7289b0f36fe8c7623e93ff7ff751664d63caf49c1d9d8a4cbefd402200582f12a9490bdf8e6980025c08f83c43c50bc472706e3a38e7f1a972404bc4d0121035533036f3a7e9dc4c76e9d3697eb9d573aa76844baaadda347893a793797b639ffffffff0410270000000000001976a914303962c3ad29f08d13d98218ceeb7057e9bc184888ac10270000000000001976a914c6a3b95415d3fe9a9161c4b5100c1b6f2ad1e90c88ac00000000000000000d6a0b68656c6c6f20776f726c64e5490600000000001976a914e6228f7a5ee6b15c7cccfd9f9cb7e8699261084588ac00000000",
        );
        let transaction = tx::deserialize(&mut r);

        // Tx: 6dfb16dd580698242bcfd8e433d557ed8c642272a368894de27292a8844a4e75 (Height 303,699)
        // from mainnet
        let (amount, message, tx_id) = lc.verify_payment(
            start_block_height,
            proof,
            tx_index,
            &transaction,
            x"e6228f7a5ee6b15c7cccfd9f9cb7e86992610845",
        );

        assert_eq!(tx_id, x"754e4a84a89272e24d8968a37222648ced57d533e4d8cf2b24980658dd16fb6d");
        assert_eq!(amount, 412133);
        assert_eq!(message, x"68656c6c6f20776f726c64");
        sui::test_utils::destroy(lc);
        scenario.end();
    }

    #[test]
    fun verify_payment_with_P2WPHK_output_happy_cases() {
        let sender = @0x01;
        let mut scenario = test_scenario::begin(sender);
        let start_block_height = 0;
        let headers = vector[
            // only one transaction
            x"020000005d42717a33dd7046b6ca5fa33f14a7318b8221ce5b6909040000000000000000df88e4ad22477438db0a80979cf3dea033aa968c97fe06270f8864941a30649b5c843a5473691f184c13685d",
        ];

        let ctx = scenario.ctx();
        let finality = 0;
        let lc = new_light_client(
            params::regtest(),
            start_block_height,
            headers,
            0,
            finality,
            ctx,
        );

        // empty because only one transaction
        let proof = vector[];

        let tx_index = 604;

        let mut r = reader::new(
            x"01000000018c0bfefccb5755874ea0872a17b0d682c84981eed93fccd3ef86556f51f21522010000006a47304402204bbbefdc49e7289b0f36fe8c7623e93ff7ff751664d63caf49c1d9d8a4cbefd402200582f12a9490bdf8e6980025c08f83c43c50bc472706e3a38e7f1a972404bc4d0121035533036f3a7e9dc4c76e9d3697eb9d573aa76844baaadda347893a793797b639ffffffff0410270000000000001976a914303962c3ad29f08d13d98218ceeb7057e9bc184888ac10270000000000001976a914c6a3b95415d3fe9a9161c4b5100c1b6f2ad1e90c88ac00000000000000000d6a0b68656c6c6f20776f726c64e549060000000000160014e6228f7a5ee6b15c7cccfd9f9cb7e8699261084500000000",
        );
        let transaction = tx::deserialize(&mut r);

        let (amount, message, tx_id) = lc.verify_payment(
            start_block_height,
            proof,
            tx_index,
            &transaction,
            x"e6228f7a5ee6b15c7cccfd9f9cb7e86992610845",
        );

        assert_eq!(tx_id, x"df88e4ad22477438db0a80979cf3dea033aa968c97fe06270f8864941a30649b");
        assert_eq!(amount, 412133);
        assert_eq!(message, x"68656c6c6f20776f726c64");
        sui::test_utils::destroy(lc);
        scenario.end();
    }

    #[test, expected_failure(abort_code = ETxNotInBlock)]
    fun verify_payment_for_tx_not_in_block_shoul_fail() {
        let sender = @0x01;
        let mut scenario = test_scenario::begin(sender);
        let start_block_height = 325001;
        let headers = vector[
            x"020000005d42717a33dd7046b6ca5fa33f14a7318b8221ce5b6909040000000000000000d7ee3bfa38399e87f302a41b388f33df29bf3ecb3552ed208a4869e17870a74d5c843a5473691f184c13685d",
        ];
        let ctx = scenario.ctx();
        let lc = new_light_client(params::mainnet(), start_block_height, headers, 0, 8, ctx);

        // merkle proof of transaction id gen by proof.py in scripts folder.
        // we modify proof to make this invalid.
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
            x"2e7ed7831d341177f75647c7ce999efede045099c396c18be790b0d1a5aeffff", // <-- modified here, 83cb => ffff
        ];

        let tx_index = 604;

        let mut r = reader::new(
            x"0100000001c08ce0edcedc47becf03f923479bec4c184cda060452959f59d47ae8923da032010000006b483045022100cfdcc3fc354c8d2bbf22d708723e1c3836629c0ed6ef9485004d674ca06e0c6102204dee8d1180a309d22aa66e83554d992b751298208bc1b1e0d60f74fe834634330121036b4468fc9f4dc283365c70f7989b944586a260fca5358a91dfc50bf13c071b1effffffff0220a10700000000001976a9140fef69f3ac0d9d0473a318ae508875ad0eae3dcc88acc8ec7100000000001976a91451e6b602f387b4c5bb8a4d8cdf1b059c826374e388ac00000000",
        );
        let transaction = tx::deserialize(&mut r);
        // Tx: dc7ed74b93823c33544436cda1ea66761d708aafe08b80cd69c4f42d049a703c (Height 303,699)
        // from mainnet
        // should return error
        lc.verify_payment(
            start_block_height,
            proof,
            tx_index,
            &transaction,
            x"e6228f7a5ee6b15c7cccfd9f9cb7e86992610845",
        );

        sui::test_utils::destroy(lc);
        scenario.end();
    }

    #[test, expected_failure(abort_code = ETxNotInBlock)]
    fun verify_payment_on_block_not_finalize_should_fail() {
        let sender = @0x01;
        let mut scenario = test_scenario::begin(sender);
        let start_block_height = 325001;
        let headers = vector[
            x"020000005d42717a33dd7046b6ca5fa33f14a7318b8221ce5b6909040000000000000000d7ee3bfa38399e87f302a41b388f33df29bf3ecb3552ed208a4869e17870a74d5c843a5473691f184c13685d",
        ];
        let ctx = scenario.ctx();
        let lc = new_light_client(params::mainnet(), start_block_height, headers, 0, 8, ctx);

        // merkle proof of transaction id gen by proof.py in scripts folder.
        // we modify proof to make this invalid.
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
            x"2e7ed7831d341177f75647c7ce999efede045099c396c18be790b0d1a5ae83cb", // <-- modified here, 83cb => ffff
        ];

        let tx_index = 604;
        let mut r = reader::new(
            x"0100000001c08ce0edcedc47becf03f923479bec4c184cda060452959f59d47ae8923da032010000006b483045022100cfdcc3fc354c8d2bbf22d708723e1c3836629c0ed6ef9485004d674ca06e0c6102204dee8d1180a309d22aa66e83554d992b751298208bc1b1e0d60f74fe834634330121036b4468fc9f4dc283365c70f7989b944586a260fca5358a91dfc50bf13c071b1effffffff0220a10700000000001976a9140fef69f3ac0d9d0473a318ae508875ad0eae3dcc88acc8ec7100000000001976a91451e6b602f387b4c5bb8a4d8cdf1b059c826374e388ac00000000",
        );
        let transaction = tx::deserialize(&mut r);

        // Tx: dc7ed74b93823c33544436cda1ea66761d708aafe08b80cd69c4f42d049a703c (Height 303,699)
        // from mainnet
        // should return error
        lc.verify_payment(
            start_block_height,
            proof,
            tx_index,
            &transaction,
            x"e6228f7a5ee6b15c7cccfd9f9cb7e86992610845",
        );

        sui::test_utils::destroy(lc);
        scenario.end();
    }
}
