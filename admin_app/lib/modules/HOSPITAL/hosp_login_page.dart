import 'package:flutter/material.dart';
import '../../components/my_textfield.dart';
import 'hosp_home_page.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HospLogin extends StatefulWidget {
  const HospLogin({Key? key}) : super(key: key);

  @override
  State<HospLogin> createState() => _HospLoginState();
}

class _HospLoginState extends State<HospLogin> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final url =
      "<PASTE API LINK>";

  Future<void> _Hosplogin() async {
    final email = usernameController.text;
    final pass = passwordController.text;
    final res = await http.post(Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': pass,
          'returnSecureToken': true,
        }));
    if ((res.statusCode == 200)) {
      print(res.statusCode);
      Get.to(() => HospHomePage());
    } else {
      Get.snackbar("Error", "Invalid Login",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'lib/Images/adminlogo.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              Text(
                'Welcome to BloodLink Hospital!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap:
                      _Hosplogin, // Use the same function as in ElevatedButton
                  child: Container(
                    width: 300, // Specify the width of the container
                    decoration: BoxDecoration(
                      color: Colors.blue, // Button color
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          blurRadius: 10, // Shadow blur
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16), // Vertical padding only
                    alignment: Alignment.center, // Center the text
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AcceptPage()),
                      );
                    },
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AcceptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Page'),
        backgroundColor: Colors.red[400],
      ),
      body: Center(
        child: Text(
          'You have accepted the request!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
