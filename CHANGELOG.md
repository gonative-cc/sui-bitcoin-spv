<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD024 -->

<!--
Changelogs are for humans, not machines.
There should be an entry for every single version.
The same types of changes should be grouped.
The latest version comes first.
The release date of each version is displayed.

Usage:

Change log entries are to be added to the Unreleased section and in one of the following subsections: Features, Breaking Changes, Bug Fixes. Example entry:

* [#<PR-number>](https://github.com/gonative-cc/move-bitcoin-spv/pull/<PR-number>) <description>
-->

# CHANGELOG

## Unreleased


### Features

- [#127](https://github.com/gonative-cc/sui-bitcoin-spv/pull/127) feat: add btc_parser package
- [#115](https://github.com/gonative-cc/sui-bitcoin-spv/pull/115) feat: use BlockHeader type in smart contract method's parameters / PTB friendly
- [#114](https://github.com/gonative-cc/sui-bitcoin-spv/pull/114) feat: use sui::table to store headers

### Breaking Changes

- [#106](https://github.com/gonative-cc/sui-bitcoin-spv/pull/106) feat: mitigate Merkle tree leaf-node weakness
- [#116](https://github.com/gonative-cc/sui-bitcoin-spv/pull/116) feat: simplify initialize for light client
- [#117](https://github.com/gonative-cc/sui-bitcoin-spv/pull/117) remove verify_payment method from light client

### Bug Fixes

## v0.3.1 (2024-04-10)

### Bug Fixes

- [#78](https://github.com/gonative-cc/sui-bitcoin-spv/pull/78) fix: parse P2WPHK output

## v0.3.0 (2024-04-04)

This is our first official testnet release.
