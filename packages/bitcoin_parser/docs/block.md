
<a name="bitcoin_parser_block"></a>

# Module `bitcoin_parser::block`



-  [Struct `Block`](#bitcoin_parser_block_Block)
-  [Function `new`](#bitcoin_parser_block_new)
-  [Function `txns`](#bitcoin_parser_block_txns)
-  [Function `header`](#bitcoin_parser_block_header)


<pre><code><b>use</b> <a href="../bitcoin_parser/crypto.md#bitcoin_parser_crypto">bitcoin_parser::crypto</a>;
<b>use</b> <a href="../bitcoin_parser/encoding.md#bitcoin_parser_encoding">bitcoin_parser::encoding</a>;
<b>use</b> <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header">bitcoin_parser::header</a>;
<b>use</b> <a href="../bitcoin_parser/input.md#bitcoin_parser_input">bitcoin_parser::input</a>;
<b>use</b> <a href="../bitcoin_parser/output.md#bitcoin_parser_output">bitcoin_parser::output</a>;
<b>use</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader">bitcoin_parser::reader</a>;
<b>use</b> <a href="../bitcoin_parser/tx.md#bitcoin_parser_tx">bitcoin_parser::tx</a>;
<b>use</b> <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils">bitcoin_parser::vector_utils</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/option.md#std_option">std::option</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="bitcoin_parser_block_Block"></a>

## Struct `Block`

A block is a collection of all transactions in the BTC block


<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">Block</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>block_header: <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a></code>
</dt>
<dd>
</dd>
<dt>
<code>transactions: vector&lt;<a href="../bitcoin_parser/tx.md#bitcoin_parser_tx_Transaction">bitcoin_parser::tx::Transaction</a>&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="bitcoin_parser_block_new"></a>

## Function `new`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block.md#bitcoin_parser_block_new">new</a>(raw_block: vector&lt;u8&gt;): <a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">bitcoin_parser::block::Block</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block.md#bitcoin_parser_block_new">new</a>(raw_block: vector&lt;u8&gt;): <a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">Block</a> {
    <b>let</b> <b>mut</b> r = <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_new">reader::new</a>(raw_block);
    <b>let</b> block_header = <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header_new">header::new</a>(r.read(80));
    <b>let</b> number_tx = r.read_compact_size();
    <b>let</b> <b>mut</b> transactions = vector[];
    number_tx.do!(|_| {
        transactions.push_back(<a href="../bitcoin_parser/tx.md#bitcoin_parser_tx_deserialize">tx::deserialize</a>(&<b>mut</b> r));
    });
    <a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">Block</a> {
        block_header,
        transactions,
    }
}
</code></pre>



</details>

<a name="bitcoin_parser_block_txns"></a>

## Function `txns`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block.md#bitcoin_parser_block_txns">txns</a>(b: &<a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">bitcoin_parser::block::Block</a>): vector&lt;<a href="../bitcoin_parser/tx.md#bitcoin_parser_tx_Transaction">bitcoin_parser::tx::Transaction</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block.md#bitcoin_parser_block_txns">txns</a>(b: &<a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">Block</a>): vector&lt;Transaction&gt; {
    b.transactions
}
</code></pre>



</details>

<a name="bitcoin_parser_block_header"></a>

## Function `header`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header">header</a>(b: &<a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">bitcoin_parser::block::Block</a>): <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header_BlockHeader">bitcoin_parser::header::BlockHeader</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/block_header.md#bitcoin_parser_header">header</a>(b: &<a href="../bitcoin_parser/block.md#bitcoin_parser_block_Block">Block</a>): BlockHeader {
    b.block_header
}
</code></pre>



</details>
