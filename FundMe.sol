// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./PriceConvertor.sol";

error NotOwner();

contract FundMe{

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 0.01 * 10 ** 18;
    // 1 ETH = 1e18 wei

    using PriceConvertor for uint256;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.convertETHtoUSD() >= MINIMUM_USD,"Not Enough funds!!");
    }

    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function withdraw() public {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}