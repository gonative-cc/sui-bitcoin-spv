
<a name="btc_parser_output"></a>

# Module `btc_parser::output`



-  [Struct `Output`](#btc_parser_output_Output)
-  [Constants](#@Constants_0)
-  [Function `new`](#btc_parser_output_new)
-  [Function `amount_bytes`](#btc_parser_output_amount_bytes)
-  [Function `amount`](#btc_parser_output_amount)
-  [Function `script_pubkey`](#btc_parser_output_script_pubkey)
-  [Function `is_P2SH`](#btc_parser_output_is_P2SH)
-  [Function `is_P2WSH`](#btc_parser_output_is_P2WSH)
-  [Function `is_P2PHK`](#btc_parser_output_is_P2PHK)
-  [Function `is_op_return`](#btc_parser_output_is_op_return)
-  [Function `is_P2WPHK`](#btc_parser_output_is_P2WPHK)
-  [Function `is_taproot`](#btc_parser_output_is_taproot)
-  [Function `extract_public_key_hash`](#btc_parser_output_extract_public_key_hash)
-  [Function `extract_script_hash`](#btc_parser_output_extract_script_hash)
-  [Function `extract_witness_script_hash`](#btc_parser_output_extract_witness_script_hash)
-  [Function `extract_taproot`](#btc_parser_output_extract_taproot)
-  [Function `op_return`](#btc_parser_output_op_return)
-  [Function `decode`](#btc_parser_output_decode)
-  [Function `encode`](#btc_parser_output_encode)


<pre><code><b>use</b> <a href="../btc_parser/encoding.md#btc_parser_encoding">btc_parser::encoding</a>;
<b>use</b> <a href="../btc_parser/reader.md#btc_parser_reader">btc_parser::reader</a>;
<b>use</b> <a href="../btc_parser/vector_utils.md#btc_parser_vector_utils">btc_parser::vector_utils</a>;
<b>use</b> <a href="../dependencies/std/option.md#std_option">std::option</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="btc_parser_output_Output"></a>

## Struct `Output`

Output in btc transaction


<pre><code><b>public</b> <b>struct</b> <a href="../btc_parser/output.md#btc_parser_output_Output">Output</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>: u64</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="btc_parser_output_OP_0"></a>

An empty array of bytes is pushed onto the stack. (This is not a no-op: an item is added to the stack.)


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_0">OP_0</a>: u8 = 0;
</code></pre>



<a name="btc_parser_output_OP_1"></a>



<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_1">OP_1</a>: u8 = 81;
</code></pre>



<a name="btc_parser_output_OP_DUP"></a>

Duplicates the top stack item


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_DUP">OP_DUP</a>: u8 = 118;
</code></pre>



<a name="btc_parser_output_OP_HASH160"></a>

Pop the top stack item and push its RIPEMD(SHA256(top item)) hash


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_HASH160">OP_HASH160</a>: u8 = 169;
</code></pre>



<a name="btc_parser_output_OP_DATA_20"></a>

Push the next 20 bytes as an array onto the stack


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_20">OP_DATA_20</a>: u8 = 20;
</code></pre>



<a name="btc_parser_output_OP_DATA_32"></a>



<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_32">OP_DATA_32</a>: u8 = 32;
</code></pre>



<a name="btc_parser_output_OP_EQUAL"></a>



<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_EQUAL">OP_EQUAL</a>: u8 = 135;
</code></pre>



<a name="btc_parser_output_OP_EQUALVERIFY"></a>

Returns success if the inputs are exactly equal, failure otherwise


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_EQUALVERIFY">OP_EQUALVERIFY</a>: u8 = 136;
</code></pre>



<a name="btc_parser_output_OP_CHECKSIG"></a>

https://en.bitcoin.it/wiki/OP_CHECKSIG pushing 1/0 for success/failure


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_CHECKSIG">OP_CHECKSIG</a>: u8 = 172;
</code></pre>



<a name="btc_parser_output_OP_RETURN"></a>

nulldata script


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a>: u8 = 106;
</code></pre>



<a name="btc_parser_output_OP_PUSHDATA4"></a>

Read the next 4 bytes as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA4">OP_PUSHDATA4</a>: u8 = 78;
</code></pre>



<a name="btc_parser_output_OP_PUSHDATA2"></a>

Read the next 2 bytes as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA2">OP_PUSHDATA2</a>: u8 = 77;
</code></pre>



<a name="btc_parser_output_OP_PUSHDATA1"></a>

Read the next byte as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA1">OP_PUSHDATA1</a>: u8 = 76;
</code></pre>



<a name="btc_parser_output_OP_DATA_75"></a>

Push the next 75 bytes onto the stack.


<pre><code><b>const</b> <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_75">OP_DATA_75</a>: u8 = 75;
</code></pre>



<a name="btc_parser_output_new"></a>

## Function `new`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_new">new</a>(<a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>: u64, <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>: vector&lt;u8&gt;): <a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_new">new</a>(<a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>: u64, <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>: vector&lt;u8&gt;): <a href="../btc_parser/output.md#btc_parser_output_Output">Output</a> {
    <a href="../btc_parser/output.md#btc_parser_output_Output">Output</a> {
        <a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>,
        <a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>: u64_to_le_bytes(<a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>),
        <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>,
    }
}
</code></pre>



</details>

<a name="btc_parser_output_amount_bytes"></a>

## Function `amount_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>
}
</code></pre>



</details>

<a name="btc_parser_output_amount"></a>

## Function `amount`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): u64 {
    <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>
}
</code></pre>



</details>

<a name="btc_parser_output_script_pubkey"></a>

## Function `script_pubkey`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_P2SH"></a>

## Function `is_P2SH`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2SH">is_P2SH</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2SH">is_P2SH</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>();
    script.length() == 23 &&
	script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_HASH160">OP_HASH160</a> &&
	script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_20">OP_DATA_20</a> &&
	script[22] == <a href="../btc_parser/output.md#btc_parser_output_OP_EQUAL">OP_EQUAL</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_P2WSH"></a>

## Function `is_P2WSH`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2WSH">is_P2WSH</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2WSH">is_P2WSH</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>();
    script.length() == 34 &&
	script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_0">OP_0</a> &&
	script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_32">OP_DATA_32</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_P2PHK"></a>

## Function `is_P2PHK`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2PHK">is_P2PHK</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2PHK">is_P2PHK</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>();
    script.length() == 25 &&
		script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_DUP">OP_DUP</a> &&
		script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_HASH160">OP_HASH160</a> &&
		script[2] == <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_20">OP_DATA_20</a> &&
		script[23] == <a href="../btc_parser/output.md#btc_parser_output_OP_EQUALVERIFY">OP_EQUALVERIFY</a> &&
		script[24] == <a href="../btc_parser/output.md#btc_parser_output_OP_CHECKSIG">OP_CHECKSIG</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_op_return"></a>

## Function `is_op_return`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_op_return">is_op_return</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_op_return">is_op_return</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    script.length() &gt; 0 && script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_P2WPHK"></a>

## Function `is_P2WPHK`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2WPHK">is_P2WPHK</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_P2WPHK">is_P2WPHK</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    script.length() == 22 &&
        script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_0">OP_0</a> &&
        script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_20">OP_DATA_20</a>
}
</code></pre>



</details>

<a name="btc_parser_output_is_taproot"></a>

## Function `is_taproot`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_taproot">is_taproot</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_is_taproot">is_taproot</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): bool {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    script.length() == 34 &&
	script[0] == <a href="../btc_parser/output.md#btc_parser_output_OP_1">OP_1</a> &&
	script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_32">OP_DATA_32</a>
}
</code></pre>



</details>

<a name="btc_parser_output_extract_public_key_hash"></a>

## Function `extract_public_key_hash`

extracts public key hash (PKH) from the output in P2PHK or P2WPKH
returns an empty vector in case it was not able to extract it


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_public_key_hash">extract_public_key_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_public_key_hash">extract_public_key_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): Option&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    <b>if</b> (<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_is_P2PHK">is_P2PHK</a>()) {
        <b>return</b> option::some(vector_slice(&script, 3, 23))
    } <b>else</b> <b>if</b> (<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_is_P2WPHK">is_P2WPHK</a>()) {
        <b>return</b> option::some(vector_slice(&script, 2, 22))
    };
    option::none()
}
</code></pre>



</details>

<a name="btc_parser_output_extract_script_hash"></a>

## Function `extract_script_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_script_hash">extract_script_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_script_hash">extract_script_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): Option&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    <b>if</b> (<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_is_P2SH">is_P2SH</a>()) {
        option::some(vector_slice(&script, 2, 22))
    } <b>else</b> {
        option::none()
    }
}
</code></pre>



</details>

<a name="btc_parser_output_extract_witness_script_hash"></a>

## Function `extract_witness_script_hash`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_witness_script_hash">extract_witness_script_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_witness_script_hash">extract_witness_script_hash</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): Option&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    <b>if</b> (<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_is_P2WSH">is_P2WSH</a>()) {
        option::some(vector_slice(&script, 2, 34))
    } <b>else</b> {
        option::none()
    }
}
</code></pre>



</details>

<a name="btc_parser_output_extract_taproot"></a>

## Function `extract_taproot`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_taproot">extract_taproot</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_extract_taproot">extract_taproot</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): Option&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    <b>if</b> (<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_is_taproot">is_taproot</a>()) {
        option::some(vector_slice(&script, 2, 34))
    } <b>else</b> {
        option::none()
    }
}
</code></pre>



</details>

<a name="btc_parser_output_op_return"></a>

## Function `op_return`

Extracts the data payload from an OP_RETURN output in a transaction.
script = OP_RETURN <data>.
If transaction is mined, then this must pass basic conditions
including the conditions for OP_RETURN script.
This is why we only return the message without check size message.


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_op_return">op_return</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_op_return">op_return</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): Option&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> script = <a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>;
    <b>if</b> (script.length() == 1) {
        <b>return</b> option::none()
    };
    // TODO: better document here. maybe <b>use</b> some ascii chart
    <b>if</b> (script[1] &lt;= <a href="../btc_parser/output.md#btc_parser_output_OP_DATA_75">OP_DATA_75</a>) {
        // script = <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a> OP_DATA_&lt;len&gt; DATA
        //          |      2 bytes         |  the rest |
        <b>return</b> option::some(vector_slice(&script, 2, script.length()))
    };
    <b>if</b> (script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA1">OP_PUSHDATA1</a>) {
        // script = <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA1">OP_PUSHDATA1</a> &lt;1 bytes&gt;    DATA
        //          |      4 bytes                  |  the rest |
        <b>return</b> option::some(vector_slice(&script, 3, script.length()))
    };
    <b>if</b> (script[1] == <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA2">OP_PUSHDATA2</a>) {
        // script = <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA2">OP_PUSHDATA2</a> &lt;2 bytes&gt;   DATA
        //          |      4 bytes                  |  the rest |
        <b>return</b> option::some(vector_slice(&script, 4, script.length()))
    };
    // script = <a href="../btc_parser/output.md#btc_parser_output_OP_RETURN">OP_RETURN</a> <a href="../btc_parser/output.md#btc_parser_output_OP_PUSHDATA4">OP_PUSHDATA4</a> &lt;4-bytes&gt; DATA
    //          |      6 bytes                  |  the rest |
    option::some(vector_slice(&script, 6, script.length()))
}
</code></pre>



</details>

<a name="btc_parser_output_decode"></a>

## Function `decode`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_decode">decode</a>(r: &<b>mut</b> <a href="../btc_parser/reader.md#btc_parser_reader_Reader">btc_parser::reader::Reader</a>): <a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_decode">decode</a>(r: &<b>mut</b> Reader): <a href="../btc_parser/output.md#btc_parser_output_Output">Output</a> {
    <b>let</b> <a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a> = r.read(8);
    <b>let</b> script_pubkey_size = r.read_compact_size();
    <b>let</b> <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a> = r.read(script_pubkey_size);
    <a href="../btc_parser/output.md#btc_parser_output_Output">Output</a> {
        <a href="../btc_parser/output.md#btc_parser_output_amount">amount</a>: le_bytes_to_u64(<a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>),
        <a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>,
        <a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>,
    }
}
</code></pre>



</details>

<a name="btc_parser_output_encode"></a>

## Function `encode`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_encode">encode</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../btc_parser/output.md#btc_parser_output_encode">encode</a>(<a href="../btc_parser/output.md#btc_parser_output">output</a>: &<a href="../btc_parser/output.md#btc_parser_output_Output">Output</a>): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> raw_output = vector[];
    raw_output.append(<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_amount_bytes">amount_bytes</a>);
    raw_output.append(u64_to_varint_bytes(<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>.length()));
    raw_output.append(<a href="../btc_parser/output.md#btc_parser_output">output</a>.<a href="../btc_parser/output.md#btc_parser_output_script_pubkey">script_pubkey</a>);
    raw_output
}
</code></pre>



</details>
