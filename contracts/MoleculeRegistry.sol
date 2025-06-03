// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../artifacts/Verifier.sol";

contract MoleculeRegistry {
    Verifier public immutable verifier;
    mapping(bytes32 => address) public ownerOf;

    event MoleculeRegistered(bytes32 hash, address owner);

    constructor(address _verifier) {
        verifier = Verifier(_verifier);
    }

    function register(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB, 
        uint[2] calldata _pC,
        bytes32 moleculeHash
    ) external {
        // Convert calldata to memory for the verifier
        uint[2] memory pA = [_pA[0], _pA[1]];
        uint[2][2] memory pB = [[_pB[0][0], _pB[0][1]], [_pB[1][0], _pB[1][1]]];
        uint[2] memory pC = [_pC[0], _pC[1]];
        
        require(verifier.verifyProof(pA, pB, pC), "Invalid ZK proof");
        require(ownerOf[moleculeHash] == address(0), "Molecule already registered");

        ownerOf[moleculeHash] = msg.sender;
        emit MoleculeRegistered(moleculeHash, msg.sender);
    }

    function getOwner(bytes32 hash) external view returns (address) {
        return ownerOf[hash];
    }
}