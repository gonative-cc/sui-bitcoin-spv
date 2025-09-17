// SPDX-License-Identifier: MPL-2.0

module btc_parser::input;

use btc_parser::encoding::u64_to_varint_bytes;
use btc_parser::reader::Reader;

/// Input in btc transaction
public struct Input has copy, drop, store {
    tx_id: vector<u8>,
    vout: vector<u8>,
    script_sig: vector<u8>,
    sequence: vector<u8>,
}

public fun new(
    tx_id: vector<u8>,
    vout: vector<u8>,
    script_sig: vector<u8>,
    sequence: vector<u8>,
): Input {
    Input {
        tx_id,
        vout,
        script_sig,
        sequence,
    }
}

public fun tx_id(input: &Input): vector<u8> {
    input.tx_id
}

public fun vout(input: &Input): vector<u8> {
    input.vout
}

public fun script_sig(input: &Input): vector<u8> {
    input.script_sig
}

public fun sequence(input: &Input): vector<u8> {
    input.sequence
}

public(package) fun decode(r: &mut Reader): Input {
    let tx_id = r.read(32);
    let vout = r.read(4);
    let script_sig_size = r.read_compact_size();
    let script_sig = r.read(script_sig_size);
    let sequence = r.read(4);

    Input {
        tx_id,
        vout,
        script_sig,
        sequence,
    }
}

public(package) fun encode(input: &Input): vector<u8> {
    let mut raw_input = vector[];
    raw_input.append(input.tx_id);
    raw_input.append(input.vout);
    raw_input.append(u64_to_varint_bytes(input.script_sig.length()));
    raw_input.append(input.script_sig);
    raw_input.append(input.sequence);
    raw_input
}
