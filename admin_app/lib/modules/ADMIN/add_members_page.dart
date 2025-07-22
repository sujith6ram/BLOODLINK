import 'package:flutter/material.dart';
import 'package:helloworld/services/admin_services.dart';
import 'package:helloworld/services/constants.dart';
import 'package:provider/provider.dart';

class AddSuppPage extends StatefulWidget {
  @override
  _AddSuppPageState createState() => _AddSuppPageState();
}

class _AddSuppPageState extends State<AddSuppPage> {
  final TextEditingController idController = TextEditingController();

  Future<void> Registerbank() async {
    if (!_validate()) return;
    final suppKey = idController.text.trim();
    try {
      final service = Provider.of<AdminService>(context, listen: false);
      while (service.addBorH == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (service.addBorHFunction == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash =
          await service.addBorHFunction(adminAddress, suppKey, true, context);
      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Bloodbank Registration Successful! TxHash: $txHash')),
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
        SnackBar(content: Text("Please enter an ID.")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Blood Bank Info'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Input Field
            Text("Enter BloodBank ID:",
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
                onPressed: Registerbank,
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

class AddHospPage extends StatefulWidget {
  @override
  _AddHospPageState createState() => _AddHospPageState();
}

class _AddHospPageState extends State<AddHospPage> {
  final TextEditingController idController = TextEditingController();

  Future<void> Registerhosp() async {
    if (!_validate()) return;
    final hospKey = idController.text.trim();
    try {
      final service = Provider.of<AdminService>(context, listen: false);
      if (service.addBorHFunction == null) {
        print("Error: addSuppliers function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash =
          await service.addBorHFunction(adminAddress, hospKey, false, context);
      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Hospital Registration Successful! TxHash: $txHash')),
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
        SnackBar(content: Text("Please enter an ID.")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Hospital Info'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Input Field
            Text("Enter Hospital ID:",
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
                onPressed: Registerhosp,
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
