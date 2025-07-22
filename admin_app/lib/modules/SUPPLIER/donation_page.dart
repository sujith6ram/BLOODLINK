import 'package:flutter/material.dart';
import 'package:helloworld/services/admin_services.dart';
import 'package:provider/provider.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TextEditingController donorAddress = TextEditingController();
  final TextEditingController place = TextEditingController();

  Future<void> dblood() async {
    print("entred00");
    // if (_validateInputs()) return;
    final donorAdd = donorAddress.text.trim();
    final location = place.text.trim();

    try {
      print("enter");
      print("entred00");
      final admin = Provider.of<AdminService>(context, listen: false);
      while (admin.donateBloodFunction == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (admin.donateBloodFunction == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash = await admin.donateBloodFunction(
        donorAdd,
        location,
        context,
      );

      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donation Successful! TxHash: $txHash')),
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

  bool _validateInputs() {
    if (donorAddress.text.isEmpty || place.text.isEmpty) {
      print('Please fill in all the fields');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Id
            TextField(
              controller: donorAddress,
              decoration: InputDecoration(labelText: 'Donor Address'),
            ),
            SizedBox(height: 10),

            // Password
            TextField(
              controller: place,
              decoration: InputDecoration(labelText: 'Location of Donation'),
            ),

            SizedBox(height: 20),

            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: dblood, // Calls the registration function

                //Handle registration logic here
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Registration Submitted')),
                // );
                child: Text('DONE'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
