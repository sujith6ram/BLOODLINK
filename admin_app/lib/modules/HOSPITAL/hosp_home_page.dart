import 'package:flutter/material.dart';
import 'package:helloworld/modules/SUPPLIER/donation_page.dart';
import 'package:helloworld/services/admin_services.dart';
import 'package:helloworld/services/constants.dart';
import 'package:provider/provider.dart';

class HospHomePage extends StatefulWidget {
  const HospHomePage({Key? key}) : super(key: key);

  @override
  State<HospHomePage> createState() => _HospHomePageState();
}

class _HospHomePageState extends State<HospHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hospital'),
          backgroundColor: Colors.red[300],
          elevation: 30,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Donation',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationPage()),
                  );
                },
              ),
              SizedBox(height: 20), 
              CustomButton(
                text: 'Fullfill Donation',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullfillPage()),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Specify the width of the container
      decoration: BoxDecoration(
        color: Colors.blue, // Button color
        borderRadius: BorderRadius.circular(15), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Shadow color
            blurRadius: 10, // Shadow blur
            offset: Offset(0, 4), // Shadow position
          ),
        ],
        border: Border.all(
          color: Colors.black, // Black border color
          width: 2, // Border width
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16), // Vertical padding
      alignment: Alignment.center, // Center the text inside the container
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 30, // Remove button elevation
          padding: EdgeInsets.zero, // Remove padding to fit the container
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FullfillPage extends StatefulWidget {
  const FullfillPage({Key? key}) : super(key: key);

  @override
  State<FullfillPage> createState() => _FullfillPageState();
}

class _FullfillPageState extends State<FullfillPage> {
  final TextEditingController idController = TextEditingController();

  Future<void> fulfill() async {
    if (!_validate()) return;
    final donorkey = idController.text.trim();
    try {
      final service = Provider.of<AdminService>(context, listen: false);
      if (service.setStatus == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash =
          await service.setStatusFunction(adminAddress, donorkey, 2, context);
      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fullfilled Successful! TxHash: $txHash')),
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
          'Enter Info',
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
            Text("Enter Address:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: "Enter Address",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: fulfill,
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
