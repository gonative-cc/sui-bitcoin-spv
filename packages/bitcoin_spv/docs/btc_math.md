
<a name="(bitcoin_spv=0x0)_btc_math"></a>

# Module `(bitcoin_spv=0x0)::btc_math`



-  [Constants](#@Constants_0)
-  [Function `to_u256`](#(bitcoin_spv=0x0)_btc_math_to_u256)
-  [Function `bytes_of`](#(bitcoin_spv=0x0)_btc_math_bytes_of)
-  [Function `get_last_32_bits`](#(bitcoin_spv=0x0)_btc_math_get_last_32_bits)
-  [Function `target_to_bits`](#(bitcoin_spv=0x0)_btc_math_target_to_bits)
-  [Function `bits_to_target`](#(bitcoin_spv=0x0)_btc_math_bits_to_target)


<pre><code></code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="(bitcoin_spv=0x0)_btc_math_EInvalidLength"></a>

=== Errors ===


<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_EInvalidLength">EInvalidLength</a>: vector&lt;u8&gt; = b"The input vector <b>has</b> an invalid length";
</code></pre>



<a name="(bitcoin_spv=0x0)_btc_math_to_u256"></a>

## Function `to_u256`

Converts 32 bytes in little endian format to u256 number.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_to_u256">to_u256</a>(v: vector&lt;u8&gt;): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_to_u256">to_u256</a>(v: vector&lt;u8&gt;): u256 {
    <b>assert</b>!(v.length() == 32, <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_EInvalidLength">EInvalidLength</a>);
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

<a name="(bitcoin_spv=0x0)_btc_math_bytes_of"></a>

## Function `bytes_of`

number of bytes to represent number.


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_bytes_of">bytes_of</a>(number: u256): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_bytes_of">bytes_of</a>(number: u256): u8 {
    <b>let</b> <b>mut</b> b: u8 = 255;
    <b>while</b> (number & (1 &lt;&lt; b) == 0 && b &gt; 0) {
        b = b - 1;
    };
    // Follow logic in bitcoin core
    ((b <b>as</b> u32) / 8 + 1) <b>as</b> u8
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_btc_math_get_last_32_bits"></a>

## Function `get_last_32_bits`

Returns last 32 bits of a number.


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_get_last_32_bits">get_last_32_bits</a>(number: u256): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_get_last_32_bits">get_last_32_bits</a>(number: u256): u32 {
    (number & 0xffffffff) <b>as</b> u32
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_btc_math_target_to_bits"></a>

## Function `target_to_bits`

target => bits conversion function.
target is the number you need to get below to mine a block - it defines the difficulty.
The bits field contains a compact representation of the target.
format of bits = <1 byte for exponent><3 bytes for coefficient>
target = coefficient * 2^ (coefficient - 3) (note: 3 = bytes length of the coefficient).
Caution:
The first significant byte for the coefficient must be below 80. If it's not, you have to take the preceding 00 as the first byte.
More & examples: https://learnmeabitcoin.com/technical/block/bits.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_target_to_bits">target_to_bits</a>(target: u256): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_target_to_bits">target_to_bits</a>(target: u256): u32 {
    // TODO: Handle case nagative target?
    // I checked bitcoin-code. They did't create any negative target.
    <b>let</b> <b>mut</b> exponent = <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_bytes_of">bytes_of</a>(target);
    <b>let</b> <b>mut</b> coefficient;
    <b>if</b> (exponent &lt;= 3) {
        <b>let</b> bits_shift: u8 = 8 * ( 3 - exponent);
        coefficient = <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_get_last_32_bits">get_last_32_bits</a>(target) &lt;&lt; bits_shift;
    } <b>else</b> {
        <b>let</b> bits_shift: u8 = 8 * (exponent - 3);
        <b>let</b> bn = target &gt;&gt; bits_shift;
        coefficient = <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_get_last_32_bits">get_last_32_bits</a>(bn)
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

<a name="(bitcoin_spv=0x0)_btc_math_bits_to_target"></a>

## Function `bits_to_target`

Converts bits to target. See documentation to the function above for more details.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_bits_to_target">bits_to_target</a>(bits: u32): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/btc_math.md#(bitcoin_spv=0x0)_btc_math_bits_to_target">bits_to_target</a>(bits: u32): u256 {
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
