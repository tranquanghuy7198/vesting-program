/* SPDX-License-Identifier: UNLICENSED */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VIKToken is ERC20 {
    constructor() ERC20("VIK", "Vikingdom Token") {}

    function faucet(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
