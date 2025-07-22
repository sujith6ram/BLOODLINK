import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart';

class BloodLinkService extends ChangeNotifier {
  final String rpcUrl = "http://192.168.210.244:7545";
  final String wsUrl = "ws://192.168.210.244:7545/";
  final String adminPrivateKey =
      "0x0f1e710a76cd900831e3703cb6a84e746f272899d1ee6e1768ae7a1061b64043"; // Admin's private key
  final String adminAddress =
      "0xFf165599E30f8543c01fBBE4a5e9094D660cf514"; // Admin's address

  Web3Client? client;
  Credentials? credentials;
  EthereumAddress? contractAddress;
  ContractAbi? contractAbi;
  DeployedContract? contract;

  // Contract functions
  ContractFunction? registerDonor;
  ContractFunction? donateHistory;
  ContractFunction? getApprovedRequests;
  ContractFunction? respondToRequest;
  ContractFunction? getEligibleDonors;
  ContractFunction? requestBlood;
  ContractFunction? getRequestStatus;

  bool isLoading = true;

  BloodLinkService() {
    init();
  }

  init() async {
    try {
      debugPrint("initializing");
      client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(wsUrl).cast<String>();
        },
      );
      await getCredentials();
      await getABI();
      await getDeployedContract();
      if (contract == null) {
        print("Error: Contract initialization failed.");
        return;
      }

