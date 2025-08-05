# SPDX-License-Identifier: MPL-2.0

import hashlib
import json


def double_sha256(data):
    data_bytes = bytes.fromhex(data)
    return hashlib.sha256(hashlib.sha256(data_bytes).digest()).hexdigest()

def single_sha256(data):
     data_bytes = bytes.fromhex(data)
     return hashlib.sha256(data_bytes).hexdigest()


def merkle_root(hashes):
    """Computes the Merkle root from a list of hashes using double SHA-256."""
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


def merkle_proof(transaction_hash, all_hashes, single_hashes):
    """Computes the Merkle proof for a specific transaction hash."""
    proof = []

    # Find the position of the transaction in the list of all hashes
    index = all_hashes.index(transaction_hash)

    # Generate the proof by traversing up the tree
    while len(all_hashes) > 1:
        # If the index is even, get the next hash as the sibling
        if index % 2 == 0:
            if index + 1 < len(all_hashes):
                proof.append(single_hashes[index + 1])
            else:
                proof.append(single_hashes[index])  # If odd number, duplicate the last


        # If the index is odd, get the previous hash as the sibling
        else:
            proof.append(single_hashes[index - 1])
            # print(all_hashes[index - 1]);
            # print(single_hashes[index - 1]);
            # print("\n")
        if len(all_hashes) % 2 != 0:
            all_hashes.append(all_hashes[-1])


        # Pair up the hashes and hash them again
        single_hashes = [
            single_sha256(all_hashes[i] + all_hashes[i + 1])
            for i in range(0, len(single_hashes), 2)
        ]

        all_hashes = [
            double_sha256(all_hashes[i] + all_hashes[i + 1])
            for i in range(0, len(all_hashes), 2)
        ]

        index = index // 2  # Move up one level in the tree

    print(all_hashes)
    return proof


# Example transaction hashes (replace with actual transaction hashes)


def big_endian_to_little_endian(hex_str):
    """Converts a big-endian hex string to little-endian."""
    # Ensure the hex string has an even length, as each byte is 2 characters
    if len(hex_str) % 2 != 0:
        raise ValueError("Hex string must have an even length.")

    # Reverse the order of bytes (pair of hex characters)
    little_endian = "".join(
        [hex_str[i : i + 2] for i in range(0, len(hex_str), 2)][::-1]
    )

    return little_endian


def main():
    with open(
        "0000000000000000006a446097f7b1eb970ac12dee4e5ced95ad1a3f38a67a46.txt"
    ) as file:
        data = json.load(file)
    tx_hashes = data["tx"]

    # Transaction index we downloaded from learnmeabitcoin is big-endian format.
    # We need to convert it to little-endian
    all_hashes = list(map(big_endian_to_little_endian, tx_hashes))
    single_hashes = list(map(big_endian_to_little_endian, tx_hashes))

    # Compute Merkle root
    merkle_root_hash = merkle_root(all_hashes)
    print(f"Merkle root: {merkle_root_hash}")

    tx_hash = all_hashes[604]
    proof = merkle_proof(tx_hash, all_hashes, single_hashes)

    proof_with_prefix = [f'x"{hash_value}"' for hash_value in proof]
    print(f"Merkle Proof for {tx_hash}: [{', '.join(proof_with_prefix)}]")


