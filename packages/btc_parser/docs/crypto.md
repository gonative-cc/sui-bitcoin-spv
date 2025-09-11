
<a name="btc_parser_crypto"></a>

# Module `btc_parser::crypto`



-  [Function `hash256`](#btc_parser_crypto_hash256)


<pre><code><b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
</code></pre>



<a name="btc_parser_crypto_hash256"></a>

## Function `hash256`

Computes sha2_256(sha2_256(data)).


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/crypto.md#btc_parser_crypto_hash256">hash256</a>(data: vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/crypto.md#btc_parser_crypto_hash256">hash256</a>(data: vector&lt;u8&gt;): vector&lt;u8&gt; {
    sha2_256(sha2_256(data))
}
</code></pre>



</details>
