import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart';

class AdminService extends ChangeNotifier {
  final String rpcUrl = "<RPCURL FROM GANACHE>";
  final String wsUrl = "<WSURL FROM GANACHE>";
  final String adminPrivateKey =
      "<>"; // Admin's private key
  final String adminAddress =
      "<>"; // Admin's address

  Web3Client? client;
  Credentials? credentials;
  EthereumAddress? contractAddress;
  ContractAbi? contractAbi;
  DeployedContract? contract;

  // Contract functions
  ContractFunction? donateBlood;
  ContractFunction? approveRequest;
  ContractFunction? viewDonors;
  ContractFunction? viewPatients;
  ContractFunction? addBorH;
  ContractFunction? trackBlood;
  ContractFunction? setStatus;
  ContractFunction? setVerify;
  ContractFunction? setFulfill;

  ContractFunction? registerDonor;

  bool isLoading = true;

  AdminService() {
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
      print("Admin Private Key Length: ${adminPrivateKey.length}");
      print("Admin Address Length: ${adminAddress.length}");

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
        'E:/smartcontract/build/contracts/BloodLink.json');
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
    try {
      donateBlood = contract!.function("donateBlood");
      approveRequest = contract!.function("approveRequest");
      viewDonors = contract!.function("viewDonors");
      viewPatients = contract!.function("viewPatients");
      addBorH = contract!.function("addBorH");
      trackBlood = contract!.function("trackBlood");
      setStatus = contract!.function("setStatus");

      registerDonor = contract!.function("registerDonor");

      print("Functions mapped successfully!");
    } catch (e) {
      print("Error in function mapping: $e");
    }

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

  String mapState(int value) {
    List<String> state = [
      "Tamil Nadu",
      "Kerala",
      "Karnataka",
      "Andhra Pradesh"
    ];
    print("Mapping location index: $value"); // Debugging statement
    return (value >= 0 && value < state.length)
        ? state[value]
        : "Invalid Location ($value)";
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

  Future<String> donateBloodFunction(
      String donorAddress, String place, BuildContext context) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String status = "p";
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }

      final transaction = Transaction.callContract(
          contract: contract!,
          function: donateBlood!,
          parameters: [
            EthereumAddress.fromHex(donorAddress),
            place,
            date,
            status
          ],
          from: EthereumAddress.fromHex(adminAddress));
      final txHash = await client!.sendTransaction(
        credentials!,
        transaction,
        chainId: 1337, // Use correct chain ID
      );
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

  Future<String> approveRequestFunction(
      int requestID, BuildContext context) async {
    const bool approve = true;
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();

      final transaction = Transaction.callContract(
        contract: contract!,
        function: approveRequest!,
        parameters: [
          BigInt.from(requestID),
          approve,
        ],
        from: EthereumAddress.fromHex(adminAddress),
      );
      final txHash = await client!.sendTransaction(
        credentials!,
        transaction,
        chainId: 1337, // Use correct chain ID
      );
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

  Future<List<Map<String, dynamic>>> viewDonorsFunction(
      BuildContext context) async {
    while (contract == null) {
      print("Waiting for contract initialization...");
      await Future.delayed(Duration(seconds: 1));
    }
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      List<dynamic> result = await client!.call(
        contract: contract!,
        function: viewDonors!,
        params: [],
      );
      final List<Map<String, dynamic>> donorsList = [];
      Navigator.pop(context); // Close loading dialog

      for (var user in result[0]) {
        print("Raw Location Value: ${user[5]}");
        print("Raw user data: $user");
        print("Raw Location Enum Value: ${user[5]}"); // Debugging

        int? locationIndex;
        try {
          locationIndex = (user[5] is BigInt)
              ? (user[5] as BigInt).toInt()
              : int.parse(user[5].toString());
        } catch (e) {
          print("Error parsing location index: $e");
        }

        print("Parsed Location Index: $locationIndex");

        donorsList.add({
          "ID": user[0].toString(),
          "name": user[1].toString(),
          "bloodGroup": mapBloodGroup(int.parse(user[3].toString())),
          "location": locationIndex != null
              ? mapState(locationIndex)
              : "Invalid Location",
          "contact": user[6].toString(),
        });
        print("Mapped Location: ${mapState(locationIndex!)}");
      }

      return donorsList;
    } catch (e) {
      print("Error123: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> viewPatientsFunction(
      BuildContext context) async {
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      List<dynamic> result = await client!.call(
        contract: contract!,
        function: viewPatients!,
        params: [],
      );
      final List<Map<String, dynamic>> patientsList = [];
      Navigator.pop(context); // Close loading dialog

      for (var user in result[0]) {
        patientsList.add({
          "ID": user[0].toString(),
          "name": user[3].toString(),
          "bloodGroup": mapBloodGroup(int.parse(user[5].toString())),
          "contact": user[4].toString(),
        });
      }

      return patientsList;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }

  Future<String> addBorHFunction(String adminAddress, String userAddress,
      bool choose, BuildContext context) async {
    final EthereumAddress user = EthereumAddress.fromHex(userAddress);
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();

      final transaction = Transaction.callContract(
        contract: contract!,
        function: addBorH!,
        parameters: [user, choose],
        from: EthereumAddress.fromHex(adminAddress),
      );
      final txHash = await client!.sendTransaction(
        credentials!,
        transaction,
        chainId: 1337, // Update with your blockchain network ID
      );
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

  Future<List<Map<String, dynamic>>> trackBloodFunction(
      String donorAddress, BuildContext context) async {
    try {
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();

      // Calling the contract function (view function, no gas needed)
      final List<dynamic> result = await client!.call(
        contract: contract!,
        function: trackBlood!,
        params: [EthereumAddress.fromHex(donorAddress)],
      );

      final List<Map<String, dynamic>> trackList = [];
      Navigator.pop(context); // Close loading dialog

      for (var user in result[0]) {
        trackList.add({
          "status": mapStatus(int.parse(user[0].toString())),
        });
      }

      return trackList;
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }

  Future<String> setStatusFunction(String adminAddress, String userAddress,
      int num, BuildContext context) async {
    final EthereumAddress user = EthereumAddress.fromHex(userAddress);
    try {
      // Show loading dialog
      while (contract == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      notifyListeners();

      final transaction = Transaction.callContract(
        contract: contract!,
        function: setStatus!,
        parameters: [user, BigInt.from(num)],
        from: EthereumAddress.fromHex(adminAddress),
      );
      final txHash = await client!.sendTransaction(
        credentials!,
        transaction,
        chainId: 1337, // Update with your blockchain network ID
      );

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
}
