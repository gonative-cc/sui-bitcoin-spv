// SPDX-License-Identifier: MPL-2.0

module btc_parser::tx;

use btc_parser::crypto::hash256;
use btc_parser::encoding::{u64_to_varint_bytes, le_bytes_to_u64};
use btc_parser::input::{Self, Input};
use btc_parser::output::{Self, Output};
use btc_parser::reader::Reader;

// list of witnesses for inputs
public struct InputWitness has copy, drop, store {
    items: vector<vector<u8>>,
}

/// BTC transaction
public struct Transaction has copy, drop, store {
    version: vector<u8>,
    inputs: vector<Input>,
    marker: Option<u8>,
    flag: Option<u8>,
    outputs: vector<Output>,
    witness: vector<InputWitness>,
    locktime: vector<u8>,
    tx_id: vector<u8>,
}

// TODO: `new` is not good name here.
/// Create a btc data
public fun new(
    version: vector<u8>,
    marker: Option<u8>,
    flag: Option<u8>,
    inputs: vector<Input>,
    outputs: vector<Output>,
    witness: vector<InputWitness>,
    locktime: vector<u8>,
    tx_id: vector<u8>,
): Transaction {
    Transaction {
        version,
        marker,
        flag,
        inputs,
        outputs,
        witness,
        locktime,
        tx_id,
    }
}

public fun items(w: &InputWitness): vector<vector<u8>> {
    w.items
}

public fun version(tx: &Transaction): vector<u8> {
    tx.version
}

public fun inputs(tx: &Transaction): vector<Input> {
    tx.inputs
}

public fun outputs(tx: &Transaction): vector<Output> {
    tx.outputs
}

public fun witness(tx: &Transaction): vector<InputWitness> {
    tx.witness
}

public fun locktime(tx: &Transaction): vector<u8> {
    tx.locktime
}

public fun input_at(tx: &Transaction, idx: u64): &Input {
    &tx.inputs[idx]
}

public fun output_at(tx: &Transaction, idx: u64): &Output {
    &tx.outputs[idx]
}

public fun is_witness(tx: &Transaction): bool {
    if (tx.marker.is_none() || tx.flag.is_none()) {
        return false
    };

    let m = tx.marker.borrow();
    let f = tx.flag.borrow();
    m == 0x00 && f == 0x01
}

public fun tx_id(tx: &Transaction): vector<u8> {
    tx.tx_id
}

/// deseriablize transaction from bytes
public fun deserialize(r: &mut Reader): Transaction {
    // transaction data without segwit.
    // use for compute the tx_id
    let mut raw_tx = vector[];

    let version = r.read(4);
    raw_tx.append(version);

    let segwit = r.peek(2);
    let mut marker: Option<u8> = option::none();
    let mut flag: Option<u8> = option::none();
    if (segwit[0] == 0x00 && segwit[1] == 0x01) {
        // TODO: Handle case marker and option is none
        marker = option::some(r.read_byte());
        flag = option::some(r.read_byte());
    };

    let number_inputs = r.read_compact_size();
    raw_tx.append(u64_to_varint_bytes(number_inputs));
    let mut inputs = vector[];
    number_inputs.do!(|_| {
        let tx_id = r.read(32);
        raw_tx.append(tx_id);
        let vout = r.read(4);
        raw_tx.append(vout);
        let script_sig_size = r.read_compact_size();
        raw_tx.append(u64_to_varint_bytes(script_sig_size));
        let script_sig = r.read(script_sig_size);
        raw_tx.append(script_sig);
        let sequence = r.read(4);
        raw_tx.append(sequence);
        let inp = input::decode(r);
        inputs.push_back(
            inp,
        );
        raw_tx.append(inp.encode());
    });

    // read outputs
    let number_outputs = r.read_compact_size();
    raw_tx.append(u64_to_varint_bytes(number_outputs));
    let mut outputs = vector[];
    number_outputs.do!(|_| {
        let amount = r.read(8);
        raw_tx.append(amount);
        let script_pubkey_size = r.read_compact_size();
        let script_pubkey = r.read(script_pubkey_size);
        raw_tx.append(u64_to_varint_bytes(script_pubkey_size));
        raw_tx.append(script_pubkey);
        outputs.push_back(
            output::new(
                le_bytes_to_u64(amount),
                script_pubkey,
            ),
        )
    });

    let mut witness = vector[];
    if (segwit[0] == 0x00 && segwit[1] == 0x01) {
        number_inputs.do!(|_| {
            let stack_item = r.read_compact_size();
            let mut items = vector[];
            stack_item.do!(|_| {
                let size = r.read_compact_size();
                items.push_back(r.read(size));
            });
            witness.push_back(InputWitness {
                items,
            });
        })
    };

    let locktime = r.read(4);
    raw_tx.append(locktime);

    let tx_id = hash256(raw_tx);
    new(
        version,
        marker,
        flag,
        inputs,
        outputs,
        witness,
        locktime,
        tx_id,
    )
}

public fun is_coinbase(tx: &Transaction): bool {
    // TODO: check BIP34 and BIP141
    tx.inputs.length() == 1 && tx.inputs[0].vout() == x"ffffffff" &&
        tx.inputs[0].tx_id() ==  x"0000000000000000000000000000000000000000000000000000000000000000"
}
