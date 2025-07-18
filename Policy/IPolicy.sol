// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPolicy {
    function isActive(address policyHolder) external view returns (bool);

    //function policyId() external view returns (uint256);

    //function walletAddress() external view returns (address);

    function getCoverage() external view returns (uint256);

}
