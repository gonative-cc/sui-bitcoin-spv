
<a name="bitcoin_spv_btc_math"></a>

# Module `bitcoin_spv::btc_math`



-  [Constants](#@Constants_0)
-  [Function `to_u32`](#bitcoin_spv_btc_math_to_u32)
-  [Function `to_u256`](#bitcoin_spv_btc_math_to_u256)
-  [Function `extract_u64`](#bitcoin_spv_btc_math_extract_u64)
-  [Function `btc_hash`](#bitcoin_spv_btc_math_btc_hash)
-  [Function `compact_size_offset`](#bitcoin_spv_btc_math_compact_size_offset)
-  [Function `compact_size`](#bitcoin_spv_btc_math_compact_size)
-  [Function `bytes_of`](#bitcoin_spv_btc_math_bytes_of)
-  [Function `get_last_32_bits`](#bitcoin_spv_btc_math_get_last_32_bits)
-  [Function `target_to_bits`](#bitcoin_spv_btc_math_target_to_bits)
-  [Function `bits_to_target`](#bitcoin_spv_btc_math_bits_to_target)
-  [Function `u256_to_compact`](#bitcoin_spv_btc_math_u256_to_compact)


<pre><code><b>use</b> <a href="../dependencies/std/hash.md#std_hash">std::hash</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_spv_btc_math_EInvalidLength"></a>

=== Errors ===


<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidLength">EInvalidLength</a>: vector&lt;u8&gt; = b"The input vector <b>has</b> an invalid length";
</code></pre>



<a name="bitcoin_spv_btc_math_EInvalidCompactSizeDecode"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidCompactSizeDecode">EInvalidCompactSizeDecode</a>: vector&lt;u8&gt; = b"Invalid compact size encoding during decoding";
</code></pre>



<a name="bitcoin_spv_btc_math_EInvalidCompactSizeEncode"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidCompactSizeEncode">EInvalidCompactSizeEncode</a>: vector&lt;u8&gt; = b"Invalid compact size encoding during encoding";
</code></pre>



<a name="bitcoin_spv_btc_math_EInvalidNumberSize"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidNumberSize">EInvalidNumberSize</a>: vector&lt;u8&gt; = b"Input vector size does not match with expected size";
</code></pre>



<a name="bitcoin_spv_btc_math_to_u32"></a>

## Function `to_u32`

Converts 4 bytes in little endian format to u32 number


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_to_u32">to_u32</a>(v: vector&lt;u8&gt;): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_to_u32">to_u32</a>(v: vector&lt;u8&gt;): u32 {
    <b>assert</b>!(v.length() == 4, <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidLength">EInvalidLength</a>);
    <b>let</b> <b>mut</b> ans = 0u32;
    <b>let</b> <b>mut</b> i = 0u8;
    <b>while</b> (i &lt; 4) {
        ans = ans + ((v[i <b>as</b> u64] <b>as</b> u32) &lt;&lt; i*8);
        i = i + 1;
    };
    ans
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_to_u256"></a>

## Function `to_u256`

Converts 32 bytes in little endian format to u256 number.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_to_u256">to_u256</a>(v: vector&lt;u8&gt;): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_to_u256">to_u256</a>(v: vector&lt;u8&gt;): u256 {
    <b>assert</b>!(v.length() == 32, <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidLength">EInvalidLength</a>);
    <b>let</b> <b>mut</b> ans = 0u256;
    <b>let</b> <b>mut</b> i = 0;
    <b>while</b> (i &lt; 32) {
        ans = ans +  ((v[i] <b>as</b> u256)  &lt;&lt; (i * 8 <b>as</b> u8));
        i = i + 1;
    };
    ans
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_extract_u64"></a>

## Function `extract_u64`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_extract_u64">extract_u64</a>(v: vector&lt;u8&gt;, start: u64, end: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_extract_u64">extract_u64</a>(v: vector&lt;u8&gt;, start: u64, end: u64): u64 {
    <b>let</b> size = end - start;
    <b>assert</b>!(size &lt;= 8, <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidNumberSize">EInvalidNumberSize</a>);
    <b>assert</b>!(end &lt;= v.length(), <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidLength">EInvalidLength</a>);
    <b>let</b> <b>mut</b> ans = 0;
    <b>let</b> <b>mut</b> i = start;
    <b>let</b> <b>mut</b> j = 0;
    <b>while</b> (i &lt; end) {
        ans = ans +  ((v[i] <b>as</b> u64)  &lt;&lt; (j * 8 <b>as</b> u8));
        i = i + 1;
        j = j + 1;
    };
    ans
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_btc_hash"></a>

## Function `btc_hash`

Double hashes the value


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_btc_hash">btc_hash</a>(data: vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_btc_hash">btc_hash</a>(data: vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> first_hash = hash::sha2_256(data);
    <b>let</b> second_hash = hash::sha2_256(first_hash);
    second_hash
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_compact_size_offset"></a>

## Function `compact_size_offset`

Calculates offset for decoding a Bitcoin compact size integer.


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_compact_size_offset">compact_size_offset</a>(start_byte: u8): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_compact_size_offset">compact_size_offset</a>(start_byte: u8): u64 {
    <b>if</b> (start_byte &lt;= 0xfc) {
        <b>return</b> 0
    };
    <b>if</b> (start_byte == 0xfd) {
        <b>return</b> 2
    };
    <b>if</b> (start_byte == 0xfe) {
        <b>return</b> 4
    };
    // 0xff
    8
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_compact_size"></a>

## Function `compact_size`

Decodes a compact number - number of integer bytes, from the vector <code>v</code>.
Returns the decoded number and the first index in <code>v</code> after the number.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_compact_size">compact_size</a>(v: vector&lt;u8&gt;, start: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_compact_size">compact_size</a>(v: vector&lt;u8&gt;, start: u64): (u64, u64) {
    <b>let</b> offset = <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_compact_size_offset">compact_size_offset</a>(v[start]);
    <b>assert</b>!(start + offset &lt; v.length(), <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidCompactSizeDecode">EInvalidCompactSizeDecode</a>);
    <b>if</b> (offset == 0) {
        <b>return</b> (v[start] <b>as</b> u64, start + 1)
    };
    (<a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_extract_u64">extract_u64</a>(v, start + 1, start + offset + 1), start + offset + 1)
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_bytes_of"></a>

## Function `bytes_of`

number of bytes to represent number.


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_bytes_of">bytes_of</a>(number: u256): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_bytes_of">bytes_of</a>(number: u256): u8 {
    <b>let</b> <b>mut</b> b: u8 = 255;
    <b>while</b> (number & (1 &lt;&lt; b) == 0 && b &gt; 0) {
        b = b - 1;
    };
    // Follow logic in bitcoin core
    ((b <b>as</b> u32) / 8 + 1) <b>as</b> u8
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_get_last_32_bits"></a>

## Function `get_last_32_bits`

Returns last 32 bits of a number.


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_get_last_32_bits">get_last_32_bits</a>(number: u256): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_get_last_32_bits">get_last_32_bits</a>(number: u256): u32 {
    (number & 0xffffffff) <b>as</b> u32
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_target_to_bits"></a>

## Function `target_to_bits`

target => bits conversion function.
target is the number you need to get below to mine a block - it defines the difficulty.
The bits field contains a compact representation of the target.
format of bits = <1 byte for exponent><3 bytes for coefficient>
target = coefficient * 2^ (coefficient - 3) (note: 3 = bytes length of the coefficient).
Caution:
The first significant byte for the coefficient must be below 80. If it's not, you have to take the preceding 00 as the first byte.
More & examples: https://learnmeabitcoin.com/technical/block/bits.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_target_to_bits">target_to_bits</a>(target: u256): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_target_to_bits">target_to_bits</a>(target: u256): u32 {
    // TODO: Handle case nagative target?
    // I checked bitcoin-code. They did't create any negative target.
    <b>let</b> <b>mut</b> exponent = <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_bytes_of">bytes_of</a>(target);
    <b>let</b> <b>mut</b> coefficient;
    <b>if</b> (exponent &lt;= 3) {
        <b>let</b> bits_shift: u8 = 8 * ( 3 - exponent);
        coefficient = <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_get_last_32_bits">get_last_32_bits</a>(target) &lt;&lt; bits_shift;
    } <b>else</b> {
        <b>let</b> bits_shift: u8 = 8 * (exponent - 3);
        <b>let</b> bn = target &gt;&gt; bits_shift;
        coefficient = <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_get_last_32_bits">get_last_32_bits</a>(bn)
    };
    // handle case target is negative number.
    // 0x00800000 is set then it indicates a negative value
    // and target can be negative
    <b>if</b> (coefficient & 0x00800000 &gt; 0) {
        // we push 00 before coefficet
        coefficient = coefficient &gt;&gt; 8;
        exponent = exponent + 1;
    };
    <b>let</b> compact = coefficient | ((exponent <b>as</b> u32) &lt;&lt; 24);
    // TODO: Check case target is a negative number.
    // However, the target mustn't be a negative number
    compact
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_bits_to_target"></a>

## Function `bits_to_target`

Converts bits to target. See documentation to the function above for more details.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_bits_to_target">bits_to_target</a>(bits: u32): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_bits_to_target">bits_to_target</a>(bits: u32): u256 {
    <b>let</b> exponent = bits &gt;&gt; 3*8;
    // extract coefficient path or get last 24 bit of `bits`
    <b>let</b> <b>mut</b> target = (bits & 0x007fffff) <b>as</b> u256;
    <b>if</b> (exponent &lt;= 3) {
        <b>let</b> bits_shift = (8 * (3 - exponent)) <b>as</b> u8;
        target = target &gt;&gt; bits_shift;
    } <b>else</b> {
        <b>let</b> bits_shift = (8 * (exponent - 3)) <b>as</b> u8;
        target = target &lt;&lt; bits_shift;
    };
    target
}
</code></pre>



</details>

<a name="bitcoin_spv_btc_math_u256_to_compact"></a>

## Function `u256_to_compact`

Encodes a u256 into VarInt format.
https://learnmeabitcoin.com/technical/general/compact-size/


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_u256_to_compact">u256_to_compact</a>(number: u256): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_u256_to_compact">u256_to_compact</a>(number: u256): vector&lt;u8&gt; {
    <b>let</b> <b>mut</b> ans = vector[];
    <b>let</b> <b>mut</b> n = number;
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
    } <b>else</b> <b>if</b> (n &lt;= 18446744073709551615) {
        ans.push_back(0xff);
        do!(8, |_i| {
            ans.push_back((n & 0xff) <b>as</b> u8);
            n = n &gt;&gt; 8;
        });
    } <b>else</b> {
        <b>abort</b> <a href="../bitcoin_spv/btc_math.md#bitcoin_spv_btc_math_EInvalidCompactSizeEncode">EInvalidCompactSizeEncode</a>
    };
    ans
}
</code></pre>



</details>
