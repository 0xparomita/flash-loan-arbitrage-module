// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./FlashLoanSimple.sol";

contract FlashLoanTest is Test {
    FlashLoanSimple public flashLoan;
    // Mainnet Aave Pool Addresses Provider
    address constant ADDR_PROVIDER = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eb48;

    function setUp() public {
        // Forking mainnet is required for this test
        flashLoan = new FlashLoanSimple(ADDR_PROVIDER);
    }

    function testFlashLoanRequest() public {
        // In a real test, you would use vm.prank and deal to simulate profits
        // This confirms the interface setup is correct
        assertEq(address(flashLoan.POOL_ADDRESSES_PROVIDER()), ADDR_PROVIDER);
    }
}
