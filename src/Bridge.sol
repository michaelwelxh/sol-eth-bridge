// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBridge} from "./interfaces/IBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Bridge is IBridge, Ownable, Pausable {
    // accept user token deposits 
    // locks/burns 
    // generates a uniquie bridge message/event
    // records processed messages/nonces
    // prevent replays
    // allows authorised messages to trigger the desitination side actions
    // support emergency pause

    // used to check the transfere succeded
    using SafeERC20 for IERC20;
    IERC20 public immutable token;
    uint256 public nonce;


    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }


    function deposit(
        address recipient,
        uint256 amount,
        uint256 destinationChain
    ) external override whenNotPaused {
        // lock tokens
        require(amount > 0, "Amount must be greater then 0");
        require(recipient != address(0), "Invalid recipent");

        bytes32 messageId = keccak256(
            abi.encode(
                block.chainid,
                address(this),
                msg.sender,
                recipient,
                amount,
                destinationChain,
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

        // emit the event
        emit DepositCreated(
            msg.sender,
            recipient,
            amount,
            destinationChain,
            messageId
        );
    }

    function pause() external override onlyOwner {
        // pause the bridge
        _pause();
    }
    function unpause() external override onlyOwner {
        // pause the bridge
        _unpause();
    }

}
