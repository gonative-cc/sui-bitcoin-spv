
<a name="bitcoin_parser_reader"></a>

# Module `bitcoin_parser::reader`



-  [Struct `Reader`](#bitcoin_parser_reader_Reader)
-  [Constants](#@Constants_0)
-  [Function `new`](#bitcoin_parser_reader_new)
-  [Function `readable`](#bitcoin_parser_reader_readable)
-  [Function `end_stream`](#bitcoin_parser_reader_end_stream)
-  [Function `read`](#bitcoin_parser_reader_read)
-  [Function `peek`](#bitcoin_parser_reader_peek)
-  [Function `read_u32`](#bitcoin_parser_reader_read_u32)
-  [Function `read_compact_size`](#bitcoin_parser_reader_read_compact_size)
-  [Function `read_byte`](#bitcoin_parser_reader_read_byte)
-  [Function `next_opcode`](#bitcoin_parser_reader_next_opcode)
-  [Function `isOpSuccess`](#bitcoin_parser_reader_isOpSuccess)


<pre><code><b>use</b> <a href="../bitcoin_parser/encoding.md#bitcoin_parser_encoding">bitcoin_parser::encoding</a>;
</code></pre>



<a name="bitcoin_parser_reader_Reader"></a>

## Struct `Reader`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a> <b>has</b> <b>copy</b>, drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>data: vector&lt;u8&gt;</code>
</dt>
<dd>
</dd>
<dt>
<code>next_index: u64</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_parser_reader_EBadReadData"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_EBadReadData">EBadReadData</a>: vector&lt;u8&gt; = b"Invalid <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read">read</a> script";
</code></pre>



<a name="bitcoin_parser_reader_new"></a>

## Function `new`

Creates a new reader


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_new">new</a>(data: vector&lt;u8&gt;): <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_new">new</a>(data: vector&lt;u8&gt;): <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a> {
    <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a> {
        data: data,
        next_index: 0,
    }
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_readable"></a>

## Function `readable`

Checks if the next <code>len</code> bytes are readable


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_readable">readable</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>, len: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_readable">readable</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>, len: u64): bool {
    r.next_index + len &lt;= r.data.length()
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_end_stream"></a>

## Function `end_stream`

Checks if end of stream


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_end_stream">end_stream</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_end_stream">end_stream</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>): bool {
    r.next_index &gt;= r.data.length()
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_read"></a>

## Function `read`

reads <code>len</code> amount of bytes from the Reader


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read">read</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>, len: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read">read</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>, len: u64): vector&lt;u8&gt; {
    <b>let</b> buf = r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_peek">peek</a>(len);
    r.next_index = r.next_index + len;
    buf
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_peek"></a>

## Function `peek`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_peek">peek</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>, len: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_peek">peek</a>(r: &<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>, len: u64): vector&lt;u8&gt; {
    <b>assert</b>!(r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_readable">readable</a>(len), <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_EBadReadData">EBadReadData</a>);
    <b>let</b> <b>mut</b> i = r.next_index;
    <b>let</b> <b>mut</b> j = 0;
    <b>let</b> <b>mut</b> buf = vector[];
    <b>while</b> (j &lt; len) {
        buf.push_back(r.data[i]);
        j = j + 1;
        i = i + 1;
    };
    buf
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_read_u32"></a>

## Function `read_u32`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_u32">read_u32</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_u32">read_u32</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>): u32 {
    <b>let</b> v = r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read">read</a>(4);
    le_bytes_to_u64(v) <b>as</b> u32
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_read_compact_size"></a>

## Function `read_compact_size`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_compact_size">read_compact_size</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_compact_size">read_compact_size</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>): u64 {
    <b>let</b> offset = r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_byte">read_byte</a>();
    <b>if</b> (offset &lt;= 0xfc) {
        <b>return</b> offset <b>as</b> u64
    };
    <b>let</b> offset = <b>if</b> (offset == 0xfd) {
        2
    } <b>else</b> <b>if</b> (offset == 0xfe) {
        4
    } <b>else</b> {
        8
    };
    <b>let</b> v = r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read">read</a>(offset);
    le_bytes_to_u64(v)
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_read_byte"></a>

## Function `read_byte`

reads the next byte from the stream


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_byte">read_byte</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_byte">read_byte</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>): u8 {
    <b>let</b> b = r.data[r.next_index];
    r.next_index = r.next_index + 1;
    b
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_next_opcode"></a>

## Function `next_opcode`

Returns the next opcode


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_next_opcode">next_opcode</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">bitcoin_parser::reader::Reader</a>): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_next_opcode">next_opcode</a>(r: &<b>mut</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_Reader">Reader</a>): u8 {
    <b>let</b> opcode = r.<a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_read_byte">read_byte</a>();
    opcode
}
</code></pre>



</details>

<a name="bitcoin_parser_reader_isOpSuccess"></a>

## Function `isOpSuccess`

isSuccess tracks the set of op codes that are to be interpreted as op
codes that cause execution to automatically succeed.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_isOpSuccess">isOpSuccess</a>(opcode: u8): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/reader.md#bitcoin_parser_reader_isOpSuccess">isOpSuccess</a>(opcode: u8): bool {
    // https://github.com/bitcoin/bitcoin/blob/v29.0/src/script/script.cpp#L358
    opcode == 80 || opcode == 98 || (opcode &gt;= 126 && opcode &lt;= 129) ||
        (opcode &gt;= 131 && opcode &lt;= 134) || (opcode &gt;= 137 && opcode &lt;= 138) ||
        (opcode &gt;= 141 && opcode &lt;= 142) || (opcode &gt;= 149 && opcode &lt;= 153) ||
        (opcode &gt;= 187 && opcode &lt;= 254)
}
</code></pre>



</details>
