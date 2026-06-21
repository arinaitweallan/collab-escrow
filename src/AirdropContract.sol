// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract AirdropContract {
    // --- errors ---
    error NotEligible();
    error NotClaimAmount();
    error Unauthorized();
    error AlreadyAdded();
    error InvalidAmount();
    error Mismatch();

    // --- events
    event UserAdded(address indexed user, uint256 indexed amount);
    event Claimed(address indexed user, uint256 indexed amount);

    // --- constants ---
    uint256 private constant NULL = 0;

    // --- storage ---
    address public owner;

    // simple eligible mapping
    mapping(address => bool) eligible;
    mapping(address => uint256) claimAmount;

    // --- modifier
    modifier authorized() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEligibleUser(address user, uint256 amount) authorized {
        if (eligible[user]) revert AlreadyAdded();
        require(amount > 0, InvalidAmount());

        eligible[user] = true;
        claimAmount[user] += amount;

        emit UserAdded(user, amount);
    }

    function addEligibleUsers(address[] memory users, uint256[] memory amounts) external authorized {
        uint256 userLength = users.length();
        uint256 amountLength = amounts.length();
        if (userLength != amountLength) revert Mismatch();

        for (uint256 i; i < userLength; i++) {
            if (eligible[users[i]]) revert AlreadyAdded();
            require(amounts[i] > 0, InvalidAmount());

            eligible[users[i]] = true;
            claimAmount[users[i]] += amounts[i];

            emit UserAdded(users[i], amounts[i]);
        }
    }

    function claim() external {
        if (!eligible[msg.sender]) revert NotEligible();
        if (claimAmount[msg.sender] <= NULL) revert NotClaimAmount();

        uint256 amount = claimAmount[msg.sender];
        claimAmount[msg.sender] = 0;
        eligible[msg.sender] = false;

        _mint(msg.sender, amount);

        emit Claimed(msg.sender, amount);
    }
}
