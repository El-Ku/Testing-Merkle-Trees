//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {WhitelistedERC20} from "src/WhitelistedERC20.sol";
import {Merkle} from "murky/src/Merkle.sol";

contract WhitelistedERC20Test is Test, Merkle {

	WhitelistedERC20 wlErc20;
	uint256 constant NUM_WL_ADDR = 100;  //number of address whitelisted
	bytes32[] leafs;  // leafs, which are hashes of the whitelisted addresses
	function setUp() external {
		// generate leafs from 1 to NUM_WL_ADDR in a loop and add their hashes to a bytes32 array.
		bytes32 root;
		for (uint256 i=1; i <= NUM_WL_ADDR; i++) {
			leafs.push(keccak256(abi.encodePacked(address(uint160(i)))));  //encoding done to convert to bytes
		}
		assertEq(leafs.length, NUM_WL_ADDR);
		//generate root from the hashes.
		root = getRoot(leafs);    /// function from the Murky repo

		// deploy the contract to be tested. pass the root via constructor
		wlErc20 = new WhitelistedERC20(root);

	}

	// test for addresses which are not in the whitelist. They should revert. Fuzzing.
	function testCanMintByWLAddressesOnly(address minter) external {
		vm.assume(uint160(minter) > NUM_WL_ADDR);  //condition for test to continue.

		bytes32[] memory tamperedLeafs = leafs;
		//replace the last leaf with the new address's hash who is not whitelisted.
		tamperedLeafs[NUM_WL_ADDR-1] = keccak256(abi.encodePacked(minter));
		//create its proof 
		bytes32[] memory proof = getProof(tamperedLeafs, NUM_WL_ADDR-1);
		
		// prank and call the mint function with the above generated proof. It should revert for test to pass.
		vm.prank(minter);
		vm.expectRevert();
		wlErc20.mint(minter, 1 ether, proof);
	}

	// test for addresses which are in the whitelist. Fuzzing.
	function testCanMintByWLAddresses(address minter) external {
		//conditions for test to continue.
		vm.assume(uint160(minter) < NUM_WL_ADDR);
		vm.assume(uint160(minter) > 0);

		uint256 node = uint256( uint160(minter) - 1 ); //node index
		bytes32[] memory proof = getProof(leafs, node);  //get the proof
		
		// prank and call the mint function with the above generated proof. It should mint correctly.
		vm.prank(minter);
		wlErc20.mint(minter, 1 ether, proof);
		assertEq(wlErc20.balanceOf(minter), 1 ether);  //balance check
	}

}