// SPDX-License-Identifier: MPL-2.0

module bitcoin_spv::params;

public struct Params has store {
    power_limit: u256,
    power_limit_bits: u32,
    blocks_pre_retarget: u64,
    /// time in seconds when we update the target
    target_timespan: u64,
    pow_no_retargeting: bool,
    difficulty_adjustment: u8, // for Bitcoin testnet
}

const DifficultyAdjustment_Mainnet: u8 = 0; // mainnet
const DifficultyAdjustment_V3: u8 = 1; // tesetnet v3
const DifficultyAdjustment_Regtest: u8 = 2; // regtest


// default params for bitcoin mainnet
public fun mainnet(): Params {
    Params {
        power_limit: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        power_limit_bits: 0x1d00ffff,
        blocks_pre_retarget: 2016,
        target_timespan: 2016 * 60 * 10, // ~ 2 weeks.
        pow_no_retargeting: false,
        difficulty_adjustment: DifficultyAdjustment_Mainnet,
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
        difficulty_adjustment: DifficultyAdjustment_V3
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
        difficulty_adjustment: DifficultyAdjustment_Regtest
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

public(package) fun is_correct_init_height(p: &Params, h: u64): bool {
    p.blocks_pre_retarget() == 0 || h % p.blocks_pre_retarget() == 0
}

// Instruments the logic to not verify the difficulty check
// NOTE: Bitcoin testnet v3 has difficulty adjustment, that may checks many blocks
// in the past and go out of the loop limit. So we need to skip that computation.
public fun skip_difficulty_check(p: &Params): bool {
    p.difficulty_adjustment == DifficultyAdjustment_V3
}
