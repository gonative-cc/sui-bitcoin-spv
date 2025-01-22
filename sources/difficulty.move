module bitcoin_spv::difficulty;

/// number of bytes to represent number. 
fun bytes_of(number: u256) : u8 {
    let mut b : u8 = 255;
    while (number & (1 << b) == 0 && b > 0) {
	b = b - 1;
    };

    ((b as u32 + 1 ) / 8) as u8
}

/// get last 32 bits of number
fun get_last_32_bits(number: u256): u32 {
    return (number & 0xffffffff) as u32
}



/// target => bit conversion function.
/// target is the number you need to get below to mine a block - it defines the difficulty.
/// The bits field contains a compact representation of the target.
/// format of bits = <1 byte for exponent><3 bytes for coefficient>
/// target = coefficient * 2^ (coefficient - 3) (note: 3 = bytes length of the coefficient).
/// Caution:
///    The first significant byte for the coefficient must be below 80. If it's not, you have to take the preceding 00 as the first byte. 
/// More & examples: https://learnmeabitcoin.com/technical/block/bits.
public fun target_to_bits(target: u256): u32 {
    // TODO: Handle case nagative target?
    // I checked bitcoin-code. They did't create any negative target.
  
    let mut coefficient = bytes_of(target);
    let mut compact;
    if (coefficient <= 3) {
	let exponent: u8 = 8 * ( 3 - coefficient);
	compact = get_last_32_bits(target) << exponent
    } else {
	let exponent : u8 = 8 * (coefficient - 3);
	let bn = (target >> exponent);
	compact = get_last_32_bits(bn)
    };

    if (compact & 0x00800000 > 0) {
	compact = compact >> 8;
	coefficient = coefficient + 1;
    };
    
    // TODO: check some conditions for compact ...
    // TODO: add TODO for this todo!
    compact = compact | ((coefficient as u32) << 24);

    compact
}

/// converts bits to target. See documentation to the function above for more details.
public fun bits_to_target(bits: u32): u256 {
    let exponent = bits >> 3*8;
    let mut target = (bits & 0x007fffff) as u256;
    
    if (exponent <= 3) {
	let bits_shift = (8 * (3 - exponent)) as u8;
	target = target >> bits_shift;
    } else {
	let bits_shift = (8 * (exponent - 3)) as u8;
	target = target << bits_shift;
    };
    return target
}
