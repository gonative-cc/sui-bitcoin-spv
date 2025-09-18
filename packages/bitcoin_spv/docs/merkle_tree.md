
<a name="(bitcoin_spv=0x0)_merkle_tree"></a>

# Module `(bitcoin_spv=0x0)::merkle_tree`



-  [Constants](#@Constants_0)
-  [Function `merkle_hash`](#(bitcoin_spv=0x0)_merkle_tree_merkle_hash)
-  [Function `verify_merkle_proof`](#(bitcoin_spv=0x0)_merkle_tree_verify_merkle_proof)


<pre><code><b>use</b> (bitcoin_spv=0x0)::<a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math">btc_math</a>;
<b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
<b>use</b> <a href="../dependencies/std/vector.md#std_vector">std::vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="(bitcoin_spv=0x0)_merkle_tree_EInvalidMerkleHashLengh"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_EInvalidMerkleHashLengh">EInvalidMerkleHashLengh</a>: vector&lt;u8&gt; = b"Invalid merkle element hash length";
</code></pre>



<a name="(bitcoin_spv=0x0)_merkle_tree_HASH_LENGTH"></a>



<pre><code><b>const</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_HASH_LENGTH">HASH_LENGTH</a>: u64 = 32;
</code></pre>



<a name="(bitcoin_spv=0x0)_merkle_tree_merkle_hash"></a>

## Function `merkle_hash`

Internal merkle hash computation for BTC merkle tree


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_merkle_hash">merkle_hash</a>(x: vector&lt;u8&gt;, y: vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_merkle_hash">merkle_hash</a>(x: vector&lt;u8&gt;, y: vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> z = x;
    z.append(y);
    btc_hash(z)
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_merkle_tree_verify_merkle_proof"></a>

## Function `verify_merkle_proof`

Verifies if tx_id belongs to the merkle tree
BTC doesn't recognize different between 64 bytes Tx and internal merkle tree node, that reduces the security of SPV proofs.
We modified the merkle tree verify algorithm inspire by this solution:
- https://bitslog.com/2018/08/21/simple-change-to-the-bitcoin-merkleblock-command-to-protect-from-leaf-node-weakness-in-transaction-merkle-tree/
Gist: instead of computing new merkle node = HASH256(X||Y) where X, Y is children nodes;
we compute new merkle node = HASH256(SHA256(X), Y) or node=HASH256(X, SHA256(Y)),
depending if we are coming from left or right.
The trade off here is we need more hash execution.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_verify_merkle_proof">verify_merkle_proof</a>(root: vector&lt;u8&gt;, merkle_path: vector&lt;vector&lt;u8&gt;&gt;, tx_id: vector&lt;u8&gt;, tx_index: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_verify_merkle_proof">verify_merkle_proof</a>(
    root: vector&lt;u8&gt;,
    merkle_path: vector&lt;vector&lt;u8&gt;&gt;,
    tx_id: vector&lt;u8&gt;,
    tx_index: u64,
): bool {
    <b>assert</b>!(root.length() == <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_HASH_LENGTH">HASH_LENGTH</a>, <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_EInvalidMerkleHashLengh">EInvalidMerkleHashLengh</a>);
    <b>assert</b>!(tx_id.length() == <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_HASH_LENGTH">HASH_LENGTH</a>, <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_EInvalidMerkleHashLengh">EInvalidMerkleHashLengh</a>);
    <b>let</b> <b>mut</b> index = tx_index;
    <b>let</b> merkle_root = merkle_path.fold!(tx_id, |child_hash, merkle_value| {
        <b>assert</b>!(merkle_value.length() == <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_HASH_LENGTH">HASH_LENGTH</a>, <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_EInvalidMerkleHashLengh">EInvalidMerkleHashLengh</a>);
        <b>let</b> h = sha2_256(merkle_value);
        <b>let</b> parent_hash = <b>if</b> (index % 2 == 1) {
            <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_merkle_hash">merkle_hash</a>(h, child_hash)
        } <b>else</b> {
            <a href="../bitcoin_spv/merkle_tree.md#(bitcoin_spv=0x0)_merkle_tree_merkle_hash">merkle_hash</a>(child_hash, h)
        };
        index = index &gt;&gt; 1;
        parent_hash
    });
    merkle_root == root
}
</code></pre>



</details>
