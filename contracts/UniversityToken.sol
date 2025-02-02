// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UniversityToken is ERC20 {
    address public owner;

    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    // Use array to store transactions
    Transaction[] public transactions;
    
    // Event to log transfers
    event TransferLogged(address indexed sender, address indexed receiver, uint256 amount);

    // Constructor
    constructor(address initialOwner) ERC20("UniversityToken", "UTK") {
        owner = initialOwner;
        _mint(initialOwner, 2000 * 10 ** decimals());
    }

    // Override transfer function to log transactions
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        super.transfer(recipient, amount);

        // Log the transaction with the current timestamp
        transactions.push(Transaction({
            sender: msg.sender,
            receiver: recipient,
            amount: amount,
            timestamp: block.timestamp
        }));
        
        emit TransferLogged(msg.sender, recipient, amount);
        
        return true;
    }

    // Function to retrieve a transaction by index
    function getTransaction(uint256 index) public view returns (address sender, address receiver, uint256 amount, uint256 timestamp) {
        require(index < transactions.length, "Invalid transaction index.");
        Transaction memory txn = transactions[index];
        return (txn.sender, txn.receiver, txn.amount, txn.timestamp);
    }

    // Function to retrieve the latest transaction timestamp
    function getLatestTimestamp() public view returns (string memory) {
        require(transactions.length > 0, "No transactions yet.");
        uint256 latestTimestamp = transactions[transactions.length - 1].timestamp;
        return string(abi.encodePacked("Latest transaction timestamp: ", uint2str(latestTimestamp)));
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // Function to retrieve the sender address of a transaction by index
    function getSender(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index.");
        return transactions[index].sender;
    }

    // Function to retrieve the receiver address of a transaction by index
    function getReceiver(uint256 index) public view returns (address) {
        require(index < transactions.length, "Invalid transaction index.");
        return transactions[index].receiver;
    }
}
