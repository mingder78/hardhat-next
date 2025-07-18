// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/community-contracts/account/Account.sol";

// A simple ERC-4337 account with ECDSA signature validation
contract SimpleAccount is Account, EIP712, Initializable, OwnableUpgradeable, UUPSUpgradeable {

    constructor(address entryPoint_) EIP712("SimpleAccount", "1") Account() {}

    // Initialize the account with an owner address
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }

    // Required by UUPSUpgradeable: only owner can upgrade
    function _authorizeUpgrade(address) internal view override onlyEntryPointOrSelf {
        require(msg.sender == owner(), "Only owner can upgrade");
    }

    // Implement the AbstractSigner._rawSignatureValidation
    function _rawSignatureValidation(bytes32 hash, bytes calldata signature)
        internal
        view
        override
        returns (bool)
    {
        (address recovered, ECDSA.RecoverError error,) = ECDSA.tryRecover(hash, signature);
        return error == ECDSA.RecoverError.NoError && recovered == owner();
    }

    // Fallback to receive ETH
    receive() external payable override {}
}