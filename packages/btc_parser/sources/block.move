// SPDX-License-Identifier: MPL-2.0

module btc_parser::block;

use btc_parser::header::{Self, BlockHeader};
use btc_parser::reader;
use btc_parser::tx::{Self, Transaction};

#[test_only]
use std::unit_test::assert_eq;

/// A block is a collection of all transactions in the BTC block
public struct Block has copy, drop, store {
    block_header: BlockHeader,
    transactions: vector<Transaction>,
}

public fun new(raw_block: vector<u8>): Block {
    let mut r = reader::new(raw_block);
    let block_header = header::new(r.read(80));
    let number_tx = r.read_compact_size();
    let mut transactions = vector[];
    number_tx.do!(|_| {
        transactions.push_back(tx::deserialize(&mut r));
    });

    Block {
        block_header,
        transactions,
    }
}

public fun txns(b: &Block): vector<Transaction> {
    b.transactions
}

public fun header(b: &Block): BlockHeader {
    b.block_header
}

#[test]
fun parse_block_test() {
    let data =
        x"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4adae5494dffff7f20020000000101000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000";

    let block = new(data);

    assert_eq!(
        block.block_header.block_hash(),
        x"06226e46111a0b59caaf126043eb5bbf28c34f3a5e332a1fc7b2b73cf188910f",
    );
    assert_eq!(
        block.transactions[0].tx_id(),
        x"3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a",
    );
}

#[test]
fun parse_block_segwit_test() {
    let data =
        x"0000003085bbc10dc8694fe36144c87f7737c35f9e3e8e304c61427a7cbce8b1e97004153fb8582bc04a0abb67965f6c139445bdc5d173ddc80008aa219929ab7285278f3f5b6167ffff7f200000000001020000000001010000000000000000000000000000000000000000000000000000000000000000ffffffff0402c80000ffffffff0200f902950000000016001411b424162694c5111b0b742bd5cb5e08bf206b9b0000000000000000266a24aa21a9ede2f61c3f71d1defd3fa999dfa36953755c690689799962b48bebd836974e8cf90120000000000000000000000000000000000000000000000000000000000000000000000000";

    let block = new(data);

    assert_eq!(
        block.block_header.block_hash(),
        x"516567e505288fe41b2fc6be9b96318c406418c7d338168fe75a26111490eb2f",
    );
    assert_eq!(
        block.transactions[0].tx_id(),
        x"3fb8582bc04a0abb67965f6c139445bdc5d173ddc80008aa219929ab7285278f",
    );
}
