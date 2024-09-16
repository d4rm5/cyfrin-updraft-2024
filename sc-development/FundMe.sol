// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "PriceConverter.sol";

error NotOwner();
error NotSent();
error NotEnoughETH();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant minimumUsd = 5e18;

    address[] funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return priceFeed.version();
    }

    function fund() public payable {
        // require(msg.value.getConversionRate() >= minimumUsd, "Not enough ETH");
        if (msg.value.getConversionRate() < minimumUsd) {
            revert NotEnoughETH();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) {
            revert NotSent();
        }
        // require(callSuccess, "Failed to withdraw Ether");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "This function is onlyOwner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}
