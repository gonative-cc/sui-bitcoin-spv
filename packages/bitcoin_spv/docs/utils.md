
<a name="(bitcoin_spv=0x0)_utils"></a>

# Module `(bitcoin_spv=0x0)::utils`



-  [Constants](#@Constants_0)
-  [Function `slice`](#(bitcoin_spv=0x0)_utils_slice)
-  [Function `nth_element`](#(bitcoin_spv=0x0)_utils_nth_element)


<pre><code></code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="(bitcoin_spv=0x0)_utils_EOutBoundIndex"></a>

=== Errors ===


<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_EOutBoundIndex">EOutBoundIndex</a>: vector&lt;u8&gt; = b"The index 'n' is out of bounds <b>for</b> the vector";
</code></pre>



<a name="(bitcoin_spv=0x0)_utils_EInvalidSliceRange"></a>



<pre><code>#[error]
<b>const</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_EInvalidSliceRange">EInvalidSliceRange</a>: vector&lt;u8&gt; = b"Invalid <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_slice">slice</a> range: start &gt;= end";
</code></pre>



<a name="(bitcoin_spv=0x0)_utils_slice"></a>

## Function `slice`

slice() extracts up to but not including end.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_slice">slice</a>(v: vector&lt;u8&gt;, start: u64, end: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_slice">slice</a>(v: vector&lt;u8&gt;, start: u64, end: u64): vector&lt;u8&gt; {
    <b>assert</b>!(start &lt; end, <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_EInvalidSliceRange">EInvalidSliceRange</a>);
    <b>assert</b>!(end &lt;= v.length(), <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_EOutBoundIndex">EOutBoundIndex</a>);
    <b>let</b> <b>mut</b> ans = vector[];
    <b>let</b> <b>mut</b> i = start;
    <b>while</b> (i &lt; end) {
        ans.push_back(v[i]);
        i = i + 1;
    };
    ans
}
</code></pre>



</details>

<a name="(bitcoin_spv=0x0)_utils_nth_element"></a>

## Function `nth_element`

returns nth smallest element in the vector v.
NOTE: it mutates the vector v.


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_nth_element">nth_element</a>(v: &<b>mut</b> vector&lt;u32&gt;, n: u64): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_nth_element">nth_element</a>(v: &<b>mut</b> vector&lt;u32&gt;, n: u64): u32 {
    <b>let</b> <b>mut</b> i = 0;
    <b>let</b> len = v.length();
    <b>assert</b>!(n &lt; len, <a href="../bitcoin_spv/utils.md#(bitcoin_spv=0x0)_utils_EOutBoundIndex">EOutBoundIndex</a>);
    <b>while</b> (i &lt;= n) {
        <b>let</b> <b>mut</b> j = i + 1;
        <b>while</b> (j &lt; len) {
            <b>if</b> (v[i] &gt; v[j]) {
                v.swap(i, j);
            };
            j = j + 1;
        };
        i = i + 1;
    };
    v[n]
}
</code></pre>



</details>
