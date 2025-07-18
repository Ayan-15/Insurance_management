// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./../Insurer/InsurerManager.sol";
import "./../Policy/IPolicy.sol";
import "./../Policy/ClaimTypes.sol";

contract CustomerManager {
    event PremiumPaid(
        address indexed policyholder, // address of the policyholder
        uint256 indexed policyIndex, // policy index of the policyholder
        string policyId, // policy id of the policyholder
        uint256 amount, // amount paid as preminum
        uint256 timestamp // time of payment
    );
    event ClaimSubmitted(
        uint256 claimId,
        address claimant,
        string policyId,
        uint256 claimAmount
    );
    struct PolicyHolder {
        address walletAddress; // Customer's wallet address
        bytes32 ssnHash; // Hashed SSN for identity
        string homeAddress; // Customer's home address
        string policyId; // Unique policy ID
        uint256 premiumAmount; // Premium amount paid by the customer
        uint256 coverageAmount; // Coverage amount of the policy
        uint256 premiumPaid; // Total premium paid so far
        uint256 startDate; // Policy activation date
        uint256 duration; // Duration of the policy till active
        bool isActive;
    }

    mapping(address => PolicyHolder[]) public customerPolicies;
    mapping(string => address) public policyContracts;
    mapping(address => ClaimTypes.Claim[]) public claims;
    uint256 public nextClaimId = 1;

    //InsurerManager public insurerManager;

    // Not needed as of now. But if it is needed to connect the InsurerManager.sol with this 
    // code CustomerPolicy.sol then constructor will be needed. Payable is mentioned because 
    // one function in InsurerManager.sol has a payable function.   
    /** constructor(address payable insurerManagerAddress) {   // not needed as of now. 
    //    insurerManager = InsurerManager(insurerManagerAddress);
    //} */
    InsurerManager public insurerManager;

    function registerCustomerPolicy(
        address customer,
        string memory homeAddr,
        string memory ssn,
        string memory policyId,
        uint256 premiumAmount,
        uint256 coverageAmount,
        uint256 duration
    ) public {
        bytes32 ssnHash = keccak256(abi.encodePacked(ssn));
        PolicyHolder memory newHolder = PolicyHolder({
            walletAddress: customer,
            ssnHash: ssnHash,
            homeAddress: homeAddr,
            policyId: policyId,
            premiumAmount: premiumAmount,
            coverageAmount: coverageAmount,
            premiumPaid: 0,
            startDate: block.timestamp,
            duration: duration,
            isActive: true
        });
        customerPolicies[customer].push(newHolder);
    }

    function payPremium(uint256 index) public payable {
        require(
            index < customerPolicies[msg.sender].length,
            "Invalid policy index"
        );

        // retrieve the policyholder struct reference for "this" policy made by "this" policyholder.
        // storage keyword is necessary to keep consistency with struct so any changes to struct will be reflected.
        // So any changes made on "policyholder" struct on chain reference will be reflected i.e., update stored data.
        PolicyHolder storage policyholder = customerPolicies[msg.sender][index];

        require(policyholder.isActive, "Policy is not active");
        require(
            msg.value == policyholder.premiumAmount,
            "Incorrect premium amount"
        );

        policyholder.premiumPaid += msg.value;

        emit PremiumPaid(
            policyholder.walletAddress,
            index,
            policyholder.policyId,
            msg.value,
            block.timestamp
        );

        // Optional: deactivate policy after enough payments (simple example)
        //uint256 expected = policyholder.premiumAmount * policyholder.duration;
        //if (policyholder.premiumPaid >= expected) {
        //    policyholder.isActive = false;
        // }
    }

    // Submit a claim for a policy
    function submitClaim(
        string memory policyId,
        uint256 claimAmount,
        string calldata reason
    ) external {
        address policyAddress = policyContracts[policyId];
        require(policyAddress != address(0), "Policy not registered");
        require(policyAddress != address(0), "Invalid policy ID");

        IPolicy policy = IPolicy(policyAddress);

        // Validate ownership and policy status
        require(policy.isActive(msg.sender), "Policy not active or expired");

        // Check claim amount <= coverage limit
        require(
            claimAmount <= policy.getCoverage(),
            "Claim amount exceeds coverage"
        );

        claims[msg.sender].push(
            ClaimTypes.Claim({
                claimId: nextClaimId,
                policyId: policyId,
                claimant: msg.sender,
                claimAmount: claimAmount,
                reason: reason,
                approved: false,
                paid: false,
                timestamp: block.timestamp
            })
        );

        emit ClaimSubmitted(nextClaimId, msg.sender, policyId, claimAmount);
        nextClaimId++;
    }

    function getClaimStatus(address claimant, uint256 claimIndex)
        public
        view
        returns (string memory)
    {
        require(claimIndex < claims[claimant].length, "Invalid claim index");
        ClaimTypes.Claim storage claim = claims[claimant][claimIndex];

        if (claim.paid) {
            return "Paid";
        } else if (claim.approved) {
            return "Approved";
        } else {
            return "Pending";
        }
    }

    function getPolicies(address customer)
        public
        view
        returns (PolicyHolder[] memory)
    {
        return customerPolicies[customer];
    }
}
