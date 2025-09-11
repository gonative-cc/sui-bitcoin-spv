
<a name="btc_parser_header"></a>

# Module `btc_parser::header`



-  [Struct `BlockHeader`](#btc_parser_header_BlockHeader)
-  [Function `new`](#btc_parser_header_new)
-  [Function `block_hash`](#btc_parser_header_block_hash)


<pre><code><b>use</b> <a href="../btc_parser/crypto.md#btc_parser_crypto">btc_parser::crypto</a>;
<b>use</b> <a href="../btc_parser/encoding.md#btc_parser_encoding">btc_parser::encoding</a>;
<b>use</b> <a href="../btc_parser/reader.md#btc_parser_reader">btc_parser::reader</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
</code></pre>



<a name="btc_parser_header_BlockHeader"></a>

## Struct `BlockHeader`



<pre><code><b>public</b> <b>struct</b> <a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">BlockHeader</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>version: u32</code>
</dt>
<dd>
</dd>
<dt>
<code>parent: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>merkle_root: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>timestamp: u32</code>
</dt>
<dd>
</dd>
<dt>
<code>bits: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/block_header.md#btc_parser_header_block_hash">block_hash</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="btc_parser_header_new"></a>

## Function `new`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/block_header.md#btc_parser_header_new">new</a>(raw_block_header: vector&lt;u8&gt;): <a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">btc_parser::header::BlockHeader</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/block_header.md#btc_parser_header_new">new</a>(raw_block_header: vector&lt;u8&gt;): <a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">BlockHeader</a> {
    <b>let</b> <b>mut</b> r = <a href="../btc_parser/reader.md#btc_parser_reader_new">reader::new</a>(raw_block_header);
    <a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">BlockHeader</a> {
        version: r.read_u32(),
        parent: r.read(32),
        merkle_root: r.read(32),
        timestamp: r.read_u32(),
        bits: r.read_u32(),
        <a href="../btc_parser/block_header.md#btc_parser_header_block_hash">block_hash</a>: hash256(raw_block_header),
    }
}
</code></pre>



</details>

<a name="btc_parser_header_block_hash"></a>

## Function `block_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/block_header.md#btc_parser_header_block_hash">block_hash</a>(h: &<a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">btc_parser::header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/block_header.md#btc_parser_header_block_hash">block_hash</a>(h: &<a href="../btc_parser/block_header.md#btc_parser_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    h.<a href="../btc_parser/block_header.md#btc_parser_header_block_hash">block_hash</a>
}
</code></pre>



</details>
