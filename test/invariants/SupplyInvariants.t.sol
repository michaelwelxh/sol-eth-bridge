// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BridgeToken} from "../../src/BridgeToken.sol";


contract modelTokenTest is Test {
    BridgeToken token;

    //initialSupply => correct

    // inital mint
    function setUp() public {          
        token = new BridgeToken(1_000_000); // callts the constructor
    }
    
    // check the supply
    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 1_000_000);
    }
    
    // mint -> supply increases
    function testmint() public {
        token.mint(1_000_000);
        assertEq(token.totalSupply(), 2_000_000);
    }

    // burn -> supply decreases
    function testburn() public {
        token.burn(10_000);
        assertEq(token.totalSupply(), 990_000);
    }
    // non-owner mint -> reverts
    function testnonAuthmint() public {
        // set a new adress
        address attacker = address(1);

        vm.prank(attacker);
        vm.expectRevert();

        token.mint(1_000_000);
    }

    // add a test for 'burnFrom' if i want but im testing the open zep func now so not much point
}