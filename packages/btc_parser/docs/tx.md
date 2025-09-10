
<a name="btc_parser_tx"></a>

# Module `btc_parser::tx`



-  [Struct `InputWitness`](#btc_parser_tx_InputWitness)
-  [Struct `Transaction`](#btc_parser_tx_Transaction)
-  [Function `new`](#btc_parser_tx_new)
-  [Function `items`](#btc_parser_tx_items)
-  [Function `version`](#btc_parser_tx_version)
-  [Function `inputs`](#btc_parser_tx_inputs)
-  [Function `outputs`](#btc_parser_tx_outputs)
-  [Function `witness`](#btc_parser_tx_witness)
-  [Function `locktime`](#btc_parser_tx_locktime)
-  [Function `input_at`](#btc_parser_tx_input_at)
-  [Function `output_at`](#btc_parser_tx_output_at)
-  [Function `is_witness`](#btc_parser_tx_is_witness)
-  [Function `tx_id`](#btc_parser_tx_tx_id)
-  [Function `deserialize`](#btc_parser_tx_deserialize)
-  [Function `is_coinbase`](#btc_parser_tx_is_coinbase)


<pre><code><b>use</b> <a href="../btc_parser/crypto.md#btc_parser_crypto">btc_parser::crypto</a>;
<b>use</b> <a href="../btc_parser/encoding.md#btc_parser_encoding">btc_parser::encoding</a>;
<b>use</b> <a href="../btc_parser/input.md#btc_parser_input">btc_parser::input</a>;
<b>use</b> <a href="../btc_parser/output.md#btc_parser_output">btc_parser::output</a>;
<b>use</b> <a href="../btc_parser/reader.md#btc_parser_reader">btc_parser::reader</a>;
<b>use</b> <a href="../btc_parser/vector_utils.md#btc_parser_vector_utils">btc_parser::vector_utils</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/option.md#std_option">std::option</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="btc_parser_tx_InputWitness"></a>

## Struct `InputWitness`



<pre><code><b>public</b> <b>struct</b> <a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">InputWitness</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="btc_parser_tx_Transaction"></a>

## Struct `Transaction`

BTC transaction


<pre><code><b>public</b> <b>struct</b> <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>: vector&lt;<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>marker: <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>flag: <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>: vector&lt;<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>: vector&lt;<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">btc_parser::tx::InputWitness</a>&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="btc_parser_tx_new"></a>

## Function `new`

Create a btc data


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_new">new</a>(<a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>: vector&lt;u8&gt;, marker: <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;u8&gt;, flag: <a href="../dependencies/std/option.md#std_option_Option">std::option::Option</a>&lt;u8&gt;, <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>: vector&lt;<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>&gt;, <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>: vector&lt;<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>&gt;, <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>: vector&lt;<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">btc_parser::tx::InputWitness</a>&gt;, <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>: vector&lt;u8&gt;, <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>: vector&lt;u8&gt;): <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_new">new</a>(
    <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>: vector&lt;u8&gt;,
    marker: Option&lt;u8&gt;,
    flag: Option&lt;u8&gt;,
    <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>: vector&lt;Input&gt;,
    <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>: vector&lt;Output&gt;,
    <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>: vector&lt;<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">InputWitness</a>&gt;,
    <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>: vector&lt;u8&gt;,
    <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>: vector&lt;u8&gt;,
): <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a> {
    <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a> {
        <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>,
        marker,
        flag,
        <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>,
    }
}
</code></pre>



</details>

<a name="btc_parser_tx_items"></a>

## Function `items`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>(w: &<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">btc_parser::tx::InputWitness</a>): vector&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>(w: &<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">InputWitness</a>): vector&lt;vector&lt;u8&gt;&gt; {
    w.<a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_version"></a>

## Function `version`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_inputs"></a>

## Function `inputs`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;Input&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_outputs"></a>

## Function `outputs`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;Output&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_witness"></a>

## Function `witness`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">btc_parser::tx::InputWitness</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">InputWitness</a>&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_locktime"></a>

## Function `locktime`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_input_at"></a>

## Function `input_at`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_input_at">input_at</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>, idx: u64): &<a href="../btc_parser/input.md#btc_parser_input_Input">btc_parser::input::Input</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_input_at">input_at</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>, idx: u64): &Input {
    &<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>[idx]
}
</code></pre>



</details>

<a name="btc_parser_tx_output_at"></a>

## Function `output_at`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_output_at">output_at</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>, idx: u64): &<a href="../btc_parser/output.md#btc_parser_output_Output">btc_parser::output::Output</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_output_at">output_at</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>, idx: u64): &Output {
    &<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>[idx]
}
</code></pre>



</details>

<a name="btc_parser_tx_is_witness"></a>

## Function `is_witness`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_is_witness">is_witness</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_is_witness">is_witness</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): bool {
    <b>if</b> (<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.marker.is_none() || <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.flag.is_none()) {
        <b>return</b> <b>false</b>
    };
    <b>let</b> m = <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.marker.borrow();
    <b>let</b> f = <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.flag.borrow();
    m == 0x00 && f == 0x01
}
</code></pre>



</details>

<a name="btc_parser_tx_tx_id"></a>

## Function `tx_id`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): vector&lt;u8&gt; {
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>
}
</code></pre>



</details>

<a name="btc_parser_tx_deserialize"></a>

## Function `deserialize`

deseriablize transaction from bytes


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_deserialize">deserialize</a>(r: &<b>mut</b> <a href="../btc_parser/reader.md#btc_parser_reader_Reader">btc_parser::reader::Reader</a>): <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_deserialize">deserialize</a>(r: &<b>mut</b> Reader): <a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a> {
    // transaction data without segwit.
    // <b>use</b> <b>for</b> compute the <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>
    <b>let</b> <b>mut</b> raw_tx = vector[];
    <b>let</b> <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a> = r.read(4);
    raw_tx.append(<a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>);
    <b>let</b> segwit = r.peek(2);
    <b>let</b> <b>mut</b> marker: Option&lt;u8&gt; = option::none();
    <b>let</b> <b>mut</b> flag: Option&lt;u8&gt; = option::none();
    <b>if</b> (segwit[0] == 0x00 && segwit[1] == 0x01) {
        // TODO: Handle case marker and option is none
        marker = option::some(r.read_byte());
        flag = option::some(r.read_byte());
    };
    <b>let</b> number_inputs = r.read_compact_size();
    raw_tx.append(u64_to_varint_bytes(number_inputs));
    <b>let</b> <b>mut</b> <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a> = vector[];
    number_inputs.do!(|_| {
        <b>let</b> <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a> = r.read(32);
        raw_tx.append(<a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>);
        <b>let</b> vout = r.read(4);
        raw_tx.append(vout);
        <b>let</b> script_sig_size = r.read_compact_size();
        raw_tx.append(u64_to_varint_bytes(script_sig_size));
        <b>let</b> script_sig = r.read(script_sig_size);
        raw_tx.append(script_sig);
        <b>let</b> sequence = r.read(4);
        raw_tx.append(sequence);
        <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>.push_back(
            <a href="../btc_parser/input.md#btc_parser_input_new">input::new</a>(
                <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>,
                vout,
                script_sig,
                sequence,
            ),
        );
    });
    // read <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>
    <b>let</b> number_outputs = r.read_compact_size();
    raw_tx.append(u64_to_varint_bytes(number_outputs));
    <b>let</b> <b>mut</b> <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a> = vector[];
    number_outputs.do!(|_| {
        <b>let</b> amount = r.read(8);
        raw_tx.append(amount);
        <b>let</b> script_pubkey_size = r.read_compact_size();
        <b>let</b> script_pubkey = r.read(script_pubkey_size);
        raw_tx.append(u64_to_varint_bytes(script_pubkey_size));
        raw_tx.append(script_pubkey);
        <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>.push_back(
            <a href="../btc_parser/output.md#btc_parser_output_new">output::new</a>(
                le_bytes_to_u64(amount),
                script_pubkey,
            ),
        )
    });
    <b>let</b> <b>mut</b> <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a> = vector[];
    <b>if</b> (segwit[0] == 0x00 && segwit[1] == 0x01) {
        number_inputs.do!(|_| {
            <b>let</b> stack_item = r.read_compact_size();
            <b>let</b> <b>mut</b> <a href="../btc_parser/tx.md#btc_parser_tx_items">items</a> = vector[];
            stack_item.do!(|_| {
                <b>let</b> size = r.read_compact_size();
                <a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>.push_back(r.read(size));
            });
            <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>.push_back(<a href="../btc_parser/tx.md#btc_parser_tx_InputWitness">InputWitness</a> {
                <a href="../btc_parser/tx.md#btc_parser_tx_items">items</a>,
            });
        })
    };
    <b>let</b> <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a> = r.read(4);
    raw_tx.append(<a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>);
    <b>let</b> <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a> = hash256(raw_tx);
    <a href="../btc_parser/tx.md#btc_parser_tx_new">new</a>(
        <a href="../btc_parser/tx.md#btc_parser_tx_version">version</a>,
        marker,
        flag,
        <a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_outputs">outputs</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_witness">witness</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_locktime">locktime</a>,
        <a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>,
    )
}
</code></pre>



</details>

<a name="btc_parser_tx_is_coinbase"></a>

## Function `is_coinbase`



<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_is_coinbase">is_coinbase</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">btc_parser::tx::Transaction</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/tx.md#btc_parser_tx_is_coinbase">is_coinbase</a>(<a href="../btc_parser/tx.md#btc_parser_tx">tx</a>: &<a href="../btc_parser/tx.md#btc_parser_tx_Transaction">Transaction</a>): bool {
    // TODO: check BIP34 and BIP141
    <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>.length() == 1 && <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>[0].vout() == x"ffffffff" &&
        <a href="../btc_parser/tx.md#btc_parser_tx">tx</a>.<a href="../btc_parser/tx.md#btc_parser_tx_inputs">inputs</a>[0].<a href="../btc_parser/tx.md#btc_parser_tx_tx_id">tx_id</a>() ==  x"0000000000000000000000000000000000000000000000000000000000000000"
}
</code></pre>



</details>
