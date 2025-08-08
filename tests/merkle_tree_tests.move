// SPDX-License-Identifier: MPL-2.0
#[test_only]
module bitcoin_spv::merkle_tree_tests;

use bitcoin_spv::merkle_tree::{verify_merkle_proof, EInvalidMerkleHashLengh};
use std::unit_test::assert_eq;

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
