// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import abstract contracts
import "../../Abstract_Contracts/AbstractContracts.sol";
import "../../Policy/IPolicyInsurer.sol";

contract DriveSafe is Insurer, IPolicyInsurer {
    constructor() Insurer("DriveSafe", InsuranceDomain.Vehicle) {}

    function get_insurer_info()
        public
        view
        override(Insurer, IPolicyInsurer)
        returns (string memory, string memory)
    {
        return (insurer_name, insuranceDomainToString(insurance_domain));
    }
}