def other_main():
    # data from block https://learnmeabitcoin.com/explorer/block/00000000000306f827d8cc344b91a2a74074e3e1800e523ead74a20a915db27c
    tx_raw = [
        "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff07044c86041b0152ffffffff014034152a01000000434104216220ab283b5e2871c332de670d163fb1b7e509fd67db77997c5568e7c25afd988f19cd5cc5aec6430866ec64b5214826b28e0f7a86458073ff933994b47a5cac00000000",
        "01000000042a40ae58b06c3a61ae55dbee05cab546e80c508f71f24ef0cdc9749dac91ea5f000000004a49304602210089c685b37903c4aa62d984929afeaca554d1641f9a668398cd228fb54588f06b0221008a5cfbc5b0a38ba78c4f4341e53272b9cd0e377b2fb740106009b8d7fa693f0b01ffffffff7b999491e30af112b11105cb053bc3633a8a87f44740eb158849a76891ff228b00000000494830450221009a4aa8663ff4017063d2020519f2eade5b4e3e30be69bf9a62b4e6472d1747b2022021ee3b3090b8ce439dbf08a5df31e2dc23d68073ebda45dc573e8a4f74f5cdfc01ffffffffdea82ec2f9e88e0241faa676c13d093030b17c479770c6cc83239436a4327d49000000004a493046022100c29d9de71a34707c52578e355fa0fdc2bb69ce0a957e6b591658a02b1e039d69022100f82c8af79c166a822d305f0832fb800786d831aea419069b3aed97a6edf8f02101fffffffff3e7987da9981c2ae099f97a551783e1b21669ba0bf3aca8fe12896add91a11a0000000049483045022100e332c81781b281a3b35cf75a5a204a2be451746dad8147831255291ebac2604d02205f889a2935270d1bf1ef47db773d68c4d5c6a51bb51f082d3e1c491de63c345601ffffffff0100c817a8040000001976a91420420e56079150b50fb0617dce4c374bd61eccea88ac00000000",
        "010000000265a7293b2d69ba51d554cd32ac7586f7fbeaeea06835f26e03a2feab6aec375f000000004a493046022100922361eaafe316003087d355dd3c0ef3d9f44edae661c212a28a91e020408008022100c9b9c84d53d82c0ba9208f695c79eb42a453faea4d19706a8440e1d05e6cff7501fffffffff6971f00725d17c1c531088144b45ed795a307a22d51ca377c6f7f93675bb03a000000008b483045022100d060f2b2f4122edac61a25ea06396fe9135affdabc66d350b5ae1813bc6bf3f302205d8363deef2101fc9f3d528a8b3907e9d29c40772e587dcea12838c574cb80f801410449fce4a25c972a43a6bc67456407a0d4ced782d4cf8c0a35a130d5f65f0561e9f35198349a7c0b4ec79a15fead66bd7642f17cc8c40c5df95f15ac7190c76442ffffffff0200f2052a010000001976a914c3f537bc307c7eda43d86b55695e46047b770ea388ac00cf7b05000000001976a91407bef290008c089a60321b21b1df2d7f2202f40388ac00000000",
        "01000000014ab7418ecda2b2531eef0145d4644a4c82a7da1edd285d1aab1ec0595ac06b69000000008c493046022100a796490f89e0ef0326e8460edebff9161da19c36e00c7408608135f72ef0e03e0221009e01ef7bc17cddce8dfda1f1a6d3805c51f9ab2f8f2145793d8e85e0dd6e55300141043e6d26812f24a5a9485c9d40b8712215f0c3a37b0334d76b2c24fcafa587ae5258853b6f49ceeb29cd13ebb76aa79099fad84f516bbba47bd170576b121052f1ffffffff0200a24a04000000001976a9143542e17b6229a25d5b76909f9d28dd6ed9295b2088ac003fab01000000001976a9149cea2b6e3e64ad982c99ebba56a882b9e8a816fe88ac00000000"
    ]

    all_hashes = list(map(double_sha256, tx_raw))
    single_hashes = list(map(single_sha256, tx_raw))
    print(all_hashes);
     # Compute Merkle root
    merkle_root_hash = merkle_root(all_hashes)
    print(f"Merkle root: {merkle_root_hash}")


    tx_hash = all_hashes[1]
    proof = merkle_proof(tx_hash, all_hashes, single_hashes)
    # print(f"Merkle Proof for {tx_hash}: {proof}")

    proof_with_prefix = [f'x"{hash_value}"' for hash_value in proof]
    print(f"Merkle Proof for {tx_hash}: [{', '.join(proof_with_prefix)}]")

if __name__ == "__main__":
    other_main()
