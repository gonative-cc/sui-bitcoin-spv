
<a name="btc_parser_input"></a>

# Module `btc_parser::input`



-  [Struct `Input`](#btc_parser_input_Input)
-  [Function `new`](#btc_parser_input_new)
-  [Function `tx_id`](#btc_parser_input_tx_id)
-  [Function `vout`](#btc_parser_input_vout)
-  [Function `script_sig`](#btc_parser_input_script_sig)
-  [Function `sequence`](#btc_parser_input_sequence)
-  [Function `decode`](#btc_parser_input_decode)
-  [Function `encode`](#btc_parser_input_encode)


<pre><code><b>use</b> <a href="../btc_parser/encoding.md#btc_parser_encoding">btc_parser::encoding</a>;
<b>use</b> <a href="../btc_parser/reader.md#btc_parser_reader">btc_parser::reader</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="btc_parser_input_Input"></a>

## Struct `Input`

Input in btc transaction


<pre><code><b>public</b> <b>struct</b> <a href="../btc_parser/input.md#btc_parser_input_Input">Input</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="btc_parser_input_new"></a>

## Function `new`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_new">new</a>(<a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>: vector&lt;u8&gt;, <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>: vector&lt;u8&gt;, <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>: vector&lt;u8&gt;, <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>: vector&lt;u8&gt;): <a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_new">new</a>(
    <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>: vector&lt;u8&gt;,
    <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>: vector&lt;u8&gt;,
    <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>: vector&lt;u8&gt;,
    <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>: vector&lt;u8&gt;,
): <a href="../btc_parser/input.md#btc_parser_input_Input">Input</a> {
    <a href="../btc_parser/input.md#btc_parser_input_Input">Input</a> {
        <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>,
        <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>,
        <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>,
        <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>,
    }
}
</code></pre>



</details>

<a name="btc_parser_input_tx_id"></a>

## Function `tx_id`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">Input</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>
}
</code></pre>



</details>

<a name="btc_parser_input_vout"></a>

## Function `vout`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">Input</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>
}
</code></pre>



</details>

<a name="btc_parser_input_script_sig"></a>

## Function `script_sig`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">Input</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>
}
</code></pre>



</details>

<a name="btc_parser_input_sequence"></a>

## Function `sequence`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">Input</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>
}
</code></pre>



</details>

<a name="btc_parser_input_decode"></a>

## Function `decode`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_decode">decode</a>(r: &<b>mut</b> <a href="../btc_parser/reader.md#btc_parser_reader_Reader">btc_parser::reader::Reader</a>): <a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_decode">decode</a>(r: &<b>mut</b> Reader): <a href="../btc_parser/input.md#btc_parser_input_Input">Input</a> {
    <b>let</b> <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a> = r.read(32);
    <b>let</b> <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a> = r.read(4);
    <b>let</b> script_sig_size = r.read_compact_size();
    <b>let</b> <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a> = r.read(script_sig_size);
    <b>let</b> <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a> = r.read(4);
    <a href="../btc_parser/input.md#btc_parser_input_Input">Input</a> {
        <a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>,
        <a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>,
        <a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>,
        <a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>,
    }
}
</code></pre>



</details>

<a name="btc_parser_input_encode"></a>

## Function `encode`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_encode">encode</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/input.md#btc_parser_input_encode">encode</a>(<a href="../btc_parser/input.md#btc_parser_input">input</a>: &<a href="../btc_parser/input.md#btc_parser_input_Input">Input</a>): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> raw_input = vector[];
    raw_input.append(<a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_tx_id">tx_id</a>);
    raw_input.append(<a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_vout">vout</a>);
    raw_input.append(u64_to_varint_bytes(<a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>.length()));
    raw_input.append(<a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_script_sig">script_sig</a>);
    raw_input.append(<a href="../btc_parser/input.md#btc_parser_input">input</a>.<a href="../btc_parser/input.md#btc_parser_input_sequence">sequence</a>);
    raw_input
}
</code></pre>



</details>
