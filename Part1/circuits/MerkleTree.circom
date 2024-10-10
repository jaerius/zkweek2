pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    signal intermediate[2**n-1]; // leaves의 hash값을 저장할 level이 1 높은 배열

    for (var i =0 ; i< 2**n; i++){
        intermediate[i] = leaves[i];
    }

    for(var level = 0; level < n; level++){
        var levelSize = 2**(n-level-1);
        var halfSize = levelSize \ 2;

        for(var i = 0; i < levelSize; i++){
            intermediate[i] = Poseidon([intermediate[2*i], intermediate[2*i+1]]);
        }

    }
     root <== intermediate[0];
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input pathIndices[n];
    signal input siblings[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    component poseidons[n];
    component mux[n];

    signal hashes[n+1];
    hashes[0] <== leaf;

    for (var i = 0; i < n; i++){

        pathIndices[i] * (1 - pathIndices[i]) === 0;

        poseidons[i] = Poseidon(2);
        mux[i] = MultiMux1(2);

        mux[i].c[0][0] <== hashes[i];
        mux[i].c[0][1] <== siblings[i];

        mux[i].c[1][0] <== siblings[i];
        mux[i].c[1][1] <== hashes[i];

        mux[i].s <== pathIndices[i];

        poseidons[i].inputs[0] <== mux[i].out[0];
        poseidons[i].inputs[1] <== mux[i].out[1];

        hashes[i+1] <== poseidons[i].out;
    }

    root <== hashes[n];
}