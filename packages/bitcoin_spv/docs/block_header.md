
<a name="(bitcoin_spv=0x0)_block_header"></a>

# Module `(bitcoin_spv=0x0)::block_header`



-  [Constants](#@Constants_0)
-  [Function `target`](#(bitcoin_spv=0x0)_block_header_target)
-  [Function `calc_work`](#(bitcoin_spv=0x0)_block_header_calc_work)
-  [Function `pow_check`](#(bitcoin_spv=0x0)_block_header_pow_check)


<pre><code><b>use</b> (bitcoin_parser=0x0)::crypto;
<b>use</b> (bitcoin_parser=0x0)::encoding;
<b>use</b> (bitcoin_parser=0x0)::header;
<b>use</b> (bitcoin_parser=0x0)::reader;
<b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math">btc_math</a>;
<b>use</b> <a href="../dependencies/std/ascii.md#std_ascii">std::ascii</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/option.md#std_option">std::option</a>;
<b>use</b> <a href="../dependencies/std/string.md#std_string">std::string</a>;
<b>use</b> <a href="../dependencies/std/u256.md#std_u256">std::u256</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="(bitcoin_spv=0x0)_block_header_EPoW"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_EPoW">EPoW</a>: vector&lt;u8&gt; = b"The block hash does not meet the <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a> difficulty (Proof-of-Work check failed)";
</code></pre>



<a name="(bitcoin_spv=0x0)_block_header_target"></a>

## Function `target`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>(header: &(bitcoin_parser=0x0)::header::BlockHeader): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>(header: &BlockHeader): u256 {
    bits_to_target(header.bits())
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_block_header_calc_work"></a>

## Function `calc_work`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_calc_work">calc_work</a>(header: &(bitcoin_parser=0x0)::header::BlockHeader): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_calc_work">calc_work</a>(header: &BlockHeader): u256 {
    // We compute the total expected hashes or expected "<a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_calc_work">calc_work</a>".
    //    <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_calc_work">calc_work</a> of header = 2**256 / (<a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>+1).
    // This is a very clever way to compute this value from bitcoin core. Comments from the bitcoin core:
    // We need to compute 2**256 / (bnTarget+1), but we can't represent 2**256
    // <b>as</b> it's too large <b>for</b> an arith_uint256. However, <b>as</b> 2**256 is at least <b>as</b> large
    // <b>as</b> bnTarget+1, it is equal to ((2**256 - bnTarget - 1) / (bnTarget+1)) + 1,
    // or ~bnTarget / (bnTarget+1) + 1.
    // More information: https://github.com/bitcoin/bitcoin/blob/28.x/src/chain.cpp#L139.
    // we have bitwise_not is ~ operation in <b>move</b>
    <b>let</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a> = <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>(header);
    (<a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>.bitwise_not() / (<a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a> + 1)) + 1
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_block_header_pow_check"></a>

## Function `pow_check`

checks if the block headers meet PoW target requirements. Panics otherewise.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_pow_check">pow_check</a>(header: &(bitcoin_parser=0x0)::header::BlockHeader)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_pow_check">pow_check</a>(header: &BlockHeader) {
    <b>let</b> work = header.block_hash();
    <b>let</b> <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a> = <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a>(header);
    <b>assert</b>!(<a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_target">target</a> &gt;= to_u256(work), <a href="../bitcoin_spv/block_header.md#(bitcoin_spv=0x0)_block_header_EPoW">EPoW</a>);
}
</code></pre>



</details>
