//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    uint256 public constant TREE_DEPTH = 3;
    uint256 public constant LEAF_COUNT = 2**TREE_DEPTH;

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        for (uint256 i =0 ;i < 2 * LEAF_COUNT - 1; i++){
            hashes.push(0);
        }

        // Calculate initial root
        for (uint256 i = LEAF_COUNT - 1; i > 0; i--) {
            uint256 leftChild = hashes[2 * i-1];
            uint256 rightChild = hashes[2 * i ];
            hashes[i - 1] = PoseidonT3.poseidon([leftChild, rightChild]);
        }
        root = hashes[0];
    }

    function insertLeaf(uint256 hashedLeaf) public {
        // [assignment] insert a hashed leaf into the Merkle tree
        require(index < LEAF_COUNT, "Tree is full");

        uint256 leafIndex = index + LEAF_COUNT - 1;
        hashes[leafIndex] = hashedLeaf;

        uint256 currentIndex = leafIndex;
        for (uint256 i = 0; i < TREE_DEPTH; i++) {
            currentIndex = (currentIndex - 1) / 2;
            uint256 leftChild = hashes[2 * currentIndex + 1];
            uint256 rightChild = hashes[2 * currentIndex + 2];
            hashes[currentIndex] = PoseidonT3.poseidon([leftChild, rightChild]);
        }

        root = hashes[0];
        index++;
    }

    function verify(
            uint[2] calldata a,
            uint[2][2] calldata b,
            uint[2] calldata c,
            uint[1] calldata input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        return super.verifyProof(a, b, c, input);
    }
}
