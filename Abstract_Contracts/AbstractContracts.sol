// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

enum InsuranceDomain {
    Health,
    Vehicle,
    Life,
    Sports,
    Valuables,
    Properties,
    Travel,
    Intellectual_property
}

abstract contract Insurer {
    string public insurer_name; // name of the insurer to be implemented by the client.
    InsuranceDomain public insurance_domain;

    // Proper constructor
    constructor(string memory name, InsuranceDomain _domain) {
        insurer_name = name;
        insurance_domain = _domain;
    }

    address[] public issued_policies; // ← 1:Many relationship of Insurer with Policy.

    // Function to register a policy address.
    function registerPolicy(address policy) public {
        issued_policies.push(policy);
    }

    // returns the address of the issued_policy data str.
    function getAllPolicies() public view returns (address[] memory) {
        return issued_policies;
    }

    // returns the list of policies the insurer has issued.
    function getPolicyCount() public view returns (uint256) {
        return issued_policies.length;
    }

    // Helper function to convert InsuranceDomain to string
    function insuranceDomainToString(InsuranceDomain domain)
        internal
        pure
        returns (string memory)
    {
        if (domain == InsuranceDomain.Health) return "Health";
        if (domain == InsuranceDomain.Vehicle) return "Vehicle";
        if (domain == InsuranceDomain.Life) return "Life";
        if (domain == InsuranceDomain.Sports) return "Sports";
        if (domain == InsuranceDomain.Valuables) return "Valuables";
        if (domain == InsuranceDomain.Properties) return "Properties";
        if (domain == InsuranceDomain.Travel) return "Travel";
        if (domain == InsuranceDomain.Intellectual_property)
            return "Intellectual_property";
        return "Unknown";
    }

    // Abstract function that child must implement
    function get_insurer_info()
        public
        view
        virtual
        returns (string memory, string memory);
}

abstract contract Policy {
    string public policy_name; // name of the policy to be given by the client.
    string public policy_id; // unique id of the policy to be given by the client.
    uint256 public policy_amount; // amount of the policy to be given by the client.
    uint256 public policy_duration; // duration of the policy to be given by the client.
    uint256 public policy_premium; // premium of the policy to be given by the client.
    uint256 public policy_maturity; // maturity of the policy to be given by the client.

    Insurer public insurer; // Abstract connection between Policy and Insurer (1:1).

    constructor(
        string memory _policy_name,
        string memory _policy_id,
        uint256 _amount,   // in ETH 
        uint256 _duration, // in years
        uint256 _premium,  // yearly
        uint256 _maturity, // in years
        Insurer _insurer
    ) {
        policy_name = _policy_name;
        policy_id = _policy_id;
        policy_amount = _amount;
        policy_duration = _duration;
        policy_premium = _premium;
        policy_maturity = _maturity;
        insurer = _insurer;
    }

    // Abstract functions for child policy contracts to implement
    function get_policy_details()
        public
        view
        virtual
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
