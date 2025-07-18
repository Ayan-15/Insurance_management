// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPolicyInsurer {
    function get_insurer_info()
        external
        view
        returns (string memory, string memory);
}