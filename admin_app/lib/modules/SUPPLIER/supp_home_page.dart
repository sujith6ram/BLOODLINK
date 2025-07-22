import 'package:flutter/material.dart';
import 'package:helloworld/modules/SUPPLIER/donation_page.dart';
import '../ADMIN/track_blood_page.dart';
import '../ADMIN/track_temp_page.dart';
import 'add_user_page.dart';
import 'avail_page.dart';
import 'verify_user_page.dart';

class SuppHomePage extends StatefulWidget {
  const SuppHomePage({Key? key}) : super(key: key);

  @override
  State<SuppHomePage> createState() => _SuppHomePageState();
}

class _SuppHomePageState extends State<SuppHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Supplier Home Page',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[300],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Add User',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddUserPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Verify Availability of Blood',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AvailPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Verify Blood',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyUserPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Donation',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Space between buttons
              CustomButton(
                text: 'View Temperature',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackTempPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Track Blood',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackBloodPage()),
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
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
        border: Border.all(
          color: Colors.black, // Black border color
          width: 2, // Border width
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
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
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
