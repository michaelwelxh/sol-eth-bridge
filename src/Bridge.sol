// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IBridge} from "./interfaces/IBridge.sol";

contract Bridge is IBridge {
    // accept user token deposits 
    // locks/burns 
    // generates a uniquie bridge message/event
    // records processed messages/nonces
    // prevent replays
    // allows authorised messages to trigger the desitination side actions
    // support emergency pause
    function deposit(
        uint256 amount, 
        address recipient, 
        uint256 destinationChain
    ) external override {
        // lock tokens
        // create messaaeg 
        // emit the event
    }

    function pause() external override{
        // pause the bridge
        // create messaaeg 
        // emit the event
    }
    function unpause() external override {
        // pause the bridge
        // create messaaeg 
        // emit the event
    }

}
