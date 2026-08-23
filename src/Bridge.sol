// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBridge} from "./interfaces/IBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract Bridge is IBridge, Ownable, Pausable {
    using SafeERC20 for IERC20;
    IERC20 public immutable token;
    uint256 public nonce;
    mapping(bytes32 => bool) public processedMessages;
    address public relayer;

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function deposit(
        address recipient,
        uint256 amount,
        uint256 destinationChain
    ) external override whenNotPaused {
        require(amount > 0, "Amount must be greater then 0");
        require(recipient != address(0), "Invalid recipent");
        bytes32 messageId = keccak256(
            abi.encode(
                block.chainid,
                address(this),
                msg.sender,
                recipient,
                amount,
                nonce
            )
        );

        nonce++;
        
        // 1. token.approve(address(this), amount);
        // 2. bridge.deposit(100 ether, recipient); and this code runs 
        token.safeTransferFrom(
            msg.sender, 
            address(this), 
            amount
        );
        // 4. then to release from bridge 'token.transfer(recipient, amount);'
        emit DepositCreated(
            messageId,
            block.chainid,
            destinationChain,
            msg.sender,
            recipient,
            amount,
            nonce
        );
    }

    function executeMessage(
        bytes32 messageId, 
        uint256 sourceChain,
        uint256 destinationChain,
        address sender, 
        address recipient, 
        uint256 amount
    ) external onlyRelay {
            // check message id
            require(!processedMessages[messageId], "Messaege already processed");
            processedMessages[messageId] = true;
            // check the recipient 
            bytes32 expectedId = keccak256(
                abi.encode(
                    sourceChain,
                    address(this),
                    sender,
                    recipient,
                    amount,
                    nonce
                )
            );
            require(expectedId == messageId, "Invalid message");
            // check the chains are correct 
            require(destinationChain == block.chainid, "Wrong chain");
            token.safeTransfer(recipient, amount);
    }

    function pause() external override onlyOwner {
        // pause the bridge
        _pause();
    }
    function unpause() external override onlyOwner {
        // pause the bridge
        _unpause();
    }

    // relay scafolding for when executeMessage is depreciated 
    modifier onlyRelay() {
        require(msg.sender == relayer, "Not relay");
        _;
    }
    function setRelayer(address _relayer) external onlyOwner {
        require(_relayer != address(0), "invalid relay");
        emit RelayUpdated(relayer, _relayer);
        relayer = _relayer;
    }
}
