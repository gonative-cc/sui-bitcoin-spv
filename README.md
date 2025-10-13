<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD013 -->

<!-- ![Logo!](assets/logo.png) -->

## Notice

🔀 Packages from this repository has been moved to [gonative-cc/sui-native](https://github.com/gonative-cc/sui-native/). 🔀

## Overview

This repository contains a set of primitive components for on-chain Bitcoin operations:

- [Bitcoin SPV](./packages/bitcoin_spv) - A core implementation of a Bitcoin light client using Simple Payment Verification (SPV). It manages the on-chain storage of the Bitcoin block header chain, validates new headers, and provides functions to verify transaction inclusion using Merkle proofs.

- [Bitcoin Parser](./packages/bitcoin_parser) - A low-level, foundational utility for parsing and deserializing raw Bitcoin data structures. It handles block headers, transactions, inputs, outputs, and witness data, providing the essential building blocks for the applications.

## Contributing

Participating in open source is often a highly collaborative experience. We’re encouraged to create in public view and incentivized to welcome contributions of all kinds from people around the world.

Check out [contributing repo](https://github.com/gonative-cc/contributig) for our guidelines & policies for how to contribute. Note: we require DCO! Thank you to all those who have contributed!

After cloning the repository, make sure to run `make setup-hooks`.

### Security

Check out [SECURITY.md](./SECURITY.md) for security concerns.

## Talk to us

- Follow the Native team's activities on the [Native X/Twitter account](https://x.com/NativeNetwork).
- Join the conversation on [Native Discord](https://discord.gg/gonative).
