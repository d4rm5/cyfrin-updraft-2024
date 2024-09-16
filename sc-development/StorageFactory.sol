// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./SimpleStorage.sol";

contract StorageFactory {
    // type visibility name
    SimpleStorage[] public listOfSimpleStorageContracts;

    // address[] public listOfSimpleStorageAddresses;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _newSimpleStorageNumber
    ) public {
        // Address
        // ABI (or function selector)
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        // mySimpleStorage.store(_newSimpleStorageNumber);
        // SimpleStorage mySimpleStorage = SimpleStorage(listOfSimpleStorageAddresses[_simpleStorageIndex]);

        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _newSimpleStorageNumber
        );
    }

    function sfGet(
        uint256 _simpleStorageIndex
    ) public view returns (uint256 favoriteNumber) {
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        // return mySimpleStorage.retrieve();

        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}
