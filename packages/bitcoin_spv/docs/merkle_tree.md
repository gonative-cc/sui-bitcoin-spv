
<a name="bitcoin_spv_merkle_tree"></a>

# Module `bitcoin_spv::merkle_tree`



-  [Function `merkle_hash`](#bitcoin_spv_merkle_tree_merkle_hash)
-  [Function `verify_merkle_proof`](#bitcoin_spv_merkle_tree_verify_merkle_proof)


<pre><code><b>use</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math">bitcoin_spv::btc_math</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="bitcoin_spv_merkle_tree_merkle_hash"></a>

## Function `merkle_hash`

Internal merkle hash computation for BTC merkle tree


<pre><code><b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_merkle_hash">merkle_hash</a>(x: vector&lt;u8&gt;, y: vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_merkle_hash">merkle_hash</a>(x: vector&lt;u8&gt;, y: vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> z = x;
    z.append(y);
    btc_hash(z)
}
</code></pre>



</details>

<a name="bitcoin_spv_merkle_tree_verify_merkle_proof"></a>

## Function `verify_merkle_proof`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_verify_merkle_proof">verify_merkle_proof</a>(root: vector&lt;u8&gt;, merkle_path: vector&lt;vector&lt;u8&gt;&gt;, tx_id: vector&lt;u8&gt;, tx_index: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_verify_merkle_proof">verify_merkle_proof</a>(
    root: vector&lt;u8&gt;,
    merkle_path: vector&lt;vector&lt;u8&gt;&gt;,
    tx_id: vector&lt;u8&gt;,
    tx_index: u64,
): bool {
    <b>let</b> <b>mut</b> hash_value = tx_id;
    <b>let</b> <b>mut</b> i = 0;
    <b>let</b> n = merkle_path.length();
    <b>let</b> <b>mut</b> index = tx_index;
    <b>while</b> (i &lt; n) {
        <b>if</b> (index % 2 == 1) {
            hash_value = <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_merkle_hash">merkle_hash</a>(merkle_path[i], hash_value);
        } <b>else</b> {
            hash_value = <a href="../bitcoin_spv/merkle_tree.md#bitcoin_spv_merkle_tree_merkle_hash">merkle_hash</a>(hash_value, merkle_path[i]);
        };
        index = index &gt;&gt; 1;
        i = i + 1;
    };
    hash_value == root
}
</code></pre>



</details>
