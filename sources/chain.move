module bitcoin_spv::chain;

use sui::dynamic_object_field as dof;
use bitcoin_spv::block_header::LightBlock;



/// === BTC config parameters ===
public struct Params has key, store{
    // TODO: Implement full parameters
    id: UID,
    blocks_pre_retarget: u32,
    target_timespan: u64,
    power_limit: u256,
}

/// === Blockchain storage struct use dynamicc object field ===
// TODO: should we rename this to BTCLightClient
public struct Chain has key, store{
    id: UID,
    params: Params
}

/// === Query data in Params struct ===

public fun blocks_pre_retarget(p: &Params) : u32{
    return p.blocks_pre_retarget
}

public fun target_timespan(p: &Params): u64 {
    return p.target_timespan
}

public fun power_limit(p: &Params) : u256{
    return p.power_limit
}

// === Query data in Chain structs ===
public fun params(c: &Chain): &Params {
    return &c.params
}

public fun id(c: &Chain): &UID {
    return &c.id
}

// TODO: complete this function
public fun min_retarget_timespan(_: &Chain) : u64 {
    return 0
}

public fun max_retarget_timespan(_: &Chain) : u64 {
    return 0
}

/// Query ancestor light block with light block `lb`  have `distance` between their height
public fun relative_ancestor(c: &Chain, lb: &LightBlock, distance: u32): &LightBlock {
    let ancestor_height: u32 = lb.height() - distance;
    
    let ancestor: &LightBlock = dof::borrow(c.id(), ancestor_height);
    return ancestor
}
