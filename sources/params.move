module bitcoin_spv::params;
use bitcoin_spv::btc_math::target_to_bits;

public struct Params has store{
    power_limit: u256,
    power_limit_bits: u32,
    blocks_pre_retarget: u64,
    /// time in seconds when we update the target
    target_timespan: u64,
    pow_no_retargeting: bool,
    reduce_min_difficulty: bool, // for Bitcoin testnet
    min_diff_reduction_time: u32,  // time in seconds
}

// default params for bitcoin mainnet
public fun mainnet(): Params {
    Params {
        power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        power_limit_bits: 0x1d00ffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10, // ~ 2 weeks.
        pow_no_retargeting: false,
        reduce_min_difficulty: false,
        min_diff_reduction_time: 0,
    }
}

// default params for bitcoin testnet
public fun testnet(): Params {
    Params {
        power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        power_limit_bits: 0x1d00ffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10, // ~ 2 weeks.
        pow_no_retargeting: false,
        reduce_min_difficulty: true,
        min_diff_reduction_time: 20 * 60, // 20 minutes
    }
}

// default params for bitcoin regtest
// https://github.com/bitcoin/bitcoin/blob/v28.1/src/kernel/chainparams.cpp#L523
public fun regtest(): Params {
    Params {
        power_limit: 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        power_limit_bits: 0x207fffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10,  // ~ 2 weeks.
        pow_no_retargeting: true,
        reduce_min_difficulty: false,
        min_diff_reduction_time: 20 * 60, // 20 minutes
    }
}

public fun blocks_pre_retarget(p: &Params) : u64 {
    p.blocks_pre_retarget
}

public fun power_limit(p: &Params): u256 {
    p.power_limit
}

public fun power_limit_bits(p: &Params): u32 {
    p.power_limit_bits
}

public fun target_timespan(p: &Params): u64 {
    p.target_timespan
}

public fun pow_no_retargeting(p: &Params): bool {
    p.pow_no_retargeting
}

public fun reduce_min_difficulty(p: &Params): bool {
    p.reduce_min_difficulty
}

public fun min_diff_reduction_time(p: &Params): u32 {
    p.min_diff_reduction_time
}
