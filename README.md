# 🩸 BloodLink – A Blockchain and IoT-based Blood Donation & Tracking System

**BloodLink** is an innovative solution that integrates **Blockchain technology**, **IoT sensors**, and **RFID tracking** to create a transparent, secure, and real-time blood donation and distribution ecosystem.

---

## 🚀 Overview

BloodLink addresses challenges in the traditional blood supply chain by introducing:

- ✅ **RFID-based real-time blood unit tracking**.
- ✅ **Blockchain-backed secure ledger for all blood unit activities**.
- ✅ **Dual-role mobile apps** for:
  - Donors & Patients
  - Hospitals, Blood Banks & Admins
- ✅ **Temperature monitoring** using DS18B20 sensors to ensure safe storage.
- ✅ **Smart Contract** integration for tamper-proof operations and decentralized control.

---

## 🛠️ Tech Stack

| Layer        | Technology                            |
|--------------|----------------------------------------|
| **Frontend** | Flutter (Donor/Patient & Admin apps)   |
| **Backend**  | Node.js + Firebase (IoT integration) |
| **Blockchain** | Ethereum (Private network using Ganache) |
| **Smart Contracts** | Solidity (Deployed via Truffle)     |
| **Hardware** | ESP32, RFID Readers, DS18B20 Temperature Sensor |
| **Integration** | Web3 Dart, Firebase Realtime DB/Firestore |

---

## 🔄 System Workflow

### 📦 Blood Bag Journey (Tracked via RFID)

1. **Donor registers** via the mobile app.
2. **Blood is collected** and tagged with an **RFID tag**.
3. RFID readers at **3 key checkpoints** log the movement:
   - 🏥 Shipped
   - 🚚 In Transit
   - 📍 Reached Destination
4. Each status update is:
   - ✅ **Read via RFID**
   - ✅ **Sent to ESP32**
   - ✅ **Logged in Firebase**
   - ✅ **Pushed to Ethereum Smart Contract (via Web3)**

---

### 🌡️ Temperature Monitoring

- DS18B20 sensors constantly monitor the temperature.
- Any deviation is recorded and notified to the **Admin** and **Blood Bank** via the app.

---

## 📱 Apps Overview

### 🔹 Donor & Patient App
- Register and login with **Wallet ID**.
- Donors: View blood requests, donation history.
- Patients: Request specific blood types, track request status.

### 🔸 Admin App (Hospitals, Blood Banks, Admin)
- Manage blood unit lifecycle.
- Approve donor/patient registrations.
- View sensor data & alerts.
- Monitor RFID-based location logs.

---

## 📑 Smart Contract Functions (Solidity)

- `registerDonor(address donorWallet, string memory name)`
- `requestBlood(address patientWallet, string memory bloodType)`
- `updateBloodUnitStatus(uint id, string memory status)`
- `logRFIDEvent(uint id, string memory location)`
- `recordTemperature(uint id, int temp)`

All transactions are **immutable**, **transparent**, and can be **audited anytime**.

---


