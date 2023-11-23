// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BulkSendETH is Ownable {
    uint256 public ethAmount = 0.005 ether;

    constructor() Ownable(msg.sender) {}

    // This function allows the owner to set the amount of ETH to be sent in each transaction.
    function setEthAmount(uint256 _ethAmount) external onlyOwner {
        ethAmount = _ethAmount;
    }

    // Send ETH to multiple addresses
    function sendOutFunds(address[] memory _to) public payable onlyOwner {
        require(_to.length > 0, "No addresses provided");
        require(
            msg.value >= ethAmount * _to.length,
            "Insufficient balance to send out funds"
        );

        for (uint256 i = 0; i < _to.length; i++) {
            payable(_to[i]).transfer(ethAmount);
        }

        // Refund leftover Ether to the owner
        uint256 balance = address(this).balance;
        if (balance > 0) {
            payable(msg.sender).transfer(balance);
        }
    }

    // Allow the contract to receive Ether
    receive() external payable {}

    // Withdraw function for the contract owner to withdraw any Ether in the contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No Ether left to withdraw");
        payable(msg.sender).transfer(balance);
    }
}