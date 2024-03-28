# ERC-2470 Libs

This repository contains helpers for interacting with the [ERC-2470 Singleton Deployer](https://eips.ethereum.org/EIPS/eip-2470) in [forge scripts](https://book.getfoundry.sh/reference/forge/forge-script).

## Usage

Install this package via forge install:

```bash
forge install ScreamingHawk/erc2470-libs
```

Base your scripts on the `SingletonDeployer` script contract:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {SingletonDeployer, console} from "erc2470-libs/script/SingletonDeployer.s.sol";
import {MyContract} from "../src/MyContract.sol";

contract Deploy is SingletonDeployer {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        bytes32 salt = bytes32(0);
        address exampleConstructorArg = address(0);

        bytes memory initCode = abi.encodePacked(type(MyContract).creationCode, abi.encode(exampleConstructorArg));

        address expectedAddr = _singletonAddressOf(initCode, salt);
        address actualAddr = _deployIfNotAlready("MyContract", initCode, salt, pk);
    }
}
```

Ensure you have your private key set in your `.env` file:

```txt
PRIVATE_KEY=0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

Then run your script:

```bash
forge run script/Deploy.s.sol
```


> [!WARNING]
> Forge is unable to automatically verify deployments created via the `SingletonDeployer`. You will need to manually verify the contract using the `forge verify-contract` command.

### Git Hooks

To install git hooks run the following:

```bash
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```
