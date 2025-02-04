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
    let root = x"e54435f50bfc776b8f3d9ac047963ee6bdddd8d40b69236b4d97acb52a1fdce4";
    let proof = vector[
	    x"7f27c8469739fe2bcccc60678924b6f9f0c48b7a0c8d5383ec3918adf75b2f8e",
        x"850074d84f29a79d18b21291b3b1865482ad7287a54ac9b8ca50d313ce97eb2f",
        x"bc9754fb09b76c4c91d4346a3d48176ca4eabb4872d83b35fd8381cf8968ba60",
        x"0cadf14fc97c255e921f3153094bfc3ec3107a11a4469362d079cd24db36f905",
        x"5722a73b9d34d24cf478110300f357261af0f58492b40a2e43ee3bebc47ca258",
        x"c46d5f5873dd8abf4f485896f7b685fef9cd39ac6488630c947af2be80a55ce9",
        x"640a62ef76aaab85f93a19ac9a9e16af5572bf891654e29d343d1537e8199584",
        x"cf118c0a5b81e83b0add90aee66103e8c975b160f74f05682ea6d6c6bc4d1ccd"
    ];
    let tx_id = x"3236cb8910885835403dded03a20e7c36437ce35f942887ed12393405b622442";
    let tx_index = 0;
    assert!(verify_merkle_proof(root, proof, tx_id, tx_index));
}
