// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import abstract contracts
import "../../Abstract_Contracts/AbstractContracts.sol";
import "../../Policy/IPolicyDetails.sol";

contract DriveSafePolicy_DS_PRE_001 is Policy, IPolicyDetails {
    constructor(address insurerAddr)
        Policy(
            "Premium_All_Benefit_Plan",
            "DS_PRE_001",
            1000000,
            3,
            12000,
            0,
            Insurer(insurerAddr)
        )
    {
        Insurer(insurerAddr).registerPolicy(address(this));
    }

    function get_policy_details()
        public
        view
        override(IPolicyDetails, Policy)
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        return (
            policy_name,
            policy_id,
            policy_amount,
            policy_duration,
            policy_premium,
            policy_maturity,
            address(insurer)
        );
    }
}
