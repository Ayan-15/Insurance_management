// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import abstract contracts
import "../../Abstract_Contracts/AbstractContracts.sol";
import "../../Policy/IPolicyDetails.sol";
import "../../Policy/IPolicy.sol";

contract DriveSafePolicy_DS_PRE_001 is Policy, IPolicyDetails, IPolicy {
    constructor(address insurerAddr)
        Policy(
            "Premium_All_Benefit_Plan",
            "DS_PRE_001",
            10, // Policy amount in ETH
            3, // Policy duration in years
            4, // POlicy preminum in ETH
            0, // Policy maturity - will be 0 at the beginning
            Insurer(insurerAddr)
        )
    {
        Insurer(insurerAddr).registerPolicy(address(this));
    }

    mapping(address => bool) private activePolicyHolders;

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

    function getCoverage()
        external
        pure
        override(IPolicyDetails)
        returns (uint256)
    {
        return (2);
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**function isActive(address policyHolder) external view returns (bool) {
        require(isContract(policyHolder), "Invalid contract address");
        return true;
    }*/

    function activatePolicyHolder(address policyHolder) external {
        activePolicyHolders[policyHolder] = true;
    }

    function isActive(address policyHolder)
        external
        view
        override(IPolicy)
        returns (bool)
    {
        return activePolicyHolders[policyHolder];
    }
}
