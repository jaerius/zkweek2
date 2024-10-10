pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    signal intermidiate[2**n-1]; // leaves의 hash값을 저장할 level이 1 높은 배열

    for (var i =0 ; i< 2**n; i++){
        intermidiate[i] = leaves[i];
    }

    for(var level = 0; level < n; level++){
        var levelSize = 2**(n-level);
        var halfSize = levelSize \ 2;

        for(var i = 0; i < levelSize; i++){
            intermidiate[i] = poseidon([intermidiate[2*i], intermidiate[2*i+1]]);
        }

    }

    root <== intermidiate[0];

    
    

}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
}