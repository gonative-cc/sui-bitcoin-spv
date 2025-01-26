#[test_only]
module bitcoin_spv::block_header_tests;
use bitcoin_spv::block_header::{new_block_header};
use bitcoin_spv::btc_math::to_u32;

#[test]
fun block_header_tests() {
    // data get from block 0000000000000000000293bf6e86820d867cc4ca13cd98326af85bb3bebab9ac from mainnet
    // or block 794143
    let raw_header = x"000080200e102b98a160f4416c8ff0198db9b177523525c9de8a000000000000000000003b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b560e8864697e051767c0c9fd";
    let header = new_block_header(raw_header);

    // verify data extract from header
    assert!(header.version() == to_u32(x"00008020"));
    assert!(header.prev_block() == x"0e102b98a160f4416c8ff0198db9b177523525c9de8a00000000000000000000");
    assert!(header.merkle_root() == x"3b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b");
    assert!(header.timestamp() == to_u32(x"560e8864"));
    assert!(header.bits() == to_u32(x"697e0517"));
    assert!(header.nonce() == to_u32(x"67c0c9fd"));

    assert!(header.block_hash() == x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000");
}
