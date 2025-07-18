// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
//import "./../Policy/IPolicy.sol";
import "./../Policy/IPolicyInsurer.sol";
import "./../Policy/ClaimTypes.sol";

contract InsurerManager is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {
        // Optional: additional initialization
    }

    uint256 public nextClaimId = 1;

    // Map policy ID to deployed policy contract address
    mapping(string => address) public policyContracts;

    // Reverse lookup mapping: contract address => policyId
    // mapping(address => string) public contractToPolicyId;

    // Map claimant address to their claims array
    mapping(address => ClaimTypes.Claim[]) public claims;

    // Events
    event PolicyRegistered(
        string indexed policyId,
        address indexed policyContract,
        string insurerName,
        string domain
    );
    event ClaimSubmitted(
        uint256 indexed claimId,
        address indexed claimant,
        string policyId,
        uint256 amount
    );
    event ClaimApproved(uint256 indexed claimId);
    event ClaimPaid(
        uint256 indexed claimId,
        address indexed claimant,
        uint256 amount
    );

    // Register new policy contract (only owner)
    function issuePolicy(string memory policyId, address policyAddress)
        external
        onlyOwner
    {
        require(policyAddress != address(0), "Invalid policy contract address");
        require(
            policyContracts[policyId] == address(0),
            "Policy ID already registered"
        );

        // not needed as of now
        /**require(
            contractToPolicyId[policyAddress] == 0,
            "Policy contract already registered"
        );
        contractToPolicyId[policyAddress] = policyId;*/

        policyContracts[policyId] = policyAddress;

        IPolicyInsurer policy = IPolicyInsurer(policyAddress);
        (string memory insurerName, string memory domain) = policy.get_insurer_info();
        emit PolicyRegistered(policyId, policyAddress, insurerName, domain);
    }

    // Approve a claim (only owner)
    function approveClaim(address claimant, uint256 claimIndex)
        external
        onlyOwner
    {
        require(claimIndex < claims[claimant].length, "Invalid claim index");
        ClaimTypes.Claim storage c = claims[claimant][claimIndex];
        require(!c.approved, "Claim already approved");
        require(!c.paid, "Claim already paid");
        c.approved = true;
        emit ClaimApproved(c.claimId);
    }

    // Pay an approved claim (only owner)
    function payClaim(address claimant, uint256 claimIndex) external onlyOwner {
        require(claimIndex < claims[claimant].length, "Invalid claim index");
        ClaimTypes.Claim storage c = claims[claimant][claimIndex];
        require(c.approved, "Claim not approved");
        require(!c.paid, "Claim already paid");
        require(address(this).balance >= c.claimAmount, "Insufficient funds");

        c.paid = true;
        payable(c.claimant).transfer(c.claimAmount);
        emit ClaimPaid(c.claimId, c.claimant, c.claimAmount);
    }

    // View claims of a claimant
    function getClaims(address claimant)
        external
        view
        returns (ClaimTypes.Claim[] memory)
    {
        return claims[claimant];
    }

    // Allow contract to receive Ether for payouts
    receive() external payable {}
}
