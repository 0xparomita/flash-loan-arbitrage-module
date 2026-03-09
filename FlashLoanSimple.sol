// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/**
 * @title FlashLoanSimple
 * @dev Professional implementation of an Aave V3 Flash Loan receiver.
 */
contract FlashLoanSimple is FlashLoanSimpleReceiverBase {
    address payable public owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    /**
     * @dev This function is called after your contract has received the flash loaned amount.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE / LIQUIDATION LOGIC GOES HERE
        // Example: Trade on Dex A, Sell on Dex B
        
        // 2. APPROVE AAVE TO TAKE BACK THE LOAN + FEE
        uint256 amountToReturn = amount + premiums;
        IERC20(asset).approve(address(POOL), amountToReturn);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function getBalance(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function withdraw(address _token) external {
        require(msg.sender == owner, "Only owner");
        IERC20 token = IERC20(_token);
        token.transfer(owner, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
