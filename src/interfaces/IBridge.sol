// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// add event and errors
interface IBridge {
    function deposit(
        address recipient,
        uint256 amount,
        uint256 destinationChain
    ) external;


    function executeMessage(
        bytes32 messageId, 
        uint256 sourceChain,
        uint256 destinationChain,
        address sender, 
        address recipient, 
        uint256 amount
    ) external;

    function pause() external;
    function unpause() external;
    
    event DepositCreated(
        bytes32 messageId,
        uint256 sourceChain,
        uint256 destinationChain,
        address sender,
        address recipient,
        uint256 amount,
        uint256 nonce
    );
    struct Message {
        uint256 sourceChain;
        uint256 destinationChain;
        address sender;
        address recipient;
        uint256 amount;
        uint256 nonce;
    }

    // relayer 
    event RelayUpdated(address indexed oldRelayer, address indexed newRelayer);
    function setRelayer(
        address relayer
        ) external;  

}