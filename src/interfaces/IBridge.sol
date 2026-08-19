// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// add event and errors
interface IBridge {
    function deposit(
        address recipient, 
        uint256 amount, 
        uint256 destinationChain
    ) external;

    function pause() external;
    function unpause() external;
    
    struct Deposit {
        address sender;
        address recipient;
        uint256 amount;
        uint256 destinationChain;
        bytes32 messageId;
    }
    
    // create messaaeg 
    event Recipt();

}