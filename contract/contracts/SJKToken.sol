// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import "./ERC20Interface.sol";

contract SJKToken is ERC20Interface {
    mapping(address => uint256) private _balances;
    
    // 이중으로 매핑된 approvals를 확인할 수 있다
    mapping(address => mapping(address => uint256)) public _allowances;

    uint256 public _totalSupply; // 토큰 총발행량
    string public _name; // 토큰 이름
    string public _symbol; // 토큰 약자
    uint8 public _decimals; // 18진수
    uint256 private E18 = 1000000000000000000; // 토큰 총발행량 설정

    constructor(string memory getName, string memory getSymbol) {
        _name = getName;
        _symbol = getSymbol;
        _decimals = 18;
        _totalSupply = 100000000 * E18;
        _balances[msg.sender] = _totalSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // 토큰의 총 발행량 반환
    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    // 매핑된 값인 '_balanceOf'에서 입력한 address인 account가 가지고있는 토큰의 수 반환
        function balanceOf(address account)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    // 내부 함수인 '_transfer'를 호출.
    // 호출이 정상적으로 완료되었을 경우 Transfer event 를 발생시킴
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 매개변수로 받은 두개의 주소값에 대한 '_allowances' 값,
    // 즉, '내가(owner)'가 '토큰을 양도할 상대방(spender)'에게 토큰을 등록한 양을 반환한다
    function allowance(address owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        external
        virtual
        override
        returns (bool)
    {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(
            _balances[msg.sender] >= amount,
            "ERC20: The amount to be transferred exceeds the amount of tokens held by the owner."
        );
        _approve(msg.sender, spender, currentAllowance, amount);
        return true;
    }

    // 양도를 수행하는 거래 대행자(msg.sender)가 sender가 허락해준 값만큼 상대방(recipient)에게 토큰을 이동한다
    // 이동을 위해 _transfer 함수를 실행시킨다
    // '_transfer' 에서는 양도를 하는 sender 의 잔고를 amount 만큼 줄이고, recipient 의 잔고를 amount 만큼 늘린다
    // '_transfer' 함수 실행이 완료되고, require 를 모두 통과한다면 currentAllowance 를 체크하여 _approve 함수를 실행한다
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        emit Transfer(msg.sender, sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        _approve(
            sender,
            msg.sender,
            currentAllowance,
            currentAllowance - amount
        );
        return true;
    }

    // require 를 통해 세가지 조건을 검사한다
    
    // 1️⃣ 보내는 사람의 주소가 잘못되었는지 체크한다
    // 2️⃣ 받는사람의 주소가 잘못되었는지 체크한다
    // 3️⃣ transfer 함수를 실행한 사람(sender)이 가진 토큰(senderBalance)이 신청한 값(amount)보다 많은 토큰을 가지고 있는지 체크한다
    
    // 👉 위의 세 조건을 충족하는 경우,
    // 실행한 사람(sender)이 가진 토큰의 지갑에서 토큰을 개수만큼 빼고,
    // 받을 사람(recipient)의 토큰 지갑에 개수만큼 더해준다
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;
    }

    // 토큰을 양도할 상대방(spender)에게 양도할 값(amount)를 allowances 에 기록한다
    // 그리고 Approval event 를 호출하여 기록한다
    // 이 상태에서는 양도가 실제로 이루어진 것이 아니라, 양도를 할 주소와 양을 정한 것이다
    // 👉 approve는 단순 변경을 위한 함수이기 때문에 내부적으로 값을 올리고,
    // 내리는 'increaseApproval' 과 / 'decreaseApproval' 함수를 사용하기도 한다
    // approve 는 spender 가 당신의 계정으로부터 amount 한도 하에서 여러 번 출금하는 것을 허용합니다.
    // 이 함수를 여러번 호출하면, 단순히 허용량을 amount 으로 재설정한다
    function _approve(
        address owner,
        address spender,
        uint256 currentAmount,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        require(
            currentAmount == _allowances[owner][spender],
            "ERC20: invalid currentAmount"
        );
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, currentAmount, amount);
    }
}