// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local Anvil chain
// 2. Keep track of contract addresses on differet chains
// Sepolia ETH/USD 

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";


contract HelperConfig is Script {
    // If we are on local anvil, we deploy mock. If not, we use address.


    NetworkConfig public activeNetworkConfig;

    uint8 public constant ETH_DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        }
          else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) { 
        NetworkConfig memory sepoliaConfig = NetworkConfig(
            {
                priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
            }
        );

        return sepoliaConfig;
    } 
    
    function getMainnetConfig() public pure returns (NetworkConfig memory) { 
        NetworkConfig memory mainnetConfig = NetworkConfig(
            {
                priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            }
        );

        return mainnetConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(ETH_DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig(
            {
                priceFeed: address(mockPriceFeed)
            }
        );
        return anvilConfig;
    }
}