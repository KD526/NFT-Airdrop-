// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC1155} from "@openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";
import {MerkleProof} from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";

contract AirDropPoC is ERC1155, Ownable {
    uint256 public constant NFT_ID = 1;
    bytes32 public merkleRoot;

    constructor() ERC1155("https://www.youtube.com/watch?v=9Tf8CXdLlvM") { }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function airdropNFT(address[] calldata _recipients, bytes32[][] calldata _merkleProofs) external onlyOwner {
        require(_recipients.length == _merkleProofs.length, "Mismatched arrays");

        for (uint256 i = 0; i < _recipients.length; i++) {
            bytes32 leaf = keccak256(abi.encodePacked(_recipients[i]));
            require(MerkleProof.verify(_merkleProofs[i], merkleRoot, leaf), "Invalid proof");

            _mint(_recipients[i], NFT_ID, 1, "");
        }
    }
}

