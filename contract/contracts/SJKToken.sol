// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SJKToken is ERC20 {
    constructor() ERC20("SJKToken", "SJK") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}