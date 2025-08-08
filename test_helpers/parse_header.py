# SPDX-License-Identifier: MPL-2.0

import json
import argparse

def parse_block_header(block_header):
    version = block_header[0:4].hex()
    prev_block_hash = block_header[4:36].hex()
    merkle_root = block_header[36:68].hex()
    timestamp = block_header[68:72].hex()
    difficulty_target = block_header[72:76].hex()
    nonce = block_header[76:80].hex()

    # Create a dictionary with all the parsed fields
    block_header_json = {
        "version": version,
        "previous_block_hash": prev_block_hash,
        "merkle_root": merkle_root,
        "timestamp": timestamp,
        "difficulty_target": difficulty_target,
        "nonce": nonce
    }

    return json.dumps(block_header_json, indent=4)


def main():
    parser = argparse.ArgumentParser(description="read raw header string")
    parser.add_argument('raw_header', type=str, help='Raw header in hexadecimal format')
    args = parser.parse_args()
    raw_header = bytes.fromhex(args.raw_header)
    header_json = parse_block_header(raw_header);
    print(header_json)

if __name__ == "__main__":
    main()
