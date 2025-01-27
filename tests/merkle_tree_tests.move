module bitcoin_spv::merkle_tree_tests;

use bitcoin_spv::merkle_tree::verify_merkle_proof;


#[test]
fun verify_merkle_proof_with_single_node_test() {
    let root = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let proof = vector[];
    let tx_id = x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000";
    let tx_index = 0;
    assert!(verify_merkle_proof(root, proof, tx_id, tx_index));    
}

#[test]
fun verify_merkle_proof_with_multiple_node_test() {
    let root = x"";
    let proof = vector[
    ];
    let tx_id = x"";
    let tx_index = 0;
}

