
<a name="bitcoin_parser_vector_utils"></a>

# Module `bitcoin_parser::vector_utils`



-  [Constants](#@Constants_0)
-  [Function `vector_slice`](#bitcoin_parser_vector_utils_vector_slice)


<pre><code></code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_parser_vector_utils_EOutOfBounds"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils_EOutOfBounds">EOutOfBounds</a>: vector&lt;u8&gt; = b"Slice out of bounds";
</code></pre>



<a name="bitcoin_parser_vector_utils_vector_slice"></a>

## Function `vector_slice`

Returns slice of a vector for a given range [start_index ,end_index).


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils_vector_slice">vector_slice</a>&lt;T: <b>copy</b>, drop&gt;(source: &vector&lt;T&gt;, start_index: u64, end_index: u64): vector&lt;T&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils_vector_slice">vector_slice</a>&lt;T: <b>copy</b> + drop&gt;(
    source: &vector&lt;T&gt;,
    start_index: u64,
    end_index: u64,
): vector&lt;T&gt; {
    <b>assert</b>!(start_index &lt;= end_index, <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils_EOutOfBounds">EOutOfBounds</a>);
    <b>assert</b>!(end_index &lt;= source.length(), <a href="../bitcoin_parser/vector_utils.md#bitcoin_parser_vector_utils_EOutOfBounds">EOutOfBounds</a>);
    <b>let</b> <b>mut</b> slice = vector::empty&lt;T&gt;();
    <b>let</b> <b>mut</b> i = start_index;
    <b>while</b> (i &lt; end_index) {
        slice.push_back(source[i]);
        i = i + 1;
    };
    slice
}
</code></pre>



</details>
