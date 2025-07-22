// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract helper{
    enum bgrp {ap, an, bp, bn, op, on, abp, abn}
    enum ctry {india}
    enum state {tamilnadu}
    enum status{pending,shipped,received,fullfilled}
    enum requestStatus {requested, approved, rejected, accepted, declined}
    
    address[] public donorAddresses;

    function getBloodGroupEnum(string memory _bg) public pure returns (bgrp) {
        bytes32 encodedStatus = keccak256(abi.encodePacked(_bg));
        if (encodedStatus == keccak256("A+ve")) {
            return bgrp.ap;
        } else if (encodedStatus == keccak256("A-ve")) {
            return bgrp.an;
        } else if (encodedStatus == keccak256("B+ve")) {
            return bgrp.bp;
        } else if (encodedStatus == keccak256("B-ve")) {
            return bgrp.bn;
        } else if (encodedStatus == keccak256("O+ve")) {
            return bgrp.op;
        } else if (encodedStatus == keccak256("O-ve")) {
            return bgrp.on;
        } else if (encodedStatus == keccak256("AB+ve")) {
            return bgrp.abp;
        } else if (encodedStatus == keccak256("AB-ve")) {
            return bgrp.abn;
        } else {
            revert("Invalid bloodgroup");
        }
    }

    function getCountryEnum(string memory _ctry) public pure returns (ctry) {
        bytes32 encodedStatus = keccak256(abi.encodePacked(_ctry));
        if (encodedStatus == keccak256("India")) {
            return ctry.india;
        } else {
            revert("Invalid country");
        }
    }

    function getStateEnum(string memory _st) public pure returns (state) {
        bytes32 encodedStatus = keccak256(abi.encodePacked(_st));
        if (encodedStatus == keccak256("Tamil nadu")) {
            return state.tamilnadu;
        } else {
            revert("Invalid state");
        }
    }

    function getStatus(string memory _status) public pure returns (status) {
        bytes32 encodedStatus = keccak256(abi.encodePacked(_status));
        if (encodedStatus == keccak256("p")) {
            return status.pending;
        } else if(encodedStatus == keccak256("s")){
            return status.shipped;
        } else if(encodedStatus == keccak256("r")){
            return status.received;
        } else if(encodedStatus == keccak256("f")){
            return status.fullfilled;
        } else {
            revert("Invalid status");
        }
    }
    // Helper function to get donor address by ID
    function getDonorAddressById(uint256 id) public view returns (address) {
        require(id > 0 && id <= donorAddresses.length && donorAddresses.length > 0, "Invalid donor ID");
        return donorAddresses[id - 1]; // Subtract 1 because IDs are 1-based.
    }
}