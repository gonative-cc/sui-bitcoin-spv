module btclc::chainctx;


public struct Params has key, store{
    id: UID
}

public struct Chain has key, store{
    id: UID,
    params: Params
}

