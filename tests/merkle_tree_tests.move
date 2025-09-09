// SPDX-License-Identifier: MPL-2.0
#[test_only]
module bitcoin_spv::merkle_tree_tests;

use bitcoin_spv::merkle_tree::{verify_merkle_proof, merkle_hash, EInvalidMerkleHashLengh};
use std::hash::sha2_256;
use std::unit_test::assert_eq;

fun single_hash(x: vector<u8>, y: vector<u8>): vector<u8> {
    let mut z = x;
    z.append(y);
    sha2_256(z)
}

fun reduce_double_hashes(v: vector<vector<u8>>): vector<vector<u8>> {
    let mut result = vector[];

    let mut i = 0;
    while (i < v.length() - 1) {
        result.push_back(merkle_hash(v[i], v[i + 1]));
        i = i + 2;
    };
    result
}

fun reduce_single_hashes(v: vector<vector<u8>>): vector<vector<u8>> {
    let mut result = vector[];

    let mut i = 0;
    while (i < v.length() - 1) {
        result.push_back(single_hash(v[i], v[i + 1]));
        i = i + 2;
    };
    result
}

fun create_proof_for_testing(
    single_hashes: vector<vector<u8>>,
    double_hashes: vector<vector<u8>>,
    tx_index: u64,
): vector<vector<u8>> {
    let mut index = tx_index;
    let mut proof = vector[];

    let mut preimage_hashes = single_hashes;
    let mut previous_level_hashes = double_hashes;
    while (previous_level_hashes.length() > 1) {
        if (index % 2 == 0) {
            if (index + 1 < previous_level_hashes.length()) {
                proof.push_back(preimage_hashes[index + 1]);
            } else {
                proof.push_back(preimage_hashes[index]);
            }
        } else {
            proof.push_back(preimage_hashes[index - 1]);
        };

        if (previous_level_hashes.length() % 2 != 0) {
            let last_element = previous_level_hashes[previous_level_hashes.length() - 1];
            previous_level_hashes.push_back(last_element);
        };
        preimage_hashes = reduce_single_hashes(previous_level_hashes);
        previous_level_hashes = reduce_double_hashes(previous_level_hashes);
        index = index / 2;
    };

    proof
}

#[test]
fun verify_merkle_proof_with_single_node_happy_case() {
    let root = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let proof = vector[];
    let tx_id = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let tx_index = 0;
    assert_eq!(verify_merkle_proof(root, proof, tx_id, tx_index), true);
}

#[test]
fun verify_merkle_proof_with_multiple_node_happy_case() {
    let root = x"701179cb9a9e0fe709cc96261b6b943b31362b61dacba94b03f9b71a06cc2eff";
    let proof = vector[
        x"a2fff7e7aa4ffd33f8a05b3a9b6f3cba22826c0232c4784a2aca1c4fe47597f9",
        x"9013cd2f322864fe9efd45955aacb36ee21efc4f49a4e2aa393a9ba029f0e6b8",
    ];
    let tx_id = x"8a9091a722fd88bf7a5e2efdff55d39937eff9ae7d69c700d19d795113a35312";
    let tx_index = 1;
    assert_eq!(verify_merkle_proof(root, proof, tx_id, tx_index), true);
}