      print("Contract initialized successfully!");
      print("Finished initialization");
    } catch (e) {
      print("Error connecting to Ethereum: $e");
    }
  }

  Future<void> getCredentials() async {
    credentials = EthPrivateKey.fromHex(adminPrivateKey);
  }

  Future<void> getABI() async {
    String abiFile = await rootBundle.loadString(
        'E:/temp flutter/final_year_project/smartcontract/build/contracts/BloodLink.json');
    final jsonABI = jsonDecode(abiFile);
    if (jsonABI["networks"] == null ||
        jsonABI["networks"]["5777"] == null ||
        jsonABI["networks"]["5777"]["address"] == null) {
      print("Error: Contract address not found in ABI file");
      return;
    }
    contractAbi = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'BloodLink');
    contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    print("Contract Address: ${contractAddress!.hex}");
  }

  Future<void> getDeployedContract() async {
    if (contractAbi == null || contractAddress == null) {
      print("Error: ABI or contract address is null");
      return;
    }
    contract = DeployedContract(contractAbi!, contractAddress!);
    print("Contract successfully deployed at ${contractAddress!.hex}");

    // Mapping contract functions
    registerDonor = contract!.function("registerDonor");
    donateHistory = contract!.function("donateHistory");
    getApprovedRequests = contract!.function("getApprovedRequests");
    respondToRequest = contract!.function("respondToRequest");
    getEligibleDonors = contract!.function("getEligibleDonors");
    requestBlood = contract!.function("requestBlood");
    getRequestStatus = contract!.function("getRequestStatus");
    isLoading = false;
    notifyListeners();
  }

  String mapBloodGroup(int value) {
    List<String> bloodGroups = [
      "A+",
      "A-",
      "B+",
      "B-",
      "O+",
      "O-",
      "AB+",
      "AB-"
    ];
    return (value >= 0 && value < bloodGroups.length)
        ? bloodGroups[value]
        : "Unknown";
  }

  String mapStatus(int value) {
    List<String> statuses = ["Pending", "Shipped", "Received", "Fullfilled"];
    return (value >= 0 && value < statuses.length)
        ? statuses[value]
        : "Unknown";
  }

  String mapRequestStatus(int value) {
    List<String> statuses = [
      "Requested",
      "Approved",
      "Rejected",
      "Accepted",
      "Declined"
    ];
    return (value >= 0 && value < statuses.length)
        ? statuses[value]
        : "Unknown";
  }

  // Function to convert bytes32 to string in Dart
  String bytes32ToString(dynamic bytes32) {
    List<int> bytesList = List<int>.from(bytes32);

    // Find first null character to trim padding
    int nullIndex = bytesList.indexOf(0);
    if (nullIndex != -1) {
      bytesList = bytesList.sublist(0, nullIndex);
    }

    // Convert ASCII values to string
    return ascii.decode(bytesList, allowInvalid: true);
  }

  Future<String> registerDonorFunction(
      String donorPrivateKey,
      String name,
      String gender,
      String bloodGroup,
      String contact,
      String country,
      String state,
      BuildContext context) async {
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      final Credentials donorCredentials =
          EthPrivateKey.fromHex(donorPrivateKey);
      final EthereumAddress donorAddress = donorCredentials.address;
      final BigInt contactBigInt = BigInt.parse(contact);
      notifyListeners();

      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => Center(child: CircularProgressIndicator()),
      // );

      final transaction = Transaction.callContract(
        contract: contract!,
        function: registerDonor!,
        parameters: [
          donorAddress,
          name,
          gender,
          bloodGroup,
          contactBigInt,
          country,
          state
        ],
        from: donorAddress, // Transaction is sent from the donor's wallet
      );

      final txHash = await client!
          .sendTransaction(donorCredentials, transaction, chainId: 1337);

      // Navigator.pop(context); // Close loading dialog
      return txHash;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error123: $e")),
      );
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> donateHistoryFunction(
      String _donorAddress, BuildContext context) async {
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      // Convert donor's private key to credentials
      final EthereumAddress donorAddress =
          EthereumAddress.fromHex(_donorAddress);

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Calling donateHistory function from the contract
      final result = await client!.call(
        contract: contract!,
        function: donateHistory!,
        params: [donorAddress],
      );

      Navigator.pop(context); // Close loading dialog

      // Convert the result into a readable format (a list of donation history)
      final List<Map<String, dynamic>> donationHistory = [];
      for (var hist in result[0]) {
        donationHistory.add({
          "place": hist[0].toString(),
          "date": hist[1].toString(),
          "status": mapStatus(int.parse(hist[2]
              .toString())), // status will be an enum, so we may need to parse it
        });
      }

      return donationHistory;
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getApprovedRequestsFunction(
      String _donorAddress, BuildContext context) async {
    try {
      // Convert donor's address to EthereumAddress
      final EthereumAddress donorAddress =
          EthereumAddress.fromHex(_donorAddress);

      // Calling getApprovedRequests function from the contract
      final result = await client!.call(
        contract: contract!,
        function: getApprovedRequests!,
        params: [donorAddress],
      );

      // Convert the result into a readable format (a list of approved blood requests)
      final List<Map<String, dynamic>> approvedRequests = [];
      for (var bloodRequest in result[0]) {
        approvedRequests.add({
          "id": bloodRequest[0].toString(), // Blood request ID
          "patientName": bloodRequest[3], // Patient's name
          "requestedBloodGroup": mapBloodGroup(
              int.parse(bloodRequest[5].toString())), // Blood group (enum)
        });
      }

      return approvedRequests;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return [];
    }
  }

  Future<String> respondToRequestFunction(
      int requestId, String donorPrivateKey, BuildContext context) async {
    try {
      // Convert donor's private key to credentials
      final Credentials donorCredentials =
          EthPrivateKey.fromHex(donorPrivateKey);
      final EthereumAddress donorAddress = donorCredentials.address;
      const bool accept = true;

      // Calling respondToRequest function from the contract
      final transaction = Transaction.callContract(
        contract: contract!,
        function: respondToRequest!,
        parameters: [BigInt.from(requestId), accept],
        from: donorAddress,
      );

      final txHash = await client!
          .sendTransaction(donorCredentials, transaction, chainId: 1337);

      return txHash;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> getEligibleDonorsFunction(
      String bloodGroup,
      String country,
      String state,
      bool isAvailable,
      bool isVerified,
      BuildContext context) async {
    try {
      // Ensure contract is initialized
      if (client == null || contract == null || getEligibleDonors == null) {
        throw Exception("Blockchain service not initialized.");
      }
      // Calling getEligibleDonors function from the contract
      print("BloodGroup: $bloodGroup");
      print("Country: $country");
      print("State: $state");
      final result = await client!.call(
        contract: contract!,
        function: getEligibleDonors!,
        params: [bloodGroup, country, state, isAvailable, isVerified],
      );

      // Convert the result into a readable format (list of eligible donors)
      final List<Map<String, dynamic>> eligibleDonors = [];
      for (var donor in result[0]) {
        eligibleDonors.add({
          "name": donor[1],
          "gender": donor[2],
          "bloodgroup": mapBloodGroup(int.parse(donor[3].toString())),
          "contact": donor[6].toString(),
        });
      }

      return eligibleDonors;
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return [];
    }
  }

  Future<String> requestBloodFunction(
      String _donorAddress,
      String _patientPrivateKey,
      String patientName,
      String patientContact,
      String bloodGroup,
      BuildContext context) async {
    try {
      // Convert donor's address to EthereumAddress
      final EthereumAddress donorAddress =
          EthereumAddress.fromHex(_donorAddress);
      final Credentials patientCredentials =
          EthPrivateKey.fromHex(_patientPrivateKey);
      final EthereumAddress patientAddress = patientCredentials.address;
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (client == null || contract == null || requestBlood == null) {
        throw Exception("Blockchain service not initialized.");
      }

      // Show loading dialog
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => Center(child: CircularProgressIndicator()),
      // );

      // Calling requestBlood function from the contract
      final transaction = Transaction.callContract(
        contract: contract!,
        function: requestBlood!,
        parameters: [donorAddress, patientName, patientContact, bloodGroup],
        from: patientAddress, // Transaction is sent from the patient's wallet
      );

      final txHash = await client!
          .sendTransaction(patientCredentials, transaction, chainId: 1337);

      // Navigator.pop(context); // Close loading dialog
      return txHash;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> getRequestStatusFunction(
      String _patientAddress, BuildContext context) async {
    final EthereumAddress patientAddress =
        EthereumAddress.fromHex(_patientAddress);
    try {
      // Convert the patient address to EthereumAddress
      print("object");
      if (client == null || contract == null || getEligibleDonors == null) {
        throw Exception("Blockchain service not initialized.");
      }
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }

      // Call the getRequestStatus smart contract function
      final result = await client!.call(
        contract: contract!,
        function: getRequestStatus!,
        params: [patientAddress],
      );

      // Initialize a list to store the patient's requests
      final List<Map<String, dynamic>> patientRequests = [];

      // Loop through the response and add each blood request to the list
      for (var request in result[0]) {
        patientRequests.add({
          "id": request[0].toString(), // Request ID
          "name": request[3].toString(), // Donor address
          "bg": mapBloodGroup(
              int.parse(request[5].toString())), // Requested blood group
          "status": mapRequestStatus(
              int.parse(request[6].toString())), // Status of the request
        });
      }

      // Return the list of blood requests
      return patientRequests;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return [];
    }
  }
}
