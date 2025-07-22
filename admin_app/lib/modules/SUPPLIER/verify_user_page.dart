import 'package:flutter/material.dart';
import 'package:helloworld/services/constants.dart';
import 'package:provider/provider.dart';

import '../../services/admin_services.dart';

class VerifyUserPage extends StatefulWidget {
  const VerifyUserPage({Key? key}) : super(key: key);

  @override
  State<VerifyUserPage> createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  final TextEditingController idController = TextEditingController();

  Future<void> verify() async {
    if (!_validate()) return;
    final donorkey = idController.text.trim();
    try {
      final service = Provider.of<AdminService>(context, listen: false);
      while (service.setStatus == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (service.setStatus == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash =
          await service.setStatusFunction(adminAddress, donorkey, 1, context);
      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verified Successful! TxHash: $txHash')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blockchain Registration Failed!')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _validate() {
    final enteredId = idController.text;
    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an ID and select a status.")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Verifiability',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        elevation: 30,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Input Field
            Text("Enter Request ID:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: "Enter ID",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
