#[test_only]
module bitcoin_spv::block_header_tests;
use bitcoin_spv::block_header::{new_block_header, EPoW};
use bitcoin_spv::btc_math::to_u32;
use bitcoin_spv::utils::slice;

#[test]
fun block_header_test() {
    // data get from block 0000000000000000000293bf6e86820d867cc4ca13cd98326af85bb3bebab9ac from mainnet
    // or block 794143
    let raw_header =
        x"000080200e102b98a160f4416c8ff0198db9b177523525c9de8a000000000000000000003b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b560e8864697e051767c0c9fd";
    let header = new_block_header(raw_header);

    // verify data extract from header
    assert!(header.version() == to_u32(x"00008020"));
    assert!(
        header.prev_block() == x"0e102b98a160f4416c8ff0198db9b177523525c9de8a00000000000000000000",
    );
    assert!(
        header.merkle_root() == x"3b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b",
    );
    assert!(header.timestamp() == to_u32(x"560e8864"));
    assert!(header.bits() == to_u32(x"697e0517"));
    assert!(header.nonce() == to_u32(x"67c0c9fd"));
    assert!(
        header.block_hash() == x"acb9babeb35bf86a3298cd13cac47c860d82866ebf9302000000000000000000",
    );
    assert!(header.calc_work() == 220053167595535890616746);
}

#[test]
fun block_header_summar() {
    let raw_headers = x"0000002073bd2184edd9c4fc76642ea6754ee40136970efc10c4190000000000000000000296ef123ea96da5cf695f22bf7d94be87d49db1ad7ac371ac43c4da4161c8c216349c5ba11928170d38782b00000020fe70e48339d6b17fbbf1340d245338f57336e97767cc240000000000000000005af53b865c27c6e9b5e5db4c3ea8e024f8329178a79ddb39f7727ea2fe6e6825d1349c5ba1192817e2d9515900000020baaea6746f4c16ccb7cd961655b636d39b5fe1519b8f15000000000000000000c63a8848a448a43c9e4402bd893f701cd11856e14cbbe026699e8fdc445b35a8d93c9c5ba1192817b945dc6c00000020f402c0b551b944665332466753f1eebb846a64ef24c71700000000000000000033fc68e070964e908d961cd11033896fa6c9b8b76f64a2db7ea928afa7e304257d3f9c5ba11928176164145d0000ff3f63d40efa46403afd71a254b54f2b495b7b0164991c2d22000000000000000000f046dc1b71560b7d0786cfbdb25ae320bd9644c98d5c7c77bf9df05cbe96212758419c5ba1192817a2bb2caa00000020e2d4f0edd5edd80bdcb880535443747c6b22b48fb6200d0000000000000000001d3799aa3eb8d18916f46bf2cf807cb89a9b1b4c56c3f2693711bf1064d9a32435429c5ba1192817752e49ae0000002022dba41dff28b337ee3463bf1ab1acf0e57443e0f7ab1d000000000000000000c3aadcc8def003ecbd1ba514592a18baddddcd3a287ccf74f584b04c5c10044e97479c5ba1192817c341f595";

    let mut i = 0;
    let mut cal_work = 0;
    while (i < raw_headers.length()) {
        let raw_header = slice(raw_headers, i, i + 80);
        let header = new_block_header(raw_header);
        cal_work = cal_work + header.calc_work();
        i = i + 80;
    };
    assert!(cal_work == 49134394618239);
}
#[test]
fun pow_check_happy_test() {
    // https://learnmeabitcoin.com/explorer/block/00000000f01df1dbc52bce6d8d31167a8fef76f1a8eb67897469cf92205e806b
    let header = new_block_header(
        x"01000000cb60e68ead74025dcfd4bf4673f3f71b1e678be9c6e6585f4544c79900000000c7f42be7f83eddf2005272412b01204352a5fddbca81942c115468c3c4ec2fff827ad949ffff001d21e05e45",
    );
    header.pow_check();

    // https://learnmeabitcoin.com/explorer/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
    let header = new_block_header(
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c",
    );
    header.pow_check();
}

#[test]
#[expected_failure(abort_code = EPoW)] // ENotFound is a constant defined in the module
fun pow_check_failure_test() {
    // we get block header from https://learnmeabitcoin.com/explorer/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f. However, we set nonce = 0x00000000 which is make pow_check failed
    let header = new_block_header(
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d00000000",
    );
    header.pow_check();
}
