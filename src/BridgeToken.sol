// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Ownable} from"@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract BridgeToken is Ownable, ERC20, ERC20Burnable {

    // ERC-20 test token used for the bridge 
    // need to control minting 
    constructor(uint256 initialSupply) ERC20("BridgeTestToken", "BTT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

}