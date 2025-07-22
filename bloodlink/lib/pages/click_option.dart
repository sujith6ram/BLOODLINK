import 'package:flutter/material.dart';
// import 'package:helloworld/pages/login_page.dart';
import 'receive_page.dart';
import 'donor_page.dart'; // Import the DonePage

// sujith@gmail.com
// sujithram
class DonorReceivePage extends StatelessWidget {
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
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {
          //     // Handle back action
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Signin()),
          //     );
          //   },
          // ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'DONOR',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonorPage()),
                );
              },
            ),
            SizedBox(height: 20), // Space between buttons
            CustomButton(
              text: 'RECIPENT',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipientPage()),
                );
              },
            ),
          ],
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
