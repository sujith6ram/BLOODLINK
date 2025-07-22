import 'package:flutter/material.dart';
import 'SUPPLIER/supp_login.dart';
import 'HOSPITAL/hosp_login_page.dart';
import 'ADMIN/admin_login_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200), // Custom height for the AppBar
        child: AppBar(
          flexibleSpace: ClipPath(
            clipper: AppBarClipper(),
            child: Container(
              color: Color(0xffb5635d), // Replace with your desired color
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'BloodLink',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Admin',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
            ),
            SizedBox(height: 20), // Space between buttons
            CustomButton(
              text: 'Blood Bank',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuppLogin()),
                );
              },
            ),
            SizedBox(height: 20), // Space between buttons
            CustomButton(
              text: 'Hospital',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HospLogin()),
                );
              },
            ),
          ],
        ),
      ),
    );
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
          elevation: 50, // Remove button elevation
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

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
