module bitcoin_spv::transaction;
use bitcoin_spv::btc_math::{btc_hash, covert_to_compact_size, to_number, compact_size};
use bitcoin_spv::utils::slice;

const EInvalidNullScript: u64 = 0;


// === BTC script opcodes ===
const OP_DUP: u8 = 0x76;
const OP_HASH160: u8 = 0xa9;
const OP_DATA_20: u8 = 0x14;
const OP_EQUALVERIFY: u8  = 0x88;
const OP_CHECKSIG: u8 = 0xac;
const OP_RETURN: u8 = 0x6a;
const OP_PUSHDATA4: u8 = 0x4e;
const OP_PUSHDATA2: u8 = 0x4d;
const OP_PUSHDATA1: u8 = 0x4c;
const OP_DATA_75: u8 = 0x4b;


/// Represents a Bitcoin transaction output
public struct Output has copy, drop {
    amount: u256,
    script_pubkey: vector<u8>
}
// Represents a Bitcoin transaction
public struct Transaction has copy, drop {
    version: vector<u8>,
    input_count: u256,
    inputs: vector<u8>,
    output_count: u256,
    outputs: vector<Output>,
    tx_id: vector<u8>,
    lock_time: vector<u8>
}


// TODO: better name for this.
// we don't create any new transaction
public fun parse_transaction(
    version: vector<u8>,
    input_count: u256,
    inputs: vector<u8>,
    output_count: u256,
    outputs: vector<u8>,
    lock_time: vector<u8>,
): Transaction {
    assert!(version.length() == 4);
    assert!(lock_time.length() == 4);
    let number_input_bytes = covert_to_compact_size(input_count);
    let number_output_bytes = covert_to_compact_size(output_count);

    // compute TxID
    let mut tx_data = version;
    tx_data.append(number_input_bytes);
    tx_data.append(inputs);
    tx_data.append(number_output_bytes);
    tx_data.append(outputs);
    tx_data.append(lock_time);

    let tx_id = btc_hash(tx_data);

    let outputs_decoded = decode_outputs(output_count, outputs);

    Transaction {
        version,
        input_count,
        inputs,
        output_count,
        outputs: outputs_decoded,
        lock_time,
        tx_id
    }
}

public fun parse_output(amount: u256, script_pubkey: vector<u8>): Output {
    Output {
        amount,
        script_pubkey
    }
}

public fun tx_id(tx: &Transaction): vector<u8> {
    return tx.tx_id
}

public fun outputs(tx: &Transaction): vector<Output> {
    tx.outputs
}

public fun amount(output: &Output): u256 {
    output.amount
}

public fun is_pk_hash_script(output: &Output): bool {
    let script = output.script_pubkey;
    if (
        script.length() == 25 &&
		script[0] == OP_DUP &&
		script[1] == OP_HASH160 &&
		script[2] == OP_DATA_20 &&
		script[23] == OP_EQUALVERIFY &&
		script[24] == OP_CHECKSIG
    ) {
		return true
	};
    false
}

public fun is_op_return(output: &Output): bool {
    let script = output.script_pubkey;
    return script.length() > 0 && script[0] == OP_RETURN
}

public fun p2pkh_address(output: &Output): vector<u8> {
    // TODO: we support P2PKH and P2PWKH now.
    // We will and more script after.
    // and the script must return error if we don't support standard script
    let script = output.script_pubkey;
	return slice(script, 3, 23)
}

public fun op_return_message(output: &Output): vector<u8> {
    let script = output.script_pubkey;
    if (script[1] <= OP_DATA_75) {
        // script = op_return OP_DATA_<len> DATA. len(DATA) = <len>
        return slice(script, 2, script.length())
    };

    if (script[1] == OP_PUSHDATA1) {
        return slice(script, 3, script.length())
    };

    if (script[1] == OP_PUSHDATA2) {
        return slice(script, 4, script.length())
    };

    if (script[1] == OP_PUSHDATA4) {
        return slice(script, 6, script.length())
    };

    abort EInvalidNullScript
}

// TODO: create readbytes APIs
public(package) fun decode_outputs(number_input: u256, inputs_bytes: vector<u8>): vector<Output> {
    let mut outputs = vector[];
    let mut start = 0u64;
    let mut script_pubkey_size;
    let mut i = 0;

    while (i < number_input) {
        let amount = slice(inputs_bytes, start, start + 8); // 8 bytes of amount
        start = start + 8;
        (script_pubkey_size, start) = compact_size(inputs_bytes, start);
        let script_pubkey = slice(inputs_bytes, start, (start + (script_pubkey_size as u64)));
        start = start + (script_pubkey_size as u64);
        let output = parse_output(to_number(amount, 0, 8), script_pubkey);
        outputs.push_back(output);
        i = i + 1;
    };

    outputs
}
