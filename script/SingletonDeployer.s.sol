// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";

import {ISingletonFactory, SINGLETON_FACTORY_ADDR} from "../src/ISingletonFactory.sol";

error DeploymentFailed(string reason);

abstract contract SingletonDeployer is Script {
    ISingletonFactory private constant SINGLETON_FACTORY = ISingletonFactory(SINGLETON_FACTORY_ADDR);

    function _deployIfNotAlready(bytes memory _initCode, bytes32 _salt) internal {
        address expectedAddr = _singletonAddressOf(_initCode, _salt);
        if (expectedAddr.code.length <= 2) {
            console.log("Performing deployment");
            vm.startBroadcast();
            address actualAddr = SINGLETON_FACTORY.deploy(_initCode, _salt);
            vm.stopBroadcast();
            if (expectedAddr != actualAddr) revert DeploymentFailed("Deployed address mismatch");
            if (expectedAddr.code.length <= 2) revert DeploymentFailed("Deployment failed");
        } else {
            console.log("Already deployed");
        }
    }

    function _singletonAddressOf(bytes memory _initCode, bytes32 _salt) internal pure returns (address addr) {
        return address(
            uint160(
                uint256(
                    keccak256(abi.encodePacked(bytes1(0xff), address(SINGLETON_FACTORY), _salt, keccak256(_initCode)))
                )
            )
        );
    }
}
