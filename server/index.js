const axios = require("axios");
require("dotenv").config();
const { Web3 } = require("web3");

// Use Ganache as Web3 provider
const web3 = new Web3("http://192.168.234.244:7545");

// Import the compiled contract ABI & address from Truffle
const contractJSON = require("E:/temp flutter/final_year_project/smartcontract/build/contracts/BloodLink.json");

// Extract the contract ABI and deployed address
const contractABI = contractJSON.abi;
const contractAddress = contractJSON.networks[5777].address; // 5777 is Ganache's default network ID

// Smart Contract instance
const contract = new web3.eth.Contract(contractABI, contractAddress);

// RFID Tag to Ethereum Address Mapping
const rfidToEthAddress = {
  "83454AFA": "0x79B2FB26A03765422473C31A43AbD68423536e75",
  "92BC57D4": "0xF4954Ec6dCb29B08733Ec18C6ff4AcFDDf0125D7",
  "F3A91B67": "0x16049d6F1ca3b96CaCe4cce37AABc3b175F64bb0"
};

// Use the first Ganache account as the sender
async function getAccount() {
  const accounts = await web3.eth.getAccounts();
  return accounts[0]; // Use the first account in Ganache
}

// Store last processed RFID data to prevent duplicate transactions
let lastProcessedData = { rfidTag: null, location: null };

// Function to fetch RFID data from Firebase and update location in smart contract
async function fetchRFIDData() {
  try {
    const response = await axios.get(process.env.FIREBASE_URL);
    const data = response.data;

    if (!data) {
      console.log("No data found in Firebase");
      return;
    }

    // Get the latest RFID entry
    const latestTag = Object.values(data)[Object.values(data).length - 1];
    console.log("New RFID Data:", latestTag);

    // Extract RFID UID
    const rfidUID = latestTag.rfidTag; // Ensure the field name matches the Firebase data structure

    // Check if RFID tag exists in the mapping
    if (!rfidToEthAddress[rfidUID]) {
      console.log(`No ETH address found for RFID: ${rfidUID}`);
      return;
    }

    // **Prevent duplicate transactions** by checking if the same data was processed last time
    if (lastProcessedData.rfidTag === rfidUID && lastProcessedData.location === location) {
      console.log("Duplicate data detected, skipping transaction.");
      return;
    }

    const ethAddress = rfidToEthAddress[rfidUID];
    const sender = await getAccount();

    // Update location on smart contract
    const tx = await contract.methods
      .setBloodLocation(ethAddress, latestTag.location)
      .send({
        from: sender,
        gas: 200000,
      });

    console.log(`Transaction Successful for ${ethAddress} at ${latestTag.location}:`, tx.transactionHash);
    // **Update last processed data**
    lastProcessedData = { rfidTag: rfidUID, location: latestTag.location };
  } catch (error) {
    console.error("Error:", error.message || error);
  }
}

// Run the fetch function every 5 seconds
setInterval(fetchRFIDData, 5000);
