// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// SJKToken 컨트랙트는 ERC20Capped, ERC20Burnable 를 상속받음
contract SJKToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    // Token design == 블록 보상량 선언
    uint256 public blockReward;
     
    // 초기화
    // 1 억개로 제한
    constructor(uint256 cap, uint256 reward) ERC20("SJKToken", "SJK") ERC20Capped(cap * (10 ** decimals())){
        owner = payable(msg.sender);
        // 초기 토큰 발행량 == 7 천만개
        _mint(msg.sender, 70000000 * (10 ** uint256(decimals())));
        // 블록 보상량 설정
        blockReward = reward * (10 ** uint256(decimals()));
    }

    // ERC20Burnable 컨트랙트에서 상속된 _update 함수를 제거
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) {}

    function mint(address account, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        _mint(account, amount);
        // 특정 조건에 따라 새로운 토큰 발행 == 보상
        if (account != address(0) && account != block.coinbase && block.coinbase != address(0)) {
            _mintReward();
        }
    }
    
    // 채굴자에게 보상을 제공하는 함수
    function _mintReward() internal {
        // 블록 채굴자에게 보상 토큰을 발행
        _mint(block.coinbase, blockReward);
    }
    
    // 블록 보상량을 변경하는 함수, Owner 만 호출 가능
    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** uint256(decimals()));
    }
    
    // 컨트랙트 소멸 함수, 소유자로 지정된 주소로 컨트랙트에 남아있는 잔액 송금
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    
    // 소유자(Owner) 만 호출 가능한 조건 선언
    modifier onlyOwner {
        require(msg.sender == owner, "only the owner can call this function");
        _; // modifier 내용을 실행하고 함수 본문으로 이동
    }
}
