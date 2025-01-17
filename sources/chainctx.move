module btclc::chainctx;

public struct Params has key, store{
    id: UID,
    blocks_pre_retarget: u32
}

public fun blocks_pre_retarget(p: &Params) : u32{
    return p.blocks_pre_retarget
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
