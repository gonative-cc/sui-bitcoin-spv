import hashlib
import json

def double_sha256(data):
    data_bytes = bytes.fromhex(data)
    return hashlib.sha256(hashlib.sha256(data_bytes).digest()).hexdigest()

def merkle_root(hashes):
    """ Computes the Merkle root from a list of hashes using double SHA-256. """
    if len(hashes) == 1:
        return hashes[0]

    # If odd number of hashes, duplicate the last one
    if len(hashes) % 2 != 0:
        hashes.append(hashes[-1])

    # Hash pairs and keep reducing
    new_hashes = []
    for i in range(0, len(hashes), 2):
        combined_hash = double_sha256(hashes[i] + hashes[i + 1])
        new_hashes.append(combined_hash)

    return merkle_root(new_hashes)

def merkle_proof(transaction_hash, all_hashes):
    """ Computes the Merkle proof for a specific transaction hash. """
    proof = []

    # Find the position of the transaction in the list of all hashes
    index = all_hashes.index(transaction_hash)

    # Generate the proof by traversing up the tree
    while len(all_hashes) > 1:
        # If the index is even, get the next hash as the sibling
        if index % 2 == 0:
            if index + 1 < len(all_hashes):
                proof.append(all_hashes[index + 1])
            else:
                proof.append(all_hashes[index])  # If odd number, duplicate the last
        # If the index is odd, get the previous hash as the sibling
        else:
            proof.append(all_hashes[index - 1])
        if len(all_hashes) % 2 != 0:
            all_hashes.append(all_hashes[-1])

        # Pair up the hashes and hash them again
        all_hashes = [double_sha256(all_hashes[i] + all_hashes[i + 1]) for i in range(0, len(all_hashes), 2)]
        index = index // 2  # Move up one level in the tree

    return proof

# Example transaction hashes (replace with actual transaction hashes)




def big_endian_to_little_endian(hex_str):
    """Converts a big-endian hex string to little-endian."""
    # Ensure the hex string has an even length, as each byte is 2 characters
    if len(hex_str) % 2 != 0:
        raise ValueError("Hex string must have an even length.")

    # Reverse the order of bytes (pair of hex characters)
    little_endian = ''.join([hex_str[i:i+2] for i in range(0, len(hex_str), 2)][::-1])

    return little_endian



def main():
    with open('0000000000000000006a446097f7b1eb970ac12dee4e5ced95ad1a3f38a67a46.txt') as file:
            data = json.load(file)
    tx_hashes =  data["tx"]
    tx_hashes = list(map(big_endian_to_little_endian, tx_hashes))
    # Compute Merkle root
    merkle_root_hash = merkle_root(tx_hashes)
    print(f'Merkle root: {merkle_root_hash}')

    tx_hash = tx_hashes[604];
    proof = merkle_proof(tx_hash, tx_hashes)
    # print(f"Merkle Proof for {tx_hash}: {proof}")

    proof_with_prefix = [f'x"{hash_value}"' for hash_value in proof]
    print(f"Merkle Proof for {tx_hash}: [{', '.join(proof_with_prefix)}]")



if __name__=="__main__":
    main()
