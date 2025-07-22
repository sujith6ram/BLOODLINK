import 'package:flutter/material.dart';
import 'add_members_page.dart';
import 'track_temp_page.dart';
import 'view_donors_page.dart';
import 'view_patients_page.dart';
import 'track_blood_page.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Admin Home Page',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[300],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Add Blood Bank\'s',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSuppPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Add Hospitals',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddHospPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'View Donors',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDonorsPage()),
                  );
                },
              ),
              SizedBox(height: 20), // Space between buttons
              CustomButton(
                text: 'View Patients',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewPatientsPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Track Blood',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackBloodPage()),
                  );
                },
              ),
              SizedBox(height: 20), // Space between buttons
              CustomButton(
                text: 'Check Temperature',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrackTempPage()),
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
