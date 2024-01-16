// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract SJKToken is ERC20Capped {
    // 1 억개로 제한
    constructor(uint256 cap) ERC20("SJKToken", "SJK") ERC20Capped(cap * (10 ** decimals())){
        // 7 천만개 발행
        _mint(msg.sender, 70000000 * (10 ** uint256(decimals())));
    }
}