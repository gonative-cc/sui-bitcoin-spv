# Light Client Initializer

This script initializes a Bitcoin SPV light client on the Sui network using parameters from a `.env` file.

## Setup

**Requirements:** Node.js, Sui CLI.

```bash
npm install
```

## Usage

1.  **Publish the Sui package** to your target network and copy the resulting `Package ID`.

    ```bash
    sui client publish
    ```

2.  **Configure your environment.** Create a `.env` file (see the example below) and populate it. Ensure the `SPV_PACKAGE_ID`, `PARSER_PACKAGE_ID` and `NETWORK` match the publish output.

3.  **Run the script** to create the light client object on-chain.

    ```bash
    bun new_light_client.js
    ```

---

## `.env` example

```dotenv
# Sui wallet mnemonic
MNEMONIC='word1 word2 word3 ...'

# ID of the deployed light client package
SPV_PACKAGE_ID='0x...'

# ID of the deployed bitcoin parser package
PARSER_PACKAGE_ID='0x...'

# Sui network alias ('mainnet', 'testnet', 'devnet', 'localnet')
NETWORK='testnet'

# Comma-separated list of hex-encoded Bitcoin block headers
HEADERS='0xheader1,0xheader2,...'

# Bitcoin network identifier (0:mainnet, 1:testnet, 2:regtest)
BTC_NETWORK=2

# Starting block height
BTC_HEIGHT=0

# Initial parent chain work
PARENT_CHAIN_WORK=0

# Confirmation depth requirement. Confirmation depth is inclusive. Meaning the block that the transaction is included in is already the first confirmation.
CONFIRMATION_DEPTH=3
```
