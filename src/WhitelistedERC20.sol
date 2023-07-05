//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {ERC20} from "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {MerkleProof} from "@openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract WhitelistedERC20 is ERC20 {

	using MerkleProof for bytes32[];  //OZ library

	bytes32 immutable root;

	constructor(bytes32 _root) ERC20("WL ERC20", "WLE") {
		root = _root;  //set Merkle root
	}

	// Whitelisted address can mint to any address
	function mint(address to, uint256 amount, bytes32[] memory proof) external {
		bool merkleTestSuccess = proof.verify(root, keccak256(abi.encodePacked(msg.sender)));  //check if the proof is correct
		require(merkleTestSuccess, "Address not whitelisted to mint");
		_mint(to, amount);
	}

	// Whitelisted address can burn from its own wallet
	function burn(uint256 amount, bytes32[] memory proof) external {
		bool merkleTestSuccess = proof.verify(root, keccak256(abi.encodePacked(msg.sender)));   //check if the proof is correct
		require(merkleTestSuccess, "Address not whitelisted to burn");
		_burn(msg.sender, amount);
	}
	
}