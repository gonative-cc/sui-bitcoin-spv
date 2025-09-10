
<a name="bitcoin_spv_transaction"></a>

# Module `bitcoin_spv::transaction`



-  [Struct `Output`](#bitcoin_spv_transaction_Output)
-  [Struct `Transaction`](#bitcoin_spv_transaction_Transaction)
-  [Constants](#@Constants_0)
-  [Function `make_transaction`](#bitcoin_spv_transaction_make_transaction)
-  [Function `parse_output`](#bitcoin_spv_transaction_parse_output)
-  [Function `tx_id`](#bitcoin_spv_transaction_tx_id)
-  [Function `outputs`](#bitcoin_spv_transaction_outputs)
-  [Function `amount`](#bitcoin_spv_transaction_amount)
-  [Function `is_P2PHK`](#bitcoin_spv_transaction_is_P2PHK)
-  [Function `is_op_return`](#bitcoin_spv_transaction_is_op_return)
-  [Function `is_P2WPHK`](#bitcoin_spv_transaction_is_P2WPHK)
-  [Function `extract_public_key_hash`](#bitcoin_spv_transaction_extract_public_key_hash)
-  [Function `op_return`](#bitcoin_spv_transaction_op_return)
-  [Function `make_outputs`](#bitcoin_spv_transaction_make_outputs)


<pre><code><b>use</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math">bitcoin_spv::btc_math</a>;
<b>use</b> <a href="../bitcoin_spv/utils.md#bitcoin_spv_utils">bitcoin_spv::utils</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="bitcoin_spv_transaction_Output"></a>

## Struct `Output`

Represents a Bitcoin transaction output


<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>: u64</code>
</dt>
<dd>
</dd>
<dt>
<code>script_pubkey: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="bitcoin_spv_transaction_Transaction"></a>

## Struct `Transaction`

Represents a Bitcoin transaction


<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">Transaction</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>version: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>input_count: u32</code>
</dt>
<dd>
</dd>
<dt>
<code>inputs: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>output_count: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>: vector&lt;<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>lock_time: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_spv_transaction_OP_0"></a>

An empty array of bytes is pushed onto the stack. (This is not a no-op: an item is added to the stack.)


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_0">OP_0</a>: u8 = 0;
</code></pre>



<a name="bitcoin_spv_transaction_OP_DUP"></a>

Duplicates the top stack item


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DUP">OP_DUP</a>: u8 = 118;
</code></pre>



<a name="bitcoin_spv_transaction_OP_HASH160"></a>

Pop the top stack item and push its RIPEMD(SHA256(top item)) hash


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_HASH160">OP_HASH160</a>: u8 = 169;
</code></pre>



<a name="bitcoin_spv_transaction_OP_DATA_20"></a>

Push the next 20 bytes as an array onto the stack


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DATA_20">OP_DATA_20</a>: u8 = 20;
</code></pre>



<a name="bitcoin_spv_transaction_OP_EQUALVERIFY"></a>

Returns success if the inputs are exactly equal, failure otherwise


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_EQUALVERIFY">OP_EQUALVERIFY</a>: u8 = 136;
</code></pre>



<a name="bitcoin_spv_transaction_OP_CHECKSIG"></a>

https://en.bitcoin.it/wiki/OP_CHECKSIG pushing 1/0 for success/failure


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_CHECKSIG">OP_CHECKSIG</a>: u8 = 172;
</code></pre>



<a name="bitcoin_spv_transaction_OP_RETURN"></a>

nulldata script


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a>: u8 = 106;
</code></pre>



<a name="bitcoin_spv_transaction_OP_PUSHDATA4"></a>

Read the next 4 bytes as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA4">OP_PUSHDATA4</a>: u8 = 78;
</code></pre>



<a name="bitcoin_spv_transaction_OP_PUSHDATA2"></a>

Read the next 2 bytes as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA2">OP_PUSHDATA2</a>: u8 = 77;
</code></pre>



<a name="bitcoin_spv_transaction_OP_PUSHDATA1"></a>

Read the next byte as N. Push the next N bytes as an array onto the stack.


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA1">OP_PUSHDATA1</a>: u8 = 76;
</code></pre>



<a name="bitcoin_spv_transaction_OP_DATA_75"></a>

Push the next 75 bytes onto the stack.


<pre><code><b>const</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DATA_75">OP_DATA_75</a>: u8 = 75;
</code></pre>



<a name="bitcoin_spv_transaction_make_transaction"></a>

## Function `make_transaction`

Bitcoin transaction constructor
* <code>input_count</code>: number of input objects
* <code>inputs</code>: all tx inputs encoded as a single list of bytes.
* <code>output_count</code>: number of output objects
* <code><a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a></code>: all tx outputs encoded as a single list of bytes.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_make_transaction">make_transaction</a>(version: vector&lt;u8&gt;, input_count: u32, inputs: vector&lt;u8&gt;, output_count: u32, <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>: vector&lt;u8&gt;, lock_time: vector&lt;u8&gt;): <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">bitcoin_spv::transaction::Transaction</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_make_transaction">make_transaction</a>(
    version: vector&lt;u8&gt;,
    input_count: u32,
    inputs: vector&lt;u8&gt;,
    output_count: u32,
    <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>: vector&lt;u8&gt;,
    lock_time: vector&lt;u8&gt;,
): <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">Transaction</a> {
    <b>assert</b>!(version.length() == 4);
    <b>assert</b>!(lock_time.length() == 4);
    <b>let</b> number_input_bytes = u256_to_compact(input_count <b>as</b> u256);
    <b>let</b> number_output_bytes = u256_to_compact(output_count <b>as</b> u256);
    // compute TxID
    <b>let</b> <b>mut</b> tx_data = version;
    tx_data.append(number_input_bytes);
    tx_data.append(inputs);
    tx_data.append(number_output_bytes);
    tx_data.append(<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>);
    tx_data.append(lock_time);
    <b>let</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a> = btc_hash(tx_data);
    <b>let</b> outputs_decoded = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_make_outputs">make_outputs</a>(output_count, <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>);
    <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">Transaction</a> {
        version,
        input_count,
        inputs,
        output_count,
        <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>: outputs_decoded,
        lock_time,
        <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a>,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_parse_output"></a>

## Function `parse_output`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_parse_output">parse_output</a>(<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>: u64, script_pubkey: vector&lt;u8&gt;): <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_parse_output">parse_output</a>(<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>: u64, script_pubkey: vector&lt;u8&gt;): <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a> {
    <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a> {
        <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>,
        script_pubkey,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_tx_id"></a>

## Function `tx_id`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a>(tx: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">bitcoin_spv::transaction::Transaction</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a>(tx: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">Transaction</a>): vector&lt;u8&gt; {
    tx.<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_tx_id">tx_id</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_outputs"></a>

## Function `outputs`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>(tx: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">bitcoin_spv::transaction::Transaction</a>): vector&lt;<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>(tx: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Transaction">Transaction</a>): vector&lt;<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>&gt; {
    tx.<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_amount"></a>

## Function `amount`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): u64 {
    output.<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_is_P2PHK"></a>

## Function `is_P2PHK`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2PHK">is_P2PHK</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2PHK">is_P2PHK</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): bool {
    <b>let</b> script = output.script_pubkey;
    script.length() == 25 &&
		script[0] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DUP">OP_DUP</a> &&
		script[1] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_HASH160">OP_HASH160</a> &&
		script[2] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DATA_20">OP_DATA_20</a> &&
		script[23] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_EQUALVERIFY">OP_EQUALVERIFY</a> &&
		script[24] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_CHECKSIG">OP_CHECKSIG</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_is_op_return"></a>

## Function `is_op_return`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_op_return">is_op_return</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_op_return">is_op_return</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): bool {
    <b>let</b> script = output.script_pubkey;
    script.length() &gt; 0 && script[0] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_is_P2WPHK"></a>

## Function `is_P2WPHK`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2WPHK">is_P2WPHK</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2WPHK">is_P2WPHK</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): bool {
    <b>let</b> script = output.script_pubkey;
    script.length() == 22 &&
        script[0] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_0">OP_0</a> &&
        script[1] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DATA_20">OP_DATA_20</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_extract_public_key_hash"></a>

## Function `extract_public_key_hash`

extract pkh from the output in P2PHK or P2WPKH
return empty if the cannot extract public key hash


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_extract_public_key_hash">extract_public_key_hash</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_extract_public_key_hash">extract_public_key_hash</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): vector&lt;u8&gt; {
    <b>let</b> script = output.script_pubkey;
    <b>if</b> (output.<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2PHK">is_P2PHK</a>()) {
        <b>return</b> slice(script, 3, 23)
    } <b>else</b> <b>if</b> (output.<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_is_P2WPHK">is_P2WPHK</a>()) {
        <b>return</b> slice(script, 2, 22)
    };
    vector[]
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_op_return"></a>

## Function `op_return`

Extracts the data payload from an OP_RETURN output in a transaction.
script = OP_RETURN <data>.
If transaction mined to BTC, then this must pass basic conditions
include the conditions for OP_RETURN script.
This why we only return the message without check size message.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_op_return">op_return</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_op_return">op_return</a>(output: &<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>): vector&lt;u8&gt; {
    <b>let</b> script = output.script_pubkey;
    <b>if</b> (script.length() == 1) {
        <b>return</b> vector[]
    };
    <b>if</b> (script[1] &lt;= <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_DATA_75">OP_DATA_75</a>) {
        // script = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a> OP_DATA_&lt;len&gt; DATA
        //          |      2 bytes         |  the rest |
        <b>return</b> slice(script, 2, script.length())
    };
    <b>if</b> (script[1] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA1">OP_PUSHDATA1</a>) {
        // script = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA1">OP_PUSHDATA1</a> &lt;1 bytes&gt;    DATA
        //          |      4 bytes                  |  the rest |
        <b>return</b> slice(script, 3, script.length())
    };
    <b>if</b> (script[1] == <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA2">OP_PUSHDATA2</a>) {
        // script = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA2">OP_PUSHDATA2</a> &lt;2 bytes&gt;   DATA
        //          |      4 bytes                  |  the rest |
        <b>return</b> slice(script, 4, script.length())
    };
    // script = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_RETURN">OP_RETURN</a> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_OP_PUSHDATA4">OP_PUSHDATA4</a> &lt;4-bytes&gt; DATA
    //          |      6 bytes                  |  the rest |
    slice(script, 6, script.length())
}
</code></pre>



</details>

<a name="bitcoin_spv_transaction_make_outputs"></a>

## Function `make_outputs`

* <code>output_count</code>: number of output objects in outputs bytes
* <code><a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a></code>: all tx outputs encoded as a single list of bytes.


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_make_outputs">make_outputs</a>(output_count: u32, outputs_bytes: vector&lt;u8&gt;): vector&lt;<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">bitcoin_spv::transaction::Output</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_make_outputs">make_outputs</a>(output_count: u32, outputs_bytes: vector&lt;u8&gt;): vector&lt;<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_Output">Output</a>&gt; {
    <b>let</b> <b>mut</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a> = vector[];
    <b>let</b> <b>mut</b> start = 0u64;
    <b>let</b> <b>mut</b> script_pubkey_size;
    <b>let</b> <b>mut</b> i = 0;
    <b>while</b> (i &lt; output_count) {
        <b>let</b> <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a> = slice(outputs_bytes, start, start + 8); // 8 bytes of <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>
        start = start + 8;
        (script_pubkey_size, start) = compact_size(outputs_bytes, start);
        <b>let</b> script_pubkey = slice(outputs_bytes, start, (start + (script_pubkey_size <b>as</b> u64)));
        start = start + (script_pubkey_size <b>as</b> u64);
        <b>let</b> output = <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_parse_output">parse_output</a>(extract_u64(<a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_amount">amount</a>, 0, 8), script_pubkey);
        <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>.push_back(output);
        i = i + 1;
    };
    <a href="../bitcoin_spv/transaction.md#bitcoin_spv_transaction_outputs">outputs</a>
}
</code></pre>



</details>
