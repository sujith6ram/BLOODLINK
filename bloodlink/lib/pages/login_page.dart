import 'package:flutter/material.dart';
import 'package:helloworld/pages/register_page.dart';
import 'package:helloworld/services/constants.dart';
import 'click_option.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:helloworld/components/my_button.dart';
import 'package:helloworld/components/my_textfield.dart';
import 'package:get/get.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA_GcisUvxJxbv-hEuQprCLoyApcsdnWbY';

  Future<void> _Signin() async {
    try {
      final email = usernameController.text;
      final pass = passwordController.text;
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          }));
      if ((res.statusCode == 200)) {
        // Retrieve private key from SharedPreferences
        String? address = await UserPreferences.getAddress(email);
        String? privatek = await UserPreferences.getPrivateKey(email);
        String? _name = await UserPreferences.getName(email);
        String? _contact = await UserPreferences.getContact(email);
        String? _bg = await UserPreferences.getBloodGroup(email);
        if (address != null) {
          GlobalData.address = address;
          GlobalData.privatekey = privatek;
          GlobalData.name = _name;
          GlobalData.contact = _contact;
          GlobalData.bg = _bg;
          Get.to(() => DonorReceivePage());
        }
      } else {
        Get.snackbar("Error", "Invalid Login",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("HTTP Error: $e");
      Get.snackbar("Error", "Network Error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              Image.asset(
                'lib/Images/logo.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              Text(
                'Welcome to BloodLink!',
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
                  onTap: _Signin, // Use the same function as in ElevatedButton
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
                        MaterialPageRoute(builder: (context) => RegisterPage()),
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
