// SPDX-License-Identifier: MIT
// Creating a library PriceConvertor that can be used by uint256 as functions

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getPrice() internal view returns (uint256) {
        // ABI
        // Address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // ETH in terms of USD in Goerli testnet
        // 3000.00000000 -> After 8 zeros decimal will be places -> To get decima(l number, use priceFeed.decimals()
        return uint256(price) * 1e10; // Adding 10 more since we need 1e18 value (1Eth = 1e18 wei)
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }

    function getDecimals() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.decimals();
    }

    function convertETHtoUSD(uint256 sentETH) internal view returns (uint256) {
        uint256 ethPriceInUSD = getPrice();

        uint256 ethSentInUSD = (sentETH * ethPriceInUSD) / 1e18;
        return ethSentInUSD;
    }
}