#[test]
fun heavy_verification_happy_case() {
    // Data extract from BitVM tests!
    let tx_ids = vector[
        x"c9a10bc1044a9d89db7d1a2d8e0074f0cec9f9911da3160caeab593709406b90",
        x"854fbf7fd59627540f0377b3d59dc2c493a6442d9e429fe084b9d11dc6fc8420",
        x"b381d86b5991500119f1bd95e3fcbcc4a9107c7ea21bda41ff298358f2d1fd18",
        x"d43197b2fc36bdabf384d886b0ecd052f0169879c0e9c2e106715179ef838824",
        x"0422b4f3e737ab91cbe90534f62f89b1df4c56ef68486f93ba571d5ec5a9dc41",
        x"0d751d5c3cafe503d83d4c2cbc78e8a8363dbb79b786943c45babbf3d20bbb6e",
        x"0db98a1aa068861ad06ab9be279eb9dfb1714129e8663451fd5dfcdc925ec0c6",
        x"1427babc179d808752edc3d750dea7844a9a2b0cfdc3eeb925d4cca4bf6f179b",
        x"1b33f3e9229f3d8a114936e5c13c92cdb98119acad46f6a5d380da39b8241afc",
        x"1b574586c06525af3ecb927fbb7ad90e4e234d460df39ed0d1e174477fefd2b7",
        x"2a31dfa1100b465ff7f4e49acb495248deb049b7b159fc62486242b1a0786683",
        x"2d0168a96e2a4567abcde7417e79af2cc97c41e728fa3aa2b1b506c7c194e61d",
        x"3d5398c42949765d202bc2d4353eba9fc415149fabb5ee847b43910a0a78f86a",
        x"3ec7e816f2fa393d8e469e15e830a80b778334154c8b875fd5b2cb45c32db921",
        x"3efb6c6f821b29e0f4bbb24e29b9fce7f3b74ea2143024a64fbbdf0487c06fd3",
        x"910f822c831c0a256bc01e50c590f91c554f46b008f0180c5e3131fedaca5163",
        x"4049c949ab389bd8385b1b4dae60d3027646bca0f6bc0b56f341f43420f69821",
        x"4175ea98ee63ba836d94c1bf1fb21d54397655691ea9f94cea0ae1a4837daf15",
        x"4352372dc8715a6e63f05fa109c71645afe04994485d7fff05daa9f3976c405d",
        x"49f1929e3a41d4265fa54b948c2ace8c593c3e2263bbbebaba5a558f4fd48528",
        x"6084d975ec1f2d5675a428f8f23106d76cac3d541332b18db6a67868f1f9aaea",
        x"6c9e8c34c3d0ec9a947e7f1d491b764d59936cded6b2c708ff4ffc8c8df18ad9",
        x"6fcb431bf2774e70055f1dd06d9f3c3cdf99e8aeb495996276d2b16d828a0fdc",
        x"72988e51059b80a26e095d4b1143621035a6326a55491314b8792bd910e8349e",
        x"825e98e9bccf83b04a437d27bfa15b35eb3ddb3b6478adf97b6b8bfb7e462377",
        x"8e6049fde203ee2a620af02c2ec1e400ce23c71de1692827ffea8674c2c80a56",
        x"9db9fb7f07e1d63f2b16ba5a088d47f519cb78c47f48983c96671b64c204dec0",
        x"a5ef64d6fc31a0d74f77da97c5c7841ef5bfd4510c37df850e25b9ea5b69bf8e",
        x"a8b7b84f0d21f915f599062689fd191438047c56b6605183ae374861780ede3f",
        x"b49f677c64e1812993e59f84d5970d790036bb648126a16e7ddf97dcd7e0c2e2",
        x"b6ca3818df83f75b547a49502b6a594827eb4e64a9daf315e6fdd9bbb44ae803",
        x"bc7c8e2a049c2018e6e51e2f789a83749017ce1a7fdd431913affae9f46479d0",
        x"bd105405fa29fe8c0445d3c474dd71d80ccea21ad9bde8c2287d8663baa7ef48",
        x"c80d5c3938bc162abe2c8e4959d43465166be2da9a9593ba1d8b4e0f434c27ce",
        x"d7341da435413d5584b71d924fd047eefda2c6563fdc3bfc5091a1de1e9dd126",
        x"d838c356ee475ae9d5f64e7fd4d78c551a8350ea87d076c9c1ac80f38f429252",
        x"dc64316b296567fd2e8a7236a1c72dc8fa5c4f61fddc839b96f65538bad5d23d",
        x"e0a590c8580277df4013c3492b1c634bb624b956fabff5b14911e6e5c29a4698",
        x"e28d378f2623f42237ff1bfcd020af647c1bf668a65e1d9be5fca73a9489d868",
        x"e680f5438d5175aa6809cb6a8ed8a7563c4fae991255dd16891435ef4643c0bf",
        x"f38a83038c1b569780021e0ef1caca55e562a7ce6f95dc217300b121228e0759",
    ];

    let preimage_hashes = vector[
        x"5076557695a2d24e765d98ae3f9e1bf926d5939bb43fcd0606d4457da00a222f",
        x"d0d75eec2ccce09e9d979673d55b323517b0450db3d7f7f8d99cc26fe7dae2cf",
        x"f037028ecf54179d5787c5e85602859b3fd3cfce43c824330f01cd2d972a6b87",
        x"96829c3df04f4403ee2db55d2c112daec98a2db50847e892337789060e6bf292",
        x"c381951d09563f00c4fcc2b2d6cc1d1cb408548c06f7835f11ba88b5111a71be",
        x"fdfc1ce14d4df63f6022938639d6e30a4a92db3e194322973ce18a1bda4aeeac",
        x"a8c0db3be715608a1637f64ee9fd79f915606a5e6499d06806d60d7a91f74866",
        x"fb0d56fd53fa15e82ca10e581b0088cc4a6df27fd4ddec94f51935cb59e7a828",
        x"82aaeb034089909d11f7729073f7e5181140a12991851c5bf2307d4f9cb39424",
        x"bde9cf22110bb1c997db2df0c28d6ec9353aa81fa3a6c6e18eb49a520517429e",
        x"707bafe14358e2dc3fac879445aeea15353adbd186794d747942cea9f07b44b5",
        x"b9197b2ebf58595492dfbf08abb569188a83692071f24ed7e763d3366c8c5752",
        x"1622335707d693c40086a281bb969b0b86799c72e3e6d421d168d88a7b9aa738",
        x"ea4b80ffe37ce2336cd4627502629a67007123f41b62fff6db4803e3f6c485c4",
        x"a4e574b5fbb4cb2200fb006841b23152f4df0e43d3d3d5fad247b002899a3abd",
        x"526d5b0c7cc1e2e3116d8649e96d61f2b128af8a1e9ba46527ca7b0493bf83e1",
        x"1ef74a73cde013a9de379f8c9a0f47e207e210807ac20c5d91b0fba3054dd4d1",
        x"24d8f00f836bab90a889c6915748c32552e31cdf75af8c045aa1f1fcb2e3b16c",
        x"dec1300a10411e3a7d1bb8b81376e5a5c001509a69e3045c25eda0c497259b55",
        x"e2b0609fc36d42e57c33f457f34732e72c692baf61bd58b2aec87163067bf90c",
        x"04dacf282d0bd302a0fa1bcbcf39453e3aa8430332c5efa22a95e8871fde5260",
        x"d8f4fa39a6891bef3bf7cdfa8a56499729f664791de1327d1c9eb9425f206add",
        x"170d7ec49c32cb694d4ae8f8b5fae97adb5be90d4608b6d1608a339abbcabf4a",
        x"c3afde212213422bdd9dff119171b652e6e2778a1b24bcbc37b3ee4343c89e10",
        x"2c4d43d25e866bed4dbe07110e25ad32265381662910f5292e91c005b037f2f0",
        x"167d71f72eb32bed4d346c792b264dfb7dcd74aec31ae6194f28a0890219952d",
        x"d7d39ef26e9af3983a66e93384d7eb4cd3181cd6b1b78ebec4bc72235a31efaf",
        x"22b254bfd445f7eaa2459fd3cd1346d265ae6ea78e0b495d2fc04cc3f9aa38f3",
        x"a495b6a24615605a788993bd8cf9349f19ee458078e3ff0d7df29dd3c86776b9",
        x"28b1c4d470db1cb63ce46e9c7b7d5f7ffecb3ac0b3a28224493ca71fc291ec4f",
        x"70512193ce78d3dde7b2dcd960b6b00ac4c79ceb2492d009563c42e885d11f9f",
        x"bc0e19c0b496614722bf19ee2e098d51bed90f18f0a8258ffcd651e01e2432da",
        x"f864f7882291b0fccb2db4218b0bf044ff355d2002e07a4e5396b09c0fede0d5",
        x"24a67bc4f60bbbf3f6ab163349db9f1b373236c8575889e62552a755b102ce0e",
        x"afa90d0dc1f069828c039b129e882456b0551123d10894ce5f80384dca32d0b2",
        x"f5854d4a2c5d98b1dad0c721ccaf0b5ba6117bc3926a5002fe517e95814f9273",
        x"6cc9863f9d865aa06628b51d1e9aa58b48972cd843aabb1610fafae0a3eb7f34",
        x"6e6cbc9535c23407fe839ce20e59eec89297e2f9d8d0747c9bab765d1eaab196",
        x"d97c124359b7ededc7f9a4900610f0d3b06bc9e81d955f94aecf54a2bff4821f",
        x"ad2369fc028ccea7aa0e4bf8a04af01373bf0b6b263dfa6b11a8eefd4cfabc1c",
        x"7bee58a8cac7ab826e1a83ee5e84630776bf2c71f3d3c2b76978a62eac413b4a",
    ];

    assert!(preimage_hashes.length() == tx_ids.length());

    let root = x"71ff9f8ea5a251fa28934d6920f4c87724ef9a552f0e00a5020b83dc11a13870";

    tx_ids.length().do!(|i| {
        let proof = create_proof_for_testing(preimage_hashes, tx_ids, i);
        assert_eq!(verify_merkle_proof(root, proof, tx_ids[i], i), true);
    });
}
#[test]
fun verify_merkle_proof_with_invalid_proof_should_fail() {
    // ported from summa-tx
    // https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/test/ViewSPV.test.js#L44
    // https://github.com/summa-tx/bitcoin-spv/blob/master/testVectors.json#L1114
    let root = x"48e5a1a0e616d8fd92b4ef228c424e0c816799a256c6a90892195ccfc53300d6";
    let tx_id = x"48e5a1a0e616d8fd92b4ef228c424e0c816799a256c6a90892195ccfc53300d6";
    let proof = vector[
        x"e35a0d6de94b656694589964a252957e4673a9fb1d2f8b4a92e3f0a7bb654fdd",
        x"b94e5a1e6d7f7f499fd1be5dd30a73bf5584bf137da5fdd77cc21aeb95b9e357",
        x"88894be019284bd4fbed6dd6118ac2cb6d26bc4be4e423f55a3a48f2874d8d02",
        x"a65d9c87d07de21d4dfe7b0a9f4a23cc9a58373e9e6931fefdb5afade5df54c9",
        x"1104048df1ee999240617984e18b6f931e2373673d0195b8c6987d7ff7650d5c",
        x"e53bcec46e13ab4f2da1146a7fc621ee672f62bc22742486392d75e55e67b099",
        x"60c3386a0b49e75f1723d6ab28ac9a2028a0c72866e2111d79d4817b88e17c82",
        x"1937847768d92837bae3832bb8e5a4ab4434b97e00a6c10182f211f592409068",
        x"d6f5652400d9a3d1cc150a7fb692e874cc42d76bdafc842f2fe0f835a7c24d2d",
        x"60c109b187d64571efbaa8047be85821f8e67e0e85f2f5894bc63d00c2ed9d64",
    ];
    let tx_index = 0;
    assert_eq!(verify_merkle_proof(root, proof, tx_id, tx_index), false);
}

#[test, expected_failure(abort_code = EInvalidMerkleHashLengh)]
fun tx_id_invalid_length_should_fail() {
    let root = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let proof = vector[];
    let tx_id = x""; // invalid length
    let tx_index = 0;
    verify_merkle_proof(root, proof, tx_id, tx_index);
}

#[test, expected_failure(abort_code = EInvalidMerkleHashLengh)]
fun root_invalid_length_should_fail() {
    let root = x"";
    let proof = vector[];
    let tx_id = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000"; // invalid length
    let tx_index = 0;
    verify_merkle_proof(root, proof, tx_id, tx_index);
}

#[test, expected_failure(abort_code = EInvalidMerkleHashLengh)]
fun merkle_path_element_invalid_length_should_fail() {
    let root = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let proof = vector[x"01"];
    let tx_id = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000"; // invalid length
    let tx_index = 1;
    verify_merkle_proof(root, proof, tx_id, tx_index);
}
