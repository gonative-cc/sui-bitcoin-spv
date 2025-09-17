// SPDX-License-Identifier: MPL-2.0

#[test_only]
module bitcoin_spv::block_header_tests;

use bitcoin_spv::block_header::{EPoW, calc_work, pow_check, target};
use btc_parser::header::{Self, BlockHeader};
use std::unit_test::assert_eq;

use fun calc_work as BlockHeader.calc_work;
use fun pow_check as BlockHeader.pow_check;
use fun target as BlockHeader.target;

#[test]
fun calc_work_and_target_happy_cases() {
    let header = header::new(
        x"000080200e102b98a160f4416c8ff0198db9b177523525c9de8a000000000000000000003b9b941003024e1afa90199732fdb1366a122ab0a5cacd3f7bcb8cb8815a811b560e8864697e051767c0c9fd",
    );
    assert_eq!(header.calc_work(), 220053167595535890616746);
    assert_eq!(header.target(), 526200511006255617572972890856003254679941608705622016);
}

#[test]
fun pow_check_happy_cases() {
    // https://learnmeabitcoin.com/explorer/block/00000000f01df1dbc52bce6d8d31167a8fef76f1a8eb67897469cf92205e806b
    // {
    //     "version": "01000000",
    //     "previous_block_hash": "cb60e68ead74025dcfd4bf4673f3f71b1e678be9c6e6585f4544c79900000000",
    //     "merkle_root": "c7f42be7f83eddf2005272412b01204352a5fddbca81942c115468c3c4ec2fff",
    //     "timestamp": "827ad949",
    //     "difficulty_target": "ffff001d",
    //     "nonce": "21e05e45"
    // }
    let header = header::new(
        x"01000000cb60e68ead74025dcfd4bf4673f3f71b1e678be9c6e6585f4544c79900000000c7f42be7f83eddf2005272412b01204352a5fddbca81942c115468c3c4ec2fff827ad949ffff001d21e05e45",
    );
    header.pow_check();

    // https://learnmeabitcoin.com/explorer/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
    // {
    //     "version": "01000000",
    //     "previous_block_hash": "0000000000000000000000000000000000000000000000000000000000000000",
    //     "merkle_root": "3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a",
    //     "timestamp": "29ab5f49",
    //     "difficulty_target": "ffff001d",
    //     "nonce": "1dac2b7c"
    // }
    let header = header::new(
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c",
    );
    header.pow_check();
}

#[test]
#[expected_failure(abort_code = EPoW)] // ENotFound is a constant defined in the module
fun pow_check_on_header_not_satisfy_pow_should_fail() {
    // we get block header from https://learnmeabitcoin.com/explorer/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f. However, we set nonce = 0x00000000 which is make pow_check failed
    let header = header::new(
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d00000000",
    );
    header.pow_check();
}
