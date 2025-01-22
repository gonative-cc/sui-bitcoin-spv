module bitcoin_spv::difficulty;

// number of bytes to represent number. 
fun bytes_of(number: u256) : u8 {
    let mut b : u8 = 255;
    
    while (number & (1 << b) == 0) {
		b = b - 1;
    };

    ((b as u32 + 1 ) / 8) as u8
}

// get last 32 bits of number
fun get_last_32_bits(number: u256): u32 {
    return (number & 0xffffffff) as u32
}



/// format of bits = <1 byte for exponent><3 bytes for coefficient>
/// format target = 000000<3 bytes of coefficient>00000000000000000
///                         |------------- exponent bytes-----------|
///                   |--------------32 bytes or 256 bits-----------|

// === target <> bit convert function ===
public fun target_to_bits(target: u256): u32 {
    // TODO: Handle case nagative target?
    // I checked bitcoin-code. They did't create any negative target.
    let mut number_bytes = bytes_of(target);
    let mut compact;
    if (number_bytes <= 3) {
	let exponent: u8 = 8 * ( 3 - number_bytes);
	compact = get_last_32_bits(target) << exponent
    } else {
	let exponent : u8 = 8 * (number_bytes - 3);
	let bn = (target >> exponent);
	compact = get_last_32_bits(bn)
    };

    if (compact & 0x00800000 > 0) {
	compact = compact >> 8;
	number_bytes = number_bytes + 1;
    };
    
    // TODO: check some conditions for compact ...
    // TODO: add TODO for this todo!
    compact = compact | ((number_bytes as u32) << 24);

    compact
}

public fun bits_to_target(bits: u32): u256 {
    let number_bytes = bits >> 24;
    let mut word = (bits & 0x007fffff) as u256;

    if (number_bytes <= 3) {
	let exponent = (8 * (3 - number_bytes)) as u8;
	word = word >> exponent;
    } else {
	let exponent = (8 * (number_bytes - 3)) as u8;
	word = word << exponent;
    };
    return word
}
