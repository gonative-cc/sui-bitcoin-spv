
<a name="btc_parser_encoding"></a>

# Module `btc_parser::encoding`



-  [Constants](#@Constants_0)
-  [Function `le_bytes_to_u64`](#btc_parser_encoding_le_bytes_to_u64)
-  [Function `u64_to_varint_bytes`](#btc_parser_encoding_u64_to_varint_bytes)
-  [Function `u32_to_le_bytes`](#btc_parser_encoding_u32_to_le_bytes)
-  [Function `u64_to_le_bytes`](#btc_parser_encoding_u64_to_le_bytes)


<pre><code></code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="btc_parser_encoding_EOverflowVector"></a>



<pre><code>#[error]
<b>const</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_EOverflowVector">EOverflowVector</a>: vector&lt;u8&gt; = b"Can't covert vector to u64 b/c overflow";
</code></pre>



<a name="btc_parser_encoding_le_bytes_to_u64"></a>

## Function `le_bytes_to_u64`

Converts vector bytes in the little-endian form to a u64 integer


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_le_bytes_to_u64">le_bytes_to_u64</a>(v: vector&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_le_bytes_to_u64">le_bytes_to_u64</a>(v: vector&lt;u8&gt;): u64 {
    <b>assert</b>!(v.length() &lt;= 8, <a href="../btc_parser/encoding.md#btc_parser_encoding_EOverflowVector">EOverflowVector</a>);
    <b>let</b> <b>mut</b> number = 0;
    v.length().do!(|i| {
        number = number + ((v[i] <b>as</b> u64) * ((1 <b>as</b> u64) &lt;&lt; ((i <b>as</b> u8) * 8)) <b>as</b> u64)
    });
    number
}
</code></pre>



</details>

<a name="btc_parser_encoding_u64_to_varint_bytes"></a>

## Function `u64_to_varint_bytes`

Encodes a u64 into VarInt format.
Adapted from go_native/move_spv_light_client


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u64_to_varint_bytes">u64_to_varint_bytes</a>(n: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u64_to_varint_bytes">u64_to_varint_bytes</a>(n: u64): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> ans = vector::empty&lt;u8&gt;();
    <b>let</b> <b>mut</b> n = n;
    <b>if</b> (n &lt;= 252) {
        ans.push_back(n <b>as</b> u8);
    } <b>else</b> <b>if</b> (n &lt;= 65535) {
        ans.push_back(0xfd);
        do!(2, |_i| {
            ans.push_back((n & 0xff) <b>as</b> u8);
            n = n &gt;&gt; 8;
        });
    } <b>else</b> <b>if</b> (n &lt;= 4294967295) {
        ans.push_back(0xfe);
        do!(4, |_i| {
            ans.push_back((n & 0xff) <b>as</b> u8);
            n = n &gt;&gt; 8;
        });
    } <b>else</b> {
        ans.push_back(0xff);
        do!(8, |_i| {
            ans.push_back((n & 0xff) <b>as</b> u8);
            n = n &gt;&gt; 8;
        });
    };
    ans
}
</code></pre>



</details>

<a name="btc_parser_encoding_u32_to_le_bytes"></a>

## Function `u32_to_le_bytes`

Converts a u32 integer to a 4-byte little-endian vector<u8>.


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u32_to_le_bytes">u32_to_le_bytes</a>(val: u32): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u32_to_le_bytes">u32_to_le_bytes</a>(val: u32): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> bytes = vector::empty&lt;u8&gt;();
    bytes.push_back(((val &gt;&gt; 0) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 8) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 16) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 24) & 0xFF) <b>as</b> u8);
    bytes
}
</code></pre>



</details>

<a name="btc_parser_encoding_u64_to_le_bytes"></a>

## Function `u64_to_le_bytes`

Converts a u64 integer to an 8-byte little-endian vector<u8>.


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u64_to_le_bytes">u64_to_le_bytes</a>(val: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../btc_parser/encoding.md#btc_parser_encoding_u64_to_le_bytes">u64_to_le_bytes</a>(val: u64): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> bytes = vector::empty&lt;u8&gt;();
    bytes.push_back(((val &gt;&gt; 0) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 8) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 16) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 24) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 32) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 40) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 48) & 0xFF) <b>as</b> u8);
    bytes.push_back(((val &gt;&gt; 56) & 0xFF) <b>as</b> u8);
    bytes
}
</code></pre>



</details>
