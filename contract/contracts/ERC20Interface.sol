// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

// 솔리디티에서 'Interface'는 사용할 함수의 형태를 선언한다
// 실제 함수의 내용은 Contract에서 사용한다
// 👉 'ERC20Interface'는 'SJKToken' 컨트랙트에서 사용할 함수의 형태를 선언하며,
// 'ERC-20' 에서 사용하는 함수들의 형태를 선언한 것을 확인할 수 있다

interface ERC20Interface {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transferFrom(
        address spender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    // 함수(function)는 이더리움에서 제공하는 함수이며, event는 이더리움에서 제공하는 로그이다
    // 'function'과 'event'를 선언할 때는 입력값과 반환값은 선택할 수 있으나,
    // 'function'의 자료형 / 이름 / 순서를 주의해야 한다

    // 'ERC20Interface'의 ⭐ 'Transfer' 이벤트는 토큰이 이동할 때마다 로그를 남기고,
    // ⭐ 'Approval' 이벤트는 'approve' 함수가 실행 될 때 로그를 남긴다
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Transfer(
        address indexed spender,
        address indexed from,
        address indexed to,
        uint256 amount
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 oldAmount,
        uint256 amount
    );
}