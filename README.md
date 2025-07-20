# Insurance_management
This project involves the development of a smart contract-based insurance system on the Ethereum blockchain. This decentralized application will automate the management of insurance policies, including policy issuance, premium payments, claim submissions, and payouts. Leveraging blockchain technology, the system will enhance transparency, reduce administrative overhead, and ensure that all transactions are secure and immutable. Smart contracts will automate key processes, reducing the risk of human error and fraud, and ensuring that claims are processed swiftly and accurately
# How it works 
1. The company level implementation is made by implementing the abstract contracts (**`Insurer`** and **`Policy`**) and it is kept hidden from
Customer Level.
2. The Customer Manager and Insurer Manager can access the insurance company's product offerings using interfaces (not directly).
3. An example :
- DriveSafe is the company (a hypothetical example) which is the Insurer works on Vehicle domain (look at the enum list - `Abstract_Contracts\AbstractContracts.sol`)
- It offers a plan called **"Premium_All_Benefit_Plan"**.
- The policy ID is **"DS_PRE_001"**
- The policy amount is **10 ETH**.
- Policy duration is **3 years**.
- Policy premium is **4 ETH**.
- Policy coverage is **2 ETH**.
4.The above example is implemented and tested at a basic level.
5. Likewise other company can implement similar plans on the chain also DRIVESAFE can also implement other plans as well.

# InsurerManager Contract
Now, The **`InsurerManager`** contract is made ownable because claim management is only possible higher authority where the claim is
first checked before they are approved and the pay out to customer actually happens.

# CustomerManager Contract
The **`CustomerManager`** contract is mainly for customer who wil purchase the policy using the specific contract of the Insurance
company and particular policy product.

# Folder Structure

Check the UML diagram in Documentation folder (**`Complete_UML_diagram_Insurance_SL_solidity.pdf`** and **`Insurance_SL_Solidity_Writeup.pdf`**) 

```
└── 📁Insurance_SL
    └── 📁Abstract_Contracts
        ├── AbstractContracts.sol
    └── 📁Customer
        ├── CustomerPolicy.sol
    └── 📁Documentation
        ├── Complete_UML_diagram_Insurance_SL_solidity.pdf
        ├── Insurance_SL_Solidity_Writeup.pdf
    └── 📁Implementations
        └── 📁DriveSafe
            ├── DriveSafe.sol
            ├── DriveSafePolicy.sol
    └── 📁Insurer
        ├── InsurerManager.sol
    └── 📁Policy
        ├── ClaimTypes.sol
        ├── IPolicy.sol
        ├── IPolicyDetails.sol
        ├── IPolicyInsurer.sol
```
