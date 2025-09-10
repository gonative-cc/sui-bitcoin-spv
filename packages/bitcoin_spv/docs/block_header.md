
<a name="bitcoin_spv_block_header"></a>

# Module `bitcoin_spv::block_header`



-  [Struct `BlockHeader`](#bitcoin_spv_block_header_BlockHeader)
-  [Constants](#@Constants_0)
-  [Function `new_block_header`](#bitcoin_spv_block_header_new_block_header)
-  [Function `block_hash`](#bitcoin_spv_block_header_block_hash)
-  [Function `version`](#bitcoin_spv_block_header_version)
-  [Function `parent`](#bitcoin_spv_block_header_parent)
-  [Function `merkle_root`](#bitcoin_spv_block_header_merkle_root)
-  [Function `timestamp`](#bitcoin_spv_block_header_timestamp)
-  [Function `bits`](#bitcoin_spv_block_header_bits)
-  [Function `nonce`](#bitcoin_spv_block_header_nonce)
-  [Function `target`](#bitcoin_spv_block_header_target)
-  [Function `calc_work`](#bitcoin_spv_block_header_calc_work)
-  [Function `pow_check`](#bitcoin_spv_block_header_pow_check)
-  [Function `slice`](#bitcoin_spv_block_header_slice)


<pre><code><b>use</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math">bitcoin_spv::btc_math</a>;
<b>use</b> <a href="../bitcoin_spv/utils.md#bitcoin_spv_utils">bitcoin_spv::utils</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
</code></pre>



<a name="bitcoin_spv_block_header_BlockHeader"></a>

## Struct `BlockHeader`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>internal: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_spv_block_header_BLOCK_HEADER_SIZE"></a>



<pre><code><b>const</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BLOCK_HEADER_SIZE">BLOCK_HEADER_SIZE</a>: u64 = 80;
</code></pre>



<a name="bitcoin_spv_block_header_EInvalidBlockHeaderSize"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_EInvalidBlockHeaderSize">EInvalidBlockHeaderSize</a>: vector&lt;u8&gt; = b"The block header must be exactly 80 bytes long";
</code></pre>



<a name="bitcoin_spv_block_header_EPoW"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_EPoW">EPoW</a>: vector&lt;u8&gt; = b"The block hash does not meet the <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> difficulty (Proof-of-Work check failed)";
</code></pre>



<a name="bitcoin_spv_block_header_new_block_header"></a>

## Function `new_block_header`

New block header


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_new_block_header">new_block_header</a>(raw_block_header: vector&lt;u8&gt;): <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_new_block_header">new_block_header</a>(raw_block_header: vector&lt;u8&gt;): <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a> {
    <b>assert</b>!(raw_block_header.length() == <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BLOCK_HEADER_SIZE">BLOCK_HEADER_SIZE</a>, <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_EInvalidBlockHeaderSize">EInvalidBlockHeaderSize</a>);
    <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a> {
        internal: raw_block_header,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_block_hash"></a>

## Function `block_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_block_hash">block_hash</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_block_hash">block_hash</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    btc_hash(header.internal)
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_version"></a>

## Function `version`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_version">version</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_version">version</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u32 {
    to_u32(header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(0, 4))
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_parent"></a>

## Function `parent`

return parent block ID (hash)


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_parent">parent</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_parent">parent</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(4, 36)
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_merkle_root"></a>

## Function `merkle_root`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_merkle_root">merkle_root</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_merkle_root">merkle_root</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(36, 68)
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_timestamp"></a>

## Function `timestamp`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_timestamp">timestamp</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_timestamp">timestamp</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u32 {
    to_u32(header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(68, 72))
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_bits"></a>

## Function `bits`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_bits">bits</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_bits">bits</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u32 {
    to_u32(header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(72, 76))
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_nonce"></a>

## Function `nonce`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_nonce">nonce</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_nonce">nonce</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u32 {
    to_u32(header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(76, 80))
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_target"></a>

## Function `target`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u256 {
    bits_to_target(header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_bits">bits</a>())
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_calc_work"></a>

## Function `calc_work`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_calc_work">calc_work</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_calc_work">calc_work</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>): u256 {
    // We compute the total expected hashes or expected "<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_calc_work">calc_work</a>".
    //    <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_calc_work">calc_work</a> of header = 2**256 / (<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a>+1).
    // This is a very clever way to compute this value from bitcoin core. Comments from the bitcoin core:
    // We need to compute 2**256 / (bnTarget+1), but we can't represent 2**256
    // <b>as</b> it's too large <b>for</b> an arith_uint256. However, <b>as</b> 2**256 is at least <b>as</b> large
    // <b>as</b> bnTarget+1, it is equal to ((2**256 - bnTarget - 1) / (bnTarget+1)) + 1,
    // or ~bnTarget / (bnTarget+1) + 1.
    // More information: https://github.com/bitcoin/bitcoin/blob/28.x/src/chain.cpp#L139.
    //
    // A <b>move</b> language doesn't support ~ operator. However, we have 2**256 - 1 = 2**255 - 1 + 2*255;
    // so we have formula bellow:
    <b>let</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> = header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a>();
    <b>let</b> n255 = 1 &lt;&lt; 255;
    (n255 - 1 - <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> + n255) / (<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> + 1) + 1
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_pow_check"></a>

## Function `pow_check`

checks if the block headers meet PoW target requirements. Panics otherewise.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_pow_check">pow_check</a>(header: <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_pow_check">pow_check</a>(header: <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>) {
    <b>let</b> work = header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_block_hash">block_hash</a>();
    <b>let</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> = header.<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a>();
    <b>assert</b>!(<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_target">target</a> &gt;= to_u256(work), <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_EPoW">EPoW</a>);
}
</code></pre>



</details>

<a name="bitcoin_spv_block_header_slice"></a>

## Function `slice`



<pre><code><b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">bitcoin_spv::block_header::BlockHeader</a>, start: u64, end: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_slice">slice</a>(header: &<a href="../bitcoin_spv/block_header.md#bitcoin_spv_block_header_BlockHeader">BlockHeader</a>, start: u64, end: u64): vector&lt;u8&gt; {
    <a href="../bitcoin_spv/utils.md#bitcoin_spv_utils_slice">utils::slice</a>(header.internal, start, end)
}
</code></pre>



</details>
