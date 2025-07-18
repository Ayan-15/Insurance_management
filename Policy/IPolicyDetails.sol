// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPolicyDetails {
    function get_policy_details()
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        );
}