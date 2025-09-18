
<a name="bitcoin_parser_header"></a>

# Module `bitcoin_parser::header`



-  [Struct `BlockHeader`](#bitcoin_parser_header_BlockHeader)
-  [Constants](#@Constants_0)
-  [Function `new`](#bitcoin_parser_header_new)
-  [Function `block_hash`](#bitcoin_parser_header_block_hash)
-  [Function `version`](#bitcoin_parser_header_version)
-  [Function `parent`](#bitcoin_parser_header_parent)
-  [Function `merkle_root`](#bitcoin_parser_header_merkle_root)
-  [Function `timestamp`](#bitcoin_parser_header_timestamp)
-  [Function `bits`](#bitcoin_parser_header_bits)
-  [Function `nonce`](#bitcoin_parser_header_nonce)


<pre><code><b>use</b> <a href="../bitcoin_parser/crypto.md#bitcoin_parser_crypto">bitcoin_parser::crypto</a>;
<b>use</b> <a href="../bitcoin_parser/encoding.md#bitcoin_parser_encoding">bitcoin_parser::encoding</a>;
<b>use</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader">bitcoin_parser::reader</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
</code></pre>



<a name="bitcoin_parser_header_BlockHeader"></a>

## Struct `BlockHeader`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_version">version</a>: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_parent">parent</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_merkle_root">merkle_root</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_timestamp">timestamp</a>: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_bits">bits</a>: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_nonce">nonce</a>: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_parser/header.md#bitcoin_parser_header_block_hash">block_hash</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_parser_header_BLOCK_HEADER_SIZE"></a>



<pre><code><b>const</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BLOCK_HEADER_SIZE">BLOCK_HEADER_SIZE</a>: u64 = 80;
</code></pre>



<a name="bitcoin_parser_header_EInvalidBlockHeaderSize"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_EInvalidBlockHeaderSize">EInvalidBlockHeaderSize</a>: vector&lt;u8&gt; = b"The <a href="../bitcoin_parser/block.md#bitcoin_parser_block">block</a> <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a> must be exactly 80 bytes long";
</code></pre>



<a name="bitcoin_parser_header_new"></a>

## Function `new`

New block header


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_new">new</a>(raw_block_header: vector&lt;u8&gt;): <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_new">new</a>(raw_block_header: vector&lt;u8&gt;): <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a> {
    <b>assert</b>!(raw_block_header.length() == <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BLOCK_HEADER_SIZE">BLOCK_HEADER_SIZE</a>, <a href="../bitcoin_parser/header.md#bitcoin_parser_header_EInvalidBlockHeaderSize">EInvalidBlockHeaderSize</a>);
    <b>let</b> <b>mut</b> r = <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_new">reader::new</a>(raw_block_header);
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a> {
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_version">version</a>: r.read_u32(),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_parent">parent</a>: r.read(32),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_merkle_root">merkle_root</a>: r.read(32),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_timestamp">timestamp</a>: r.read_u32(),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_bits">bits</a>: r.read_u32(),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_nonce">nonce</a>: r.read_u32(),
        <a href="../bitcoin_parser/header.md#bitcoin_parser_header_block_hash">block_hash</a>: hash256(raw_block_header),
    }
}
</code></pre>



</details>

<a name="bitcoin_parser_header_block_hash"></a>

## Function `block_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_block_hash">block_hash</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_block_hash">block_hash</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_block_hash">block_hash</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_version"></a>

## Function `version`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_version">version</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_version">version</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): u32 {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_version">version</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_parent"></a>

## Function `parent`

return parent block ID (hash)


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_parent">parent</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_parent">parent</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_parent">parent</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_merkle_root"></a>

## Function `merkle_root`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_merkle_root">merkle_root</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_merkle_root">merkle_root</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): vector&lt;u8&gt; {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_merkle_root">merkle_root</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_timestamp"></a>

## Function `timestamp`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_timestamp">timestamp</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_timestamp">timestamp</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): u32 {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_timestamp">timestamp</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_bits"></a>

## Function `bits`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_bits">bits</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_bits">bits</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): u32 {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_bits">bits</a>
}
</code></pre>



</details>

<a name="bitcoin_parser_header_nonce"></a>

## Function `nonce`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_nonce">nonce</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/header.md#bitcoin_parser_header_nonce">nonce</a>(<a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>: &<a href="../bitcoin_parser/header.md#bitcoin_parser_header_BlockHeader">BlockHeader</a>): u32 {
    <a href="../bitcoin_parser/header.md#bitcoin_parser_header">header</a>.<a href="../bitcoin_parser/header.md#bitcoin_parser_header_nonce">nonce</a>
}
</code></pre>



</details>
