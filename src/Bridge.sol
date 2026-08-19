// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBridge} from "./interfaces/IBridge.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

contract Bridge is IBridge, Ownable, Pausable {
    // accept user token deposits 
    // locks/burns 
    // generates a uniquie bridge message/event
    // records processed messages/nonces
    // prevent replays
    // allows authorised messages to trigger the desitination side actions
    // support emergency pause
    
    IERC20 public immutable token;

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }
    // recipt structure 


    function deposit(
        address recipient, 
        uint256 amount, 
        uint256 destinationChain
    ) external override whenNotPaused {
        // lock tokens
        require(amount > 0, "Amount must be greater then 0");
        require(recipient != address(0), "Invalid recipent");

        // user needs to first use token.approve(address(this), amount);
        token.transferFrom(
            msg.sender, 
            address(this), 
            amount
        );

        // emit the event
        function emitRecipt() public {
            emit Recipt();
        }
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
