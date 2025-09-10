// SPDX-License-Identifier: MPL-2.0

module btc_parser::reader;

use btc_parser::encoding::le_bytes_to_u64;

// TODO: Follow error in btc implemetation
#[error]
const EBadReadData: vector<u8> = b"Invalid read script";

public struct Reader has copy, drop {
    data: vector<u8>,
    next_index: u64,
}

/// Creates a new reader
public fun new(data: vector<u8>): Reader {
    Reader {
        data: data,
        next_index: 0,
    }
}

/// Checks if the next `len` bytes are readable
public fun readable(r: &Reader, len: u64): bool {
    r.next_index + len <= r.data.length()
}

/// Checks if end of stream
public fun end_stream(r: &Reader): bool {
    r.next_index >= r.data.length()
}

/// reads `len` amount of bytes from the Reader
public fun read(r: &mut Reader, len: u64): vector<u8> {
    let buf = r.peek(len);
    r.next_index = r.next_index + len;
    buf
}

public fun peek(r: &Reader, len: u64): vector<u8> {
    assert!(r.readable(len), EBadReadData);

    let mut i = r.next_index;
    let mut j = 0;
    let mut buf = vector[];
    while (j < len) {
        buf.push_back(r.data[i]);
        j = j + 1;
        i = i + 1;
    };

    buf
}

public fun read_u32(r: &mut Reader): u32 {
    let v = r.read(4);
    le_bytes_to_u64(v) as u32
}

public fun read_compact_size(r: &mut Reader): u64 {
    let offset = r.read_byte();
    if (offset <= 0xfc) {
        return offset as u64
    };

    let offset = if (offset == 0xfd) {
        2
    } else if (offset == 0xfe) {
        4
    } else {
        8
    };

    let v = r.read(offset);
    le_bytes_to_u64(v)
}

/// reads the next byte from the stream
public fun read_byte(r: &mut Reader): u8 {
    let b = r.data[r.next_index];
    r.next_index = r.next_index + 1;
    b
}

/// Returns the next opcode
public fun next_opcode(r: &mut Reader): u8 {
    let opcode = r.read_byte();
    opcode
}

/// isSuccess tracks the set of op codes that are to be interpreted as op
/// codes that cause execution to automatically succeed.
public fun isOpSuccess(opcode: u8): bool {
    // https://github.com/bitcoin/bitcoin/blob/v29.0/src/script/script.cpp#L358
    opcode == 80 || opcode == 98 || (opcode >= 126 && opcode <= 129) ||
        (opcode >= 131 && opcode <= 134) || (opcode >= 137 && opcode <= 138) ||
        (opcode >= 141 && opcode <= 142) || (opcode >= 149 && opcode <= 153) ||
        (opcode >= 187 && opcode <= 254)
}
