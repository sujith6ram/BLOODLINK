// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import './helper.sol';

contract BloodLink is helper{

    uint8 public userCount=0;
    uint256 public donor_end;
    address public admin;
    
    struct User {
        uint8 id;
        string name;
        string gender;
        bgrp bloodgroup;
        ctry country;
        state State;
        uint256 contact;
        bool isavailable;
        bool isverified;
    }

    struct Hist{
        string place;
        string date;
        status Status;
    }

    struct BloodRequest {
        uint256 id;
        address patient;
        address donor;
        string patientName;
        string patientContact;
        bgrp requestedBloodGroup;
        requestStatus Status;
    }
    
    mapping(address=>Hist[]) public donations;
    mapping(address => User) public donors;
    mapping(uint256 => BloodRequest) public bloodRequests;
    uint256 public bloodRequestCount;
    address[] public suppliers;
    address[] public hospitals;
    
    event regD(address indexed _address, string _name, string _gender, bgrp _bloodgroup, uint256 _contact);
    event donateb(string _place,string date,status _status);
    event bloodRequested(address indexed patient, address indexed donor, bgrp bloodGroup);
    event RequestStatusChanged(uint256 indexed requestId, address indexed donor);

    modifier onlyAdmin(){
        require(admin==msg.sender,"Not admin!");
        _;
    }

//------------------------------------------DONOR--------------------------------------------------------------------
    //registerDonor => registers donor info
    function registerDonor(address _address, string memory _name, string memory _gender,string memory _bloodgroup,
     uint256 _contact, string memory _country, string memory _state) public {

        bgrp bloodgroupEnum = getBloodGroupEnum(_bloodgroup);
        ctry countryEnum = getCountryEnum(_country);
        state stateEnum = getStateEnum(_state);
        require(_address != address(0), "Invalid address");
        require(donors[_address].id == 0, "Address is already registered");

        donors[_address] = User({
            id: ++userCount,
            name: _name,
            gender: _gender,
            bloodgroup: bloodgroupEnum,
            contact: _contact,
            country: countryEnum,
            State: stateEnum,
            isavailable: false,
            isverified: false
        });
        // donorIdToAddress[newId] = _address;
        donorAddresses.push(_address);
        emit regD(_address, _name, _gender, bloodgroupEnum, _contact);
    }

    //donateHistory => display history of donors donations with status
    function donateHistory(address _address) public view returns(Hist[] memory){
        require(_address != address(0), "Invalid address");
        require(donors[_address].id != 0, "Donor not registered");
        return donations[_address];
    }

    //getApprovedRequests => display the admin approved request of patient
    function getApprovedRequests(address _donor) public view returns (BloodRequest[] memory) {
        require(_donor != address(0), "Invalid donor address");
        require(donors[_donor].id != 0, "Donor not registered");

        uint256 count = 0;

        // Count approved requests for the donor
        for (uint256 i = 0; i < bloodRequestCount; i++) {
            if (bloodRequests[i].donor == _donor && bloodRequests[i].Status == requestStatus.approved) {
                count++;
            }
        }

        BloodRequest[] memory approvedRequests = new BloodRequest[](count);
        uint256 index = 0;

        // Collect approved requests for the donor
        for (uint256 i = 0; i < bloodRequestCount; i++) {
            if (bloodRequests[i].donor == _donor && bloodRequests[i].Status == requestStatus.approved) {
                approvedRequests[index] = bloodRequests[i];
                index++;
            }
        }

        return approvedRequests;
    }

    //respondToRequest => donor has to accept or decline the request
    function respondToRequest(uint256 requestId, bool accept) public {
        require(requestId < bloodRequestCount, "Invalid request ID");
        BloodRequest storage request = bloodRequests[requestId];

        require(request.donor == msg.sender, "Only for assigned donor");

        if (accept) {
            request.Status = requestStatus.accepted;
            emit RequestStatusChanged(requestId, msg.sender);
        } else {
            request.Status = requestStatus.declined;
            emit RequestStatusChanged(requestId, msg.sender);
        }
    }

//------------------------------------------PATIENT------------------------------------------------------------------
    //getEligibleDonors => displays a list of eligible donors acc to the place and bg
    function getEligibleDonors(string memory _bloodgroup, string memory _country, string memory _state, 
    bool _isavailable, bool _isverified) public view returns (User[] memory) {
        bgrp bloodgroupEnum = getBloodGroupEnum(_bloodgroup);
        ctry countryEnum = getCountryEnum(_country);
        state stateEnum = getStateEnum(_state);

        uint256 count = 0;

        // Count eligible donors
        for (uint256 i = 0; i < userCount; i++) {
            address donorAddress = getDonorAddressById(i + 1);
            User memory donor = donors[donorAddress];

            if (
                donor.bloodgroup == bloodgroupEnum &&
                donor.country == countryEnum &&
                donor.State == stateEnum &&
                donor.isavailable == _isavailable &&
                donor.isverified == _isverified
            ) {
                count++;
            }
        }

        User[] memory eligibleDonors = new User[](count);
        uint256 index = 0;

        // Collect eligible donors
        for (uint256 i = 0; i < userCount; i++) {
            address donorAddress = getDonorAddressById(i + 1);
            User memory donor = donors[donorAddress];

            if (
                donor.bloodgroup == bloodgroupEnum &&
                donor.country == countryEnum &&
                donor.State == stateEnum &&
                donor.isavailable == _isavailable &&
                donor.isverified == _isverified
            ) {
                eligibleDonors[index] = donor;
                index++;
            }
        }

        return eligibleDonors;
    }

    //requestBlood => patient req blood
    function requestBlood(address _donor, string memory _patientName, string memory _patientContact, string memory _bloodGroup) public {
        require(_donor != address(0), "Invalid donor address");
        require(donors[_donor].id != 0, "Donor not registered");
        bgrp requestedBloodGroup = getBloodGroupEnum(_bloodGroup);

        bloodRequests[bloodRequestCount] = BloodRequest({
            id: bloodRequestCount,
            patient: msg.sender,
            donor: _donor,
            patientName: _patientName,
            patientContact: _patientContact,
            requestedBloodGroup: requestedBloodGroup,
            Status: requestStatus.requested
        });

        emit bloodRequested(msg.sender, _donor, requestedBloodGroup);
        bloodRequestCount++;
    }

    //getRequestStatus => gives the status of the requested blood
    function getRequestStatus(address _patient) public view returns (BloodRequest[] memory) {
        require(_patient != address(0), "Invalid patient address");

        uint256 count = 0;

        // Count requests made by the patient
        for (uint256 i = 0; i < bloodRequestCount; i++) {
            if (bloodRequests[i].patient == _patient) {
                count++;
            }
        }

        BloodRequest[] memory patientRequests = new BloodRequest[](count);
        uint256 index = 0;

        // Collect requests made by the patient
        for (uint256 i = 0; i < bloodRequestCount; i++) {
            if (bloodRequests[i].patient == _patient) {
                patientRequests[index] = bloodRequests[i];
                index++;
            }
        }

        return patientRequests;
    }

//------------------------------------------ADMIN--------------------------------------------------------------------

    //donateBlood => registers that donor donated the blood
    function donateBlood(address _address,string memory _place,string memory _date, string memory _status) public {
        require(_address != address(0), "Invalid address");
        require(donors[_address].id!=0,"Invalid donor");
        // uint256 donationCount = donations[_address].length;
        status _Status=getStatus(_status);
        donations[_address].push(Hist({
            place: _place,
            date: _date,
            Status: _Status
        }));
        emit donateb(_place,_date,_Status);
    }

    //approveRequest => approve patient req
    function approveRequest(uint256 requestId, bool approve) public {
        require(requestId < bloodRequestCount, "Invalid request ID");

        BloodRequest storage request = bloodRequests[requestId];

        if (approve) {
            request.Status = requestStatus.approved;
            emit RequestStatusChanged(requestId, request.donor);
        } else {
            request.Status = requestStatus.rejected;
            emit RequestStatusChanged(requestId, request.donor);
        }
    }

    //viewDonors => admin can view the donors with few details
    function viewDonors() public view returns (User[] memory) {
        User[] memory donorList = new User[](donorAddresses.length);

        for (uint256 i = 0; i < donorAddresses.length; i++) {
            address donorAddress = donorAddresses[i];
            donorList[i] = donors[donorAddress];
        }

        return donorList;
    }

    //viewPatients => admin can view patients 
    function viewPatients() public view returns (BloodRequest[] memory) {
        BloodRequest[] memory allRequests = new BloodRequest[](bloodRequestCount);
        uint256 index = 0;

        for (uint256 i = 0; i < bloodRequestCount; i++) {
            allRequests[index] = bloodRequests[i];
            index++;
        }

        return allRequests;
    }

    // adds both bloodbank and hospital where true for bloodbank and false for hospitals
    function addBorH(address _address,bool _whichone) public {
        // true for suppliers and false for hospitals
        _whichone?suppliers.push(_address):hospitals.push(_address);
    }

    //trackBlood => track the bloodunit movement of the donor
    function trackBlood(address donor) public view returns (status) {
        // Ensure the donor has at least one donation history
        require(donations[donor].length > 0, "No donation history for this donor");

        // Return the Status of the most recent donation
        return donations[donor][donations[donor].length - 1].Status;
    }

    //setBloodLocation => the rfid set the tracking value
    function setBloodLocation(address donor, string memory _status) external {
        require(donations[donor].length > 0, "No donation history for this donor");

        // Get the latest donation entry and update its status
        donations[donor][donations[donor].length - 1].Status = getStatus(_status);
    
        // emit donateb(donations[donor][donations[donor].length - 1].place, donations[donor][donations[donor].length - 1].date, donations[donor][donations[donor].length - 1].Status);
    }

    //setStatus => will set availability(0),verify(1) and fulfill(2) 
    //|-setAvailability => set the available status for the donor which denotes the donor donated blood 
    //|-setVerify => set verfied for the pure blood to be donated
    //|-setFulfill => the end point of the donation where hospital has to mark it as received
    function setStatus(address userAddress,uint8 _no) public {
        if(_no==0||_no==1){
             // Check if the user exists in the mapping
            require(donors[userAddress].id != 0, "User does not exist");
            // Update the isavailable field to true
            // Update the isverified field to true
            _no == 0 ? donors[userAddress].isavailable = true : donors[userAddress].isverified = true;
        }
        else if(_no==2){
            // Ensure the donor has at least one donation history
            require(donations[userAddress].length > 0, "No donation history for this donor");

            // Update the Status of the most recent donation to 'received'
            donations[userAddress][donations[userAddress].length - 1].Status = status.fullfilled;
        }
    }
}
