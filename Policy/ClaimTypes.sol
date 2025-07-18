// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library ClaimTypes {
    struct Claim {
        uint256 claimId;
        string policyId;
        address claimant;
        uint256 claimAmount;
        string reason;
        bool approved;
        bool paid;
        uint256 timestamp;
    }
}