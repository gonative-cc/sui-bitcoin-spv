module bitcoin_spv::difficulty;

use bitcoin_spv::bitcoin_spv::LightClient;
use bitcoin_spv::light_block::LightBlock;

/// number of bytes to represent number. 
fun bytes_of(number: u256) : u8 {
    let mut b : u8 = 255;
    while (number & (1 << b) == 0 && b > 0) {
	b = b - 1;
    };
    // Follow logic in bitcoin core
    ((b as u32 + 7 ) / 8) as u8
}

/// get last 32 bits of number
fun get_last_32_bits(number: u256): u32 {
    return (number & 0xffffffff) as u32
}

/// target => bits conversion function.
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
    
    let mut exponent = bytes_of(target);
    let mut coefficient;
    if (exponent <= 3) {
	let bits_shift: u8 = 8 * ( 3 - exponent);
	coefficient = get_last_32_bits(target) << bits_shift;
    } else {
	let bits_shift : u8 = 8 * (exponent - 3);
	let bn = target >> bits_shift;
	coefficient = get_last_32_bits(bn)
    };


    // handle case target is nagative number.
    // 0x00800000 is set then it indicates a negative value
    // and target can be nagative
    if (coefficient & 0x00800000 > 0) {
	// we push 00 before coefficet
	coefficient = coefficient >> 8;
	exponent = exponent + 1;
    };
    
    let compact = coefficient | ((exponent as u32) << 24);

    // TODO: Check case target is a negative number.
    // However, the target mustn't be a negative number
    
    compact
}

/// converts bits to target. See documentation to the function above for more details.
public fun bits_to_target(bits: u32): u256 {
    let exponent = bits >> 3*8;

    // extract coefficient path or get last 24 bit of `bits` 
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

public fun calc_next_block_difficulty(c: &LightClient, last_block: &LightBlock, _new_block_time: u32) : u32 {

    // TODO: handle lastHeader is nil or genesis block

    let blocks_pre_retarget = c.params().blocks_pre_retarget();
    
    // if this block not start a new retarget cycle
    if ((last_block.height() + 1) % blocks_pre_retarget != 0) {
	
	// TODO: support ReduceMinDifficulty params
	// if c.params().reduce_min_difficulty {
	//     ...
	//     new_block_time is using in this logic
	// }

	// Return previous block difficulty
	return last_block.header().bits()
    };

    // we compute a new difficulty
    // let first_block = last_block.relative_ancestor(blocks_pre_retarget - 1, c);
    let first_block = c.relative_ancestor(last_block, blocks_pre_retarget - 1);
    let acctual_timespan = last_block.header().timestamp() - first_block.header().timestamp();
    let mut adjusted_timespan: u64 = acctual_timespan as u64;
    
    if ((acctual_timespan as u64) < c.params().min_retarget_timespan()) {
	adjusted_timespan = c.params().min_retarget_timespan();
    } else if ((acctual_timespan as u64)> c.params().max_retarget_timespan()){
	adjusted_timespan = c.params().max_retarget_timespan();
    };

    // compute new target
    // You can check this blogs for more information
    // https://learnmeabitcoin.com/technical/mining/target
    let old_target = bits_to_target(first_block.header().bits());
    // TODO: ensure this one can't overflow
    let mut new_target = old_target * (adjusted_timespan as u256);
    // TODO: make this more sense.
    let second = 1000000000;
    let target_timespan = c.params().target_timespan() / second;
    new_target = new_target / (target_timespan as u256);
    
    if (new_target > c.params().power_limit()) {
	new_target = c.params().power_limit();
    };
    return target_to_bits(new_target)
}



/// ===== internal test ====
// TODO: Check best practice to improve test
#[test]
fun bytes_of_test() {
    assert!(bytes_of(0) == 0);
    assert!(bytes_of(7) == 1);
    assert!(bytes_of(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) == 32);
}

#[test]
/// get last 32 bits of number
fun get_last_32_bits_test() {
    assert!(get_last_32_bits(0) == 0);
    assert!(get_last_32_bits(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) == 0xffffffff);
    assert!(get_last_32_bits(0x0123456789) == 0x23456789);
}
