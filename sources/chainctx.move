module btclc::chainctx;

public struct Params has key, store{
    id: UID,
    blocks_pre_retarget: u32,
    target_timespan: u64,
    power_limit: u256,
}

public fun blocks_pre_retarget(p: &Params) : u32{
    return p.blocks_pre_retarget
}

public fun target_timespan(p: &Params): u64 {
    return p.target_timespan
}

public fun power_limit(p: &Params) : u256{
    return p.power_limit
}

public struct Chain has key, store{
    id: UID,
    params: Params
}

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
