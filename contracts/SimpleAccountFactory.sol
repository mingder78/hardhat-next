// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleAccount.sol";

contract SimpleAccountFactory {
    SimpleAccount public immutable accountImplementation;
    address public immutable entryPoint;

    event AccountCreated(address indexed account, address indexed owner);

    constructor(address _entryPoint) {
        entryPoint = _entryPoint;
        accountImplementation = new SimpleAccount(_entryPoint);
    }

    // Deploy a SimpleAccount using CREATE2
    function createAccount(address owner, bytes32 salt) public returns (SimpleAccount) {
        // Compute the address using CREATE2
        address accountAddress = computeAddress(owner, salt);
        
        // Check if account already exists
        if (accountAddress.code.length == 0) {
            SimpleAccount account = new SimpleAccount{salt: salt}(entryPoint);
            account.initialize(owner);
            emit AccountCreated(address(account), owner);
        }
        return SimpleAccount(payable(entryPoint));
    }

    // Predict the account address for a given owner and salt
    function computeAddress(address /*owner*/, bytes32 salt) public view returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(SimpleAccount).creationCode,
                abi.encode(entryPoint)
            ))
        )))));
    }
}