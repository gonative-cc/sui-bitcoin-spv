
<a name="(bitcoin_spv=0x0)_light_client"></a>

# Module `(bitcoin_spv=0x0)::light_client`



-  [Struct `NewLightClientEvent`](#(bitcoin_spv=0x0)_light_client_NewLightClientEvent)
-  [Struct `InsertedHeadersEvent`](#(bitcoin_spv=0x0)_light_client_InsertedHeadersEvent)
-  [Struct `ForkBeyondFinalityEvent`](#(bitcoin_spv=0x0)_light_client_ForkBeyondFinalityEvent)
-  [Struct `LightClient`](#(bitcoin_spv=0x0)_light_client_LightClient)
-  [Constants](#@Constants_0)
-  [Function `init`](#(bitcoin_spv=0x0)_light_client_init)
-  [Function `new_light_client`](#(bitcoin_spv=0x0)_light_client_new_light_client)
-  [Function `initialize_light_client`](#(bitcoin_spv=0x0)_light_client_initialize_light_client)
-  [Function `insert_headers`](#(bitcoin_spv=0x0)_light_client_insert_headers)
-  [Function `insert_light_block`](#(bitcoin_spv=0x0)_light_client_insert_light_block)
-  [Function `remove_light_block`](#(bitcoin_spv=0x0)_light_client_remove_light_block)
-  [Function `set_block_hash_by_height`](#(bitcoin_spv=0x0)_light_client_set_block_hash_by_height)
-  [Function `append_block`](#(bitcoin_spv=0x0)_light_client_append_block)
-  [Function `insert_header`](#(bitcoin_spv=0x0)_light_client_insert_header)
-  [Function `extend_chain`](#(bitcoin_spv=0x0)_light_client_extend_chain)
-  [Function `cleanup`](#(bitcoin_spv=0x0)_light_client_cleanup)
-  [Function `head_height`](#(bitcoin_spv=0x0)_light_client_head_height)
-  [Function `head_hash`](#(bitcoin_spv=0x0)_light_client_head_hash)
-  [Function `head`](#(bitcoin_spv=0x0)_light_client_head)
-  [Function `finalized_height`](#(bitcoin_spv=0x0)_light_client_finalized_height)
-  [Function `verify_tx`](#(bitcoin_spv=0x0)_light_client_verify_tx)
-  [Function `params`](#(bitcoin_spv=0x0)_light_client_params)
-  [Function `client_id`](#(bitcoin_spv=0x0)_light_client_client_id)
-  [Function `relative_ancestor`](#(bitcoin_spv=0x0)_light_client_relative_ancestor)
-  [Function `calc_next_required_difficulty`](#(bitcoin_spv=0x0)_light_client_calc_next_required_difficulty)
-  [Function `calc_past_median_time`](#(bitcoin_spv=0x0)_light_client_calc_past_median_time)
-  [Function `get_light_block_by_hash`](#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash)
-  [Function `exist`](#(bitcoin_spv=0x0)_light_client_exist)
-  [Function `get_block_hash_by_height`](#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height)
-  [Function `get_light_block_by_height`](#(bitcoin_spv=0x0)_light_client_get_light_block_by_height)
-  [Function `retarget_algorithm`](#(bitcoin_spv=0x0)_light_client_retarget_algorithm)
-  [Function `update_version`](#(bitcoin_spv=0x0)_light_client_update_version)


<pre><code><b>use</b> (bitcoin_parser=0x0)::crypto;
<b>use</b> (bitcoin_parser=0x0)::encoding;
<b>use</b> (bitcoin_parser=0x0)::header;
<b>use</b> (bitcoin_parser=0x0)::reader;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/header.md#(bitcoin_spv=0x0)_block_header">block_header</a>;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math">btc_math</a>;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree">merkle_tree</a>;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils">utils</a>;
<b>use</b> <a href="../dependencies/std/ascii.md#std_ascii">std::ascii</a>;
<b>use</b> <a href="../dependencies/std/bcs.md#std_bcs">std::bcs</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/option.md#std_option">std::option</a>;
<b>use</b> <a href="../dependencies/std/string.md#std_string">std::string</a>;
<b>use</b> <a href="../dependencies/std/u256.md#std_u256">std::u256</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
<b>use</b> <a href="../dependencies/sui/address.md#sui_address">sui::address</a>;
<b>use</b> <a href="../dependencies/sui/dynamic_field.md#sui_dynamic_field">sui::dynamic_field</a>;
<b>use</b> <a href="../dependencies/sui/event.md#sui_event">sui::event</a>;
<b>use</b> <a href="../dependencies/sui/hex.md#sui_hex">sui::hex</a>;
<b>use</b> <a href="../dependencies/sui/object.md#sui_object">sui::object</a>;
<b>use</b> <a href="../dependencies/sui/party.md#sui_party">sui::party</a>;
<b>use</b> <a href="../dependencies/sui/table.md#sui_table">sui::table</a>;
<b>use</b> <a href="../dependencies/sui/transfer.md#sui_transfer">sui::transfer</a>;
<b>use</b> <a href="../dependencies/sui/tx_context.md#sui_tx_context">sui::tx_context</a>;
<b>use</b> <a href="../dependencies/sui/vec_map.md#sui_vec_map">sui::vec_map</a>;
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_NewLightClientEvent"></a>

## Struct `NewLightClientEvent`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_NewLightClientEvent">NewLightClientEvent</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>light_client_id: <a href="../dependencies/sui/object.md#sui_object_ID">sui::object::ID</a></code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="(bitcoin_spv=0x0)_light_client_InsertedHeadersEvent"></a>

## Struct `InsertedHeadersEvent`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_InsertedHeadersEvent">InsertedHeadersEvent</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>chain_work: u256</code>
</dt>
<dd>
</dd>
<dt>
<code>is_forked: bool</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>: u64</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="(bitcoin_spv=0x0)_light_client_ForkBeyondFinalityEvent"></a>

## Struct `ForkBeyondFinalityEvent`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_ForkBeyondFinalityEvent">ForkBeyondFinalityEvent</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>parent_hash: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>parent_height: u64</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="(bitcoin_spv=0x0)_light_client_LightClient"></a>

## Struct `LightClient`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a> <b>has</b> key, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: <a href="../dependencies/sui/object.md#sui_object_UID">sui::object::UID</a></code>
</dt>
<dd>
</dd>
<dt>
<code>version: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>: (bitcoin_spv=0x0)::<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_Params">params::Params</a></code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>: u64</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>light_block_by_hash: <a href="../dependencies/sui/table.md#sui_table_Table">sui::table::Table</a>&lt;vector&lt;u8&gt;, (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>block_hash_by_height: <a href="../dependencies/sui/table.md#sui_table_Table">sui::table::Table</a>&lt;u64, vector&lt;u8&gt;&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>confirmation_depth: u64</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="(bitcoin_spv=0x0)_light_client_VERSION"></a>

Package version


<pre><code><b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>: u32 = 1;
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EWrongParentBlock"></a>

=== Errors ===


<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EWrongParentBlock">EWrongParentBlock</a>: vector&lt;u8&gt; = b"New parent of the new header parent doesn't match the expected parent block hash";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EDifficultyNotMatch"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EDifficultyNotMatch">EDifficultyNotMatch</a>: vector&lt;u8&gt; = b"The difficulty bits in the header do not match the calculated difficulty";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_ETimeTooOld"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_ETimeTooOld">ETimeTooOld</a>: vector&lt;u8&gt; = b"The timestamp of the block is older than the median of the last 11 blocks";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EHeaderListIsEmpty"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EHeaderListIsEmpty">EHeaderListIsEmpty</a>: vector&lt;u8&gt; = b"The provided list of headers is empty";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EBlockNotFound"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EBlockNotFound">EBlockNotFound</a>: vector&lt;u8&gt; = b"The specified block could not be found in the light client";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EForkChainWorkTooSmall"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EForkChainWorkTooSmall">EForkChainWorkTooSmall</a>: vector&lt;u8&gt; = b"The proposed fork <b>has</b> less work than the current chain";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EInvalidStartHeight"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EInvalidStartHeight">EInvalidStartHeight</a>: vector&lt;u8&gt; = b"The start height must be a multiple of the retarget period (e.g 2016 <b>for</b> mainnet)";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EVersionMismatch"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>: vector&lt;u8&gt; = b"The package <b>has</b> been updated. You are using a wrong version";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_EAlreadyUpdated"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EAlreadyUpdated">EAlreadyUpdated</a>: vector&lt;u8&gt; = b"The package version <b>has</b> been already updated to the latest one";
</code></pre>



<a name="(bitcoin_spv=0x0)_light_client_init"></a>

## Function `init`



<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_init">init</a>(_ctx: &<b>mut</b> <a href="../dependencies/sui/tx_context.md#sui_tx_context_TxContext">sui::tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_init">init</a>(_ctx: &<b>mut</b> TxContext) {}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_new_light_client"></a>

## Function `new_light_client`

LightClient constructor. Create light client and verify data.
*params: Btc network params. Check the params module
*start_height: height of the first trusted header
*trusted_headers: List of trusted headers in hex format.
*parent_chain_work: chain_work at parent block of start_height block.
*confirmation_depth: the depth from which a block is considered <code>confirmed</code>.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_new_light_client">new_light_client</a>(<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>: (bitcoin_spv=0x0)::<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_Params">params::Params</a>, start_height: u64, trusted_headers: vector&lt;(bitcoin_parser=0x0)::header::BlockHeader&gt;, parent_chain_work: u256, confirmation_depth: u64, ctx: &<b>mut</b> <a href="../dependencies/sui/tx_context.md#sui_tx_context_TxContext">sui::tx_context::TxContext</a>): (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_new_light_client">new_light_client</a>(
    <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>: Params,
    start_height: u64,
    trusted_headers: vector&lt;BlockHeader&gt;,
    parent_chain_work: u256,
    confirmation_depth: u64,
    ctx: &<b>mut</b> TxContext,
): <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a> {
    <b>let</b> <b>mut</b> lc = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a> {
        id: object::new(ctx),
        version: <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>,
        <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>: <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>,
        <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>: 0,
        <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: vector[],
        light_block_by_hash: table::new(ctx),
        block_hash_by_height: table::new(ctx),
        confirmation_depth,
    };
    <b>let</b> <b>mut</b> parent_chain_work = parent_chain_work;
    <b>if</b> (!trusted_headers.is_empty()) {
        <b>let</b> <b>mut</b> height = start_height;
        <b>let</b> <b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a> = vector[];
        trusted_headers.do!(|header| {
            <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a> = header.block_hash();
            <b>let</b> current_chain_work = parent_chain_work + header.calc_work();
            <b>let</b> <a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a> = new_light_block(height, header, current_chain_work);
            lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_set_block_hash_by_height">set_block_hash_by_height</a>(height, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>);
            lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_light_block">insert_light_block</a>(<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>);
            height = height + 1;
            parent_chain_work = current_chain_work;
        });
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a> = height - 1;
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a> = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>;
    };
    lc
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_initialize_light_client"></a>

## Function `initialize_light_client`

Initializes Bitcoin light client by providing a trusted snapshot height and header.
Use <code><a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_initialize_light_client">initialize_light_client</a></code> to create and transfer object,
emitting an event.
network: 0 = mainnet, 1 = testnet, other = regtest
start_height: the height of the first trusted header
trusted_header: The list of trusted header in hex encode.
previous_chain_work: the chain_work at parent block of start_height block


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_initialize_light_client">initialize_light_client</a>(network: u8, start_height: u64, trusted_headers: vector&lt;(bitcoin_parser=0x0)::header::BlockHeader&gt;, parent_chain_work: u256, confirmation_depth: u64, ctx: &<b>mut</b> <a href="../dependencies/sui/tx_context.md#sui_tx_context_TxContext">sui::tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_initialize_light_client">initialize_light_client</a>(
    network: u8,
    start_height: u64,
    trusted_headers: vector&lt;BlockHeader&gt;,
    parent_chain_work: u256,
    confirmation_depth: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a> = match (network) {
        0 =&gt; <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_mainnet">params::mainnet</a>(),
        1 =&gt; <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_testnet">params::testnet</a>(),
        _ =&gt; <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_regtest">params::regtest</a>(),
    };
    <b>assert</b>!(<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>.is_correct_init_height(start_height), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EInvalidStartHeight">EInvalidStartHeight</a>);
    <b>let</b> lc = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_new_light_client">new_light_client</a>(
        <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>,
        start_height,
        trusted_headers,
        parent_chain_work,
        confirmation_depth,
        ctx,
    );
    event::emit(<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_NewLightClientEvent">NewLightClientEvent</a> {
        light_client_id: object::id(&lc),
    });
    transfer::share_object(lc);
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_insert_headers"></a>

## Function `insert_headers`

Insert new headers to extend the LC chain. Fails if the included headers don't
create a heavier chain or fork.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_headers">insert_headers</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, headers: vector&lt;(bitcoin_parser=0x0)::header::BlockHeader&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_headers">insert_headers</a>(lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, headers: vector&lt;BlockHeader&gt;) {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    <b>assert</b>!(!headers.is_empty(), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EHeaderListIsEmpty">EHeaderListIsEmpty</a>);
    <b>let</b> first_header = headers[0];
    <b>let</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a> = *lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>();
    <b>let</b> <b>mut</b> is_forked = <b>false</b>;
    <b>if</b> (first_header.parent() == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>.header().block_hash()) {
        // extend current chain
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_extend_chain">extend_chain</a>(<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>, headers);
    } <b>else</b> {
        // handle a new fork
        <b>let</b> parent_id = first_header.parent();
        <b>assert</b>!(lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_exist">exist</a>(parent_id), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EBlockNotFound">EBlockNotFound</a>);
        <b>let</b> parent = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(parent_id);
        // NOTE: we can check here <b>if</b> the diff between current <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a> and the parent of
        // the proposed blockcheck is not bigger than the required finality.
        // We decide to not to do it to protect from deadlock:
        // * pro: we protect against double mint <b>for</b> nBTC etc...
        // * cons: we can have a deadlock
        <b>if</b> (parent.height() &gt;= lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_finalized_height">finalized_height</a>()) {
            event::emit(<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_ForkBeyondFinalityEvent">ForkBeyondFinalityEvent</a> {
                parent_hash: parent_id,
                parent_height: parent.height(),
            });
        };
        <b>let</b> current_chain_work = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>.chain_work();
        <b>let</b> current_block_hash = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>.header().block_hash();
        <b>let</b> fork_head = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_extend_chain">extend_chain</a>(*parent, headers);
        <b>let</b> fork_chain_work = fork_head.chain_work();
        <b>assert</b>!(current_chain_work &lt; fork_chain_work, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EForkChainWorkTooSmall">EForkChainWorkTooSmall</a>);
        // If transaction not <b>abort</b>. This is the current chain is less power than
        // the fork. We will update the fork to main chain and remove the old fork
        // notes: current_block_hash is hash of the old fork/chain in this case.
        // TODO(vu): Make it more simple.
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_cleanup">cleanup</a>(parent_id, current_block_hash);
        is_forked = <b>true</b>;
    };
    <b>let</b> b = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>();
    event::emit(<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_InsertedHeadersEvent">InsertedHeadersEvent</a> {
        chain_work: b.chain_work(),
        is_forked,
        <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>,
        <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>: lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>,
    });
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_insert_light_block"></a>

## Function `insert_light_block`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_light_block">insert_light_block</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, lb: (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_light_block">insert_light_block</a>(lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, lb: LightBlock) {
    <b>let</b> block_hash = lb.header().block_hash();
    lc.light_block_by_hash.add(block_hash, lb);
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_remove_light_block"></a>

## Function `remove_light_block`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_remove_light_block">remove_light_block</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, block_hash: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_remove_light_block">remove_light_block</a>(lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, block_hash: vector&lt;u8&gt;) {
    lc.light_block_by_hash.remove(block_hash);
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_set_block_hash_by_height"></a>

## Function `set_block_hash_by_height`

Maps height to block_hash, overwrites the block_hash (reorg) if height exists in table


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_set_block_hash_by_height">set_block_hash_by_height</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, height: u64, block_hash: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_set_block_hash_by_height">set_block_hash_by_height</a>(
    lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>,
    height: u64,
    block_hash: vector&lt;u8&gt;,
) {
    <b>if</b> (lc.block_hash_by_height.contains(height)) {
        <b>let</b> h_mut = lc.block_hash_by_height.borrow_mut(height);
        *h_mut = block_hash;
    } <b>else</b> {
        lc.block_hash_by_height.add(height, block_hash);
    }
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_append_block"></a>

## Function `append_block`

Appends light block to the current branch and overwrites the current blockchain head.
Must only be called when we know that we extend the current branch or if we control
the cleanup.


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_append_block">append_block</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, <a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>: (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_append_block">append_block</a>(lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, <a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>: LightBlock) {
    <b>let</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a> = <a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>.header().block_hash();
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_light_block">insert_light_block</a>(<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_set_block_hash_by_height">set_block_hash_by_height</a>(<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>.height(), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a> = <a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block">light_block</a>.height();
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a> = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>;
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_insert_header"></a>

## Function `insert_header`

Insert new header to bitcoin spv
* <code>parent</code>: hash of the parent block, must be already recorded in the light client.
NOTE: this function doesn't do fork checks and overwrites the current fork. So it must be
only called internally.


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_header">insert_header</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, parent: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>, header: (bitcoin_parser=0x0)::header::BlockHeader): (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_header">insert_header</a>(
    lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>,
    parent: &LightBlock,
    header: BlockHeader,
): LightBlock {
    <b>let</b> parent_header = parent.header();
    // verify new header
    // NOTE: we must provide `parent` to the function, to assure we have a chain - subsequent
    // headers must be connected.
    <b>assert</b>!(parent_header.block_hash() == header.parent(), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EWrongParentBlock">EWrongParentBlock</a>);
    // NOTE: see comment in the skip_difficulty_check function
    <b>if</b> (!lc.<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>().skip_difficulty_check()) {
        <b>let</b> next_block_difficulty = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_next_required_difficulty">calc_next_required_difficulty</a>(parent);
        <b>assert</b>!(next_block_difficulty == header.bits(), <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EDifficultyNotMatch">EDifficultyNotMatch</a>);
    };
    // we only check the case "A timestamp greater than the median time of the last 11 blocks".
    // because  network adjusted time requires a miners local time.
    // https://learnmeabitcoin.com/technical/block/time
    <b>let</b> median_time = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_past_median_time">calc_past_median_time</a>(parent);
    <b>assert</b>!(header.timestamp() &gt; median_time, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_ETimeTooOld">ETimeTooOld</a>);
    header.pow_check();
    // update new header
    <b>let</b> next_height = parent.height() + 1;
    <b>let</b> next_chain_work = parent.chain_work() + header.calc_work();
    <b>let</b> next_light_block = new_light_block(next_height, header, next_chain_work);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_append_block">append_block</a>(next_light_block);
    next_light_block
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_extend_chain"></a>

## Function `extend_chain`

Extends chain from the given <code>parent</code> by inserting new block headers.
Returns ID of the last inserted block header.
NOTE: we need to pass <code>parent</code> block to assure we are creating a chain. Consider the
following scenario, where headers that we insert don't form a chain:

A = {parent: Z}
Chain = X-Y-Z  // existing chain
headers = [A, A, A]

the insert would try to insert A multiple times:

X-Y-Z-A
|-A
|-A


<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_extend_chain">extend_chain</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, parent: (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>, headers: vector&lt;(bitcoin_parser=0x0)::header::BlockHeader&gt;): (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_extend_chain">extend_chain</a>(
    lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>,
    parent: LightBlock,
    headers: vector&lt;BlockHeader&gt;,
): LightBlock {
    headers.fold!(parent, |p, header| {
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_insert_header">insert_header</a>(&p, header)
    })
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_cleanup"></a>

## Function `cleanup`

Delete all blocks between head_hash to checkpoint_hash


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_cleanup">cleanup</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, checkpoint_hash: vector&lt;u8&gt;, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_cleanup">cleanup</a>(
    lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>,
    checkpoint_hash: vector&lt;u8&gt;,
    <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>: vector&lt;u8&gt;,
) {
    <b>let</b> <b>mut</b> block_hash = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>;
    <b>while</b> (checkpoint_hash != block_hash) {
        <b>let</b> previous_block_hash = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(block_hash).header().parent();
        lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_remove_light_block">remove_light_block</a>(block_hash);
        block_hash = previous_block_hash;
    }
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_head_height"></a>

## Function `head_height`

Returns height of the blockchain head (latest, not confirmed block).


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): u64 {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a>
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_head_hash"></a>

## Function `head_hash`

Returns height of the blockchain head (latest, not confirmed block).


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): vector&lt;u8&gt; {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_head"></a>

## Function `head`

Returns blockchain head light block (latest, not confirmed block).


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head">head</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): &LightBlock {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.light_block_by_hash.borrow(lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_hash">head_hash</a>)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_finalized_height"></a>

## Function `finalized_height`

Returns latest finalized_block height


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_finalized_height">finalized_height</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_finalized_height">finalized_height</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): u64 {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_head_height">head_height</a> - (lc.confirmation_depth - 1)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_verify_tx"></a>

## Function `verify_tx`

Verify a transaction has tx_id(32 bytes) inclusive in the block has height h.
proof is merkle proof for tx_id. This is a sha256(32 bytes) vector.
tx_index is index of transaction in block.
We use little endian encoding for all data.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_verify_tx">verify_tx</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, height: u64, tx_id: vector&lt;u8&gt;, proof: vector&lt;vector&lt;u8&gt;&gt;, tx_index: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_verify_tx">verify_tx</a>(
    lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>,
    height: u64,
    tx_id: vector&lt;u8&gt;,
    proof: vector&lt;vector&lt;u8&gt;&gt;,
    tx_index: u64,
): bool {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    // TODO: handle: light block/<a href="../bitcoin_spv/header.md#(bitcoin_spv=0x0)_block_header">block_header</a> not <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_exist">exist</a>.
    <b>if</b> (height &gt; lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_finalized_height">finalized_height</a>()) {
        <b>return</b> <b>false</b>
    };
    <b>let</b> block_hash = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height">get_block_hash_by_height</a>(height);
    <b>let</b> header = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(block_hash).header();
    <b>let</b> merkle_root = header.merkle_root();
    verify_merkle_proof(merkle_root, proof, tx_id, tx_index)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_params"></a>

## Function `params`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_Params">params::Params</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): &Params {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    &lc.<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_client_id"></a>

## Function `client_id`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_client_id">client_id</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>): &<a href="../dependencies/sui/object.md#sui_object_UID">sui::object::UID</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_client_id">client_id</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>): &UID {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    &lc.id
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_relative_ancestor"></a>

## Function `relative_ancestor`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_relative_ancestor">relative_ancestor</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, lb: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>, distance: u64): &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_relative_ancestor">relative_ancestor</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, lb: &LightBlock, distance: u64): &LightBlock {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    <b>let</b> ancestor_height = lb.height() - distance;
    <b>let</b> ancestor_block_hash = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height">get_block_hash_by_height</a>(ancestor_height);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(ancestor_block_hash)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_calc_next_required_difficulty"></a>

## Function `calc_next_required_difficulty`

The function calculates the required difficulty for a block that we want to add after
the <code>parent_block</code> (potentially fork).


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_next_required_difficulty">calc_next_required_difficulty</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, parent_block: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_next_required_difficulty">calc_next_required_difficulty</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, parent_block: &LightBlock): u32 {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    // reference from https://github.com/btcsuite/btcd/blob/master/blockchain/difficulty.go#L136
    <b>let</b> <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a> = lc.<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>();
    <b>let</b> blocks_pre_retarget = <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>.blocks_pre_retarget();
    <b>if</b> (<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>.pow_no_retargeting() || parent_block.height() == 0) {
        <b>return</b> <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>.power_limit_bits()
    };
    // <b>if</b> this block does not start a new retarget cycle
    <b>if</b> ((parent_block.height() + 1) % blocks_pre_retarget != 0) {
        // Return previous block difficulty
        <b>return</b> parent_block.header().bits()
    };
    // we compute a new difficulty <b>for</b> the new target cycle.
    // this target applies at block  height + 1
    <b>let</b> first_block = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_relative_ancestor">relative_ancestor</a>(parent_block, blocks_pre_retarget - 1);
    <b>let</b> first_header = first_block.header();
    <b>let</b> previous_target = first_header.target();
    <b>let</b> first_timestamp = first_header.timestamp() <b>as</b> u64;
    <b>let</b> last_timestamp = parent_block.header().timestamp() <b>as</b> u64;
    <b>let</b> new_target = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_retarget_algorithm">retarget_algorithm</a>(
        <a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params">params</a>,
        previous_target,
        first_timestamp,
        last_timestamp,
    );
    <b>let</b> new_bits = target_to_bits(new_target);
    new_bits
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_calc_past_median_time"></a>

## Function `calc_past_median_time`



<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_past_median_time">calc_past_median_time</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, lb: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_calc_past_median_time">calc_past_median_time</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, lb: &LightBlock): u32 {
    // Follow implementation from btcsuite/btcd
    // https://github.com/btcsuite/btcd/blob/bc6396ddfd097f93e2eaf0d1346ab80735eaa169/blockchain/blockindex.go#L312
    // https://learnmeabitcoin.com/technical/block/time
    <b>let</b> median_time_blocks = 11;
    <b>let</b> <b>mut</b> timestamps = vector[];
    <b>let</b> <b>mut</b> i = 0;
    <b>let</b> <b>mut</b> prev_lb = lb;
    <b>while</b> (i &lt; median_time_blocks) {
        timestamps.push_back(prev_lb.header().timestamp());
        <b>if</b> (!lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_exist">exist</a>(prev_lb.header().parent())) {
            <b>break</b>
        };
        prev_lb = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_relative_ancestor">relative_ancestor</a>(prev_lb, 1);
        i = i + 1;
    };
    <b>let</b> size = timestamps.length();
    nth_element(&<b>mut</b> timestamps, size / 2)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_get_light_block_by_hash"></a>

## Function `get_light_block_by_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, block_hash: vector&lt;u8&gt;): &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, block_hash: vector&lt;u8&gt;): &LightBlock {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.light_block_by_hash.borrow(block_hash)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_exist"></a>

## Function `exist`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_exist">exist</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, block_hash: vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_exist">exist</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, block_hash: vector&lt;u8&gt;): bool {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    lc.light_block_by_hash.contains(block_hash)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_get_block_hash_by_height"></a>

## Function `get_block_hash_by_height`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height">get_block_hash_by_height</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, height: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height">get_block_hash_by_height</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, height: u64): vector&lt;u8&gt; {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    // <b>copy</b> the block hash
    *lc.block_hash_by_height.borrow(height)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_get_light_block_by_height"></a>

## Function `get_light_block_by_height`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_height">get_light_block_by_height</a>(lc: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>, height: u64): &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_block.md#(bitcoin_spv=0x0)_light_block_LightBlock">light_block::LightBlock</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_height">get_light_block_by_height</a>(lc: &<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>, height: u64): &LightBlock {
    <b>assert</b>!(lc.version == <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EVersionMismatch">EVersionMismatch</a>);
    <b>let</b> block_hash = lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_block_hash_by_height">get_block_hash_by_height</a>(height);
    lc.<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_get_light_block_by_hash">get_light_block_by_hash</a>(block_hash)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_retarget_algorithm"></a>

## Function `retarget_algorithm`

Compute new target


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_retarget_algorithm">retarget_algorithm</a>(p: &(bitcoin_spv=0x0)::<a href="../bitcoin_spv/params.md#(bitcoin_spv=0x0)_params_Params">params::Params</a>, previous_target: u256, first_timestamp: u64, last_timestamp: u64): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_retarget_algorithm">retarget_algorithm</a>(
    p: &Params,
    previous_target: u256,
    first_timestamp: u64,
    last_timestamp: u64,
): u256 {
    <b>let</b> <b>mut</b> adjusted_timespan = last_timestamp - first_timestamp;
    <b>let</b> target_timespan = p.target_timespan();
    // target adjustment is based on the time diff from the target_timestamp. We have max and min value:
    // https://github.com/bitcoin/bitcoin/blob/v28.1/src/pow.cpp#L55
    // https://github.com/btcsuite/btcd/blob/v0.24.2/blockchain/difficulty.go#L184
    <b>let</b> min_timespan = target_timespan / 4;
    <b>let</b> max_timespan = target_timespan * 4;
    <b>if</b> (adjusted_timespan &gt; max_timespan) {
        adjusted_timespan = max_timespan;
    } <b>else</b> <b>if</b> (adjusted_timespan &lt; min_timespan) {
        adjusted_timespan = min_timespan;
    };
    // A trick from summa-tx/bitcoin-spv :D.
    // NB: high targets e.g. ffff0020 can cause overflows here
    // so we divide it by 256**2, then multiply by 256**2 later.
    // we know the target is evenly divisible by 256**2, so this isn't an issue
    // notes: 256*2 = (1 &lt;&lt; 16)
    <b>let</b> <b>mut</b> next_target = previous_target / (1 &lt;&lt; 16) * (adjusted_timespan <b>as</b> u256);
    next_target = next_target / (target_timespan <b>as</b> u256) * (1 &lt;&lt; 16);
    <b>if</b> (next_target &gt; p.power_limit()) {
        next_target = p.power_limit();
    };
    next_target
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_light_client_update_version"></a>

## Function `update_version`

Updates the light_client.version to the latest,
migrating the object to the latest package version


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_update_version">update_version</a>(lc: &<b>mut</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">light_client::LightClient</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_update_version">update_version</a>(lc: &<b>mut</b> <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_LightClient">LightClient</a>) {
    <b>assert</b>!(<a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a> &gt; lc.version, <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_EAlreadyUpdated">EAlreadyUpdated</a>);
    lc.version = <a href="../bitcoin_spv/light_client.md#(bitcoin_spv=0x0)_light_client_VERSION">VERSION</a>;
}
</code></pre>



</details>
