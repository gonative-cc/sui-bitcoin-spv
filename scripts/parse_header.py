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


block_header = bytes.fromhex("00a0b434e99097082da749068bd8cc81f7ddd017f3153e1f25b000000000000000000000fbef99870f826601fed79703773deb9122f03b5167c0b7554c00112f9fa99e171320cf66763d03175c560dcc")

# # Read and print the block header in JSON format
# header_json = parse_block_header(block_header)
# print(header_json)

def main():
    parser = argparse.ArgumentParser(description="read raw header string")
    parser.add_argument('raw_header', type=str, help='Raw header in hexadecimal format')
    args = parser.parse_args()
    raw_header = bytes.fromhex(args.raw_header)
    header_json = parse_block_header(raw_header);
    print(header_json)

if __name__ == "__main__":
    main()
