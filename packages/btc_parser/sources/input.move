// SPDX-License-Identifier: MPL-2.0

module btc_parser::input;

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
