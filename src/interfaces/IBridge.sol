// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IBridge {
    function deposit(
        uint256 amount, 
        address recipient, 
        uint256 destinationChain
    ) external;

    function pause() external;
    function unpause() external;

}