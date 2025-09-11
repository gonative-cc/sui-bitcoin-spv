
<a name="bitcoin_spv_params"></a>

# Module `bitcoin_spv::params`



-  [Struct `Params`](#bitcoin_spv_params_Params)
-  [Constants](#@Constants_0)
-  [Function `mainnet`](#bitcoin_spv_params_mainnet)
-  [Function `testnet`](#bitcoin_spv_params_testnet)
-  [Function `regtest`](#bitcoin_spv_params_regtest)
-  [Function `blocks_pre_retarget`](#bitcoin_spv_params_blocks_pre_retarget)
-  [Function `power_limit`](#bitcoin_spv_params_power_limit)
-  [Function `power_limit_bits`](#bitcoin_spv_params_power_limit_bits)
-  [Function `target_timespan`](#bitcoin_spv_params_target_timespan)
-  [Function `pow_no_retargeting`](#bitcoin_spv_params_pow_no_retargeting)
-  [Function `is_correct_init_height`](#bitcoin_spv_params_is_correct_init_height)
-  [Function `skip_difficulty_check`](#bitcoin_spv_params_skip_difficulty_check)


<pre><code></code></pre>



<a name="bitcoin_spv_params_Params"></a>

## Struct `Params`



<pre><code><b>public</b> <b>struct</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code><a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>: u256</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>: u32</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>: u64</code>
</dt>
<dd>
</dd>
<dt>
<code><a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>: u64</code>
</dt>
<dd>
 time in seconds when we update the target
</dd>
<dt>
<code>difficulty_adjustment: u8</code>
</dt>
<dd>
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="bitcoin_spv_params_DIFFICULTYADJUSTMENT_MAINNET"></a>



<pre><code><b>const</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_MAINNET">DIFFICULTYADJUSTMENT_MAINNET</a>: u8 = 0;
</code></pre>



<a name="bitcoin_spv_params_DIFFICULTYADJUSTMENT_V3"></a>



<pre><code><b>const</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_V3">DIFFICULTYADJUSTMENT_V3</a>: u8 = 1;
</code></pre>



<a name="bitcoin_spv_params_DIFFICULTYADJUSTMENT_REGTEST"></a>



<pre><code><b>const</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_REGTEST">DIFFICULTYADJUSTMENT_REGTEST</a>: u8 = 2;
</code></pre>



<a name="bitcoin_spv_params_mainnet"></a>

## Function `mainnet`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_mainnet">mainnet</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_mainnet">mainnet</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
    <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>: 0x1d00ffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>: 2016,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>: 2016 * 60 * 10, // ~ 2 weeks.
        difficulty_adjustment: <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_MAINNET">DIFFICULTYADJUSTMENT_MAINNET</a>,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_params_testnet"></a>

## Function `testnet`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_testnet">testnet</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_testnet">testnet</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
    <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>: 0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>: 0x1d00ffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>: 2016,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>: 2016 * 60 * 10, // ~ 2 weeks.
        difficulty_adjustment: <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_V3">DIFFICULTYADJUSTMENT_V3</a>,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_params_regtest"></a>

## Function `regtest`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_regtest">regtest</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_regtest">regtest</a>(): <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
    <a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a> {
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>: 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>: 0x207fffff,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>: 2016,
        <a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>: 2016 * 60 * 10, // ~ 2 weeks.
        difficulty_adjustment: <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_REGTEST">DIFFICULTYADJUSTMENT_REGTEST</a>,
    }
}
</code></pre>



</details>

<a name="bitcoin_spv_params_blocks_pre_retarget"></a>

## Function `blocks_pre_retarget`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): u64 {
    p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_params_power_limit"></a>

## Function `power_limit`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): u256
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): u256 {
    p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit">power_limit</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_params_power_limit_bits"></a>

## Function `power_limit_bits`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): u32
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): u32 {
    p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_power_limit_bits">power_limit_bits</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_params_target_timespan"></a>

## Function `target_timespan`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): u64 {
    p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_target_timespan">target_timespan</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_params_pow_no_retargeting"></a>

## Function `pow_no_retargeting`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_pow_no_retargeting">pow_no_retargeting</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_pow_no_retargeting">pow_no_retargeting</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): bool {
    p.difficulty_adjustment == <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_REGTEST">DIFFICULTYADJUSTMENT_REGTEST</a>
}
</code></pre>



</details>

<a name="bitcoin_spv_params_is_correct_init_height"></a>

## Function `is_correct_init_height`



<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_is_correct_init_height">is_correct_init_height</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>, h: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(package) <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_is_correct_init_height">is_correct_init_height</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>, h: u64): bool {
    p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>() == 0 || h % p.<a href="../bitcoin_spv/params.md#bitcoin_spv_params_blocks_pre_retarget">blocks_pre_retarget</a>() == 0
}
</code></pre>



</details>

<a name="bitcoin_spv_params_skip_difficulty_check"></a>

## Function `skip_difficulty_check`



<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_skip_difficulty_check">skip_difficulty_check</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">bitcoin_spv::params::Params</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="../bitcoin_spv/params.md#bitcoin_spv_params_skip_difficulty_check">skip_difficulty_check</a>(p: &<a href="../bitcoin_spv/params.md#bitcoin_spv_params_Params">Params</a>): bool {
    p.difficulty_adjustment == <a href="../bitcoin_spv/params.md#bitcoin_spv_params_DIFFICULTYADJUSTMENT_V3">DIFFICULTYADJUSTMENT_V3</a>
}
</code></pre>



</details>
