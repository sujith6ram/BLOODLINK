import 'package:flutter/material.dart';
import 'package:helloworld/modules/SUPPLIER/supp_home_page.dart';
import 'package:helloworld/services/admin_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  bool isEmergencyAvailable = false;
  bool isAuthorized = false;

  final url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA_GcisUvxJxbv-hEuQprCLoyApcsdnWbY';

  Future<void> registerPage() async {
    if (!_validateInputs()) return;

    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final donorPrivateKey = userIdController.text.trim();
    final name = fullNameController.text.trim();
    final gender = genderController.text.trim();
    final bloodGroup = bloodGroupController.text.trim();
    final contact = mobileNumberController.text.trim();
    final country = countryController.text.trim();
    final state = stateController.text.trim();
    try {
      // Firebase Authentication Signup
      final res = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': pass,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final userId = data['localId'];

        // Step 2: Blockchain Donor Registration
        final bloodLinkService =
            Provider.of<AdminService>(context, listen: false);
        String txHash = await bloodLinkService.registerDonorFunction(
          donorPrivateKey,
          name,
          gender,
          bloodGroup,
          contact,
          country,
          state,
          context,
        );

        if (txHash.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful! TxHash: $txHash')),
          );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuppHomePage()),
        );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Blockchain Registration Failed!')),
          );
        }
      } else {
        final errorMessage = json.decode(res.body)['error']['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase Error: $errorMessage')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _validateInputs() {
    if (userIdController.text.isEmpty ||
        passwordController.text.isEmpty ||
        retypePasswordController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        genderController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        bloodGroupController.text.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        districtController.text.isEmpty ||
        cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
      return false;
    }
    if (passwordController.text != retypePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    }

    if (!isEmergencyAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please confirm availability in case of emergency')),
      );
      return false;
    }

    if (!isAuthorized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must authorize to proceed')),
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
          'Blood Donor Registration Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Id
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'Privatekey Id'),
            ),
            SizedBox(height: 10),

            // Password
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),

            // Retype Password
            TextField(
              controller: retypePasswordController,
              decoration: InputDecoration(labelText: 'Retype Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),

            // Full Name
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 10),

            // Blood Group Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Blood Group'),
              items: [
                'A+ve',
                'A-ve',
                'B+ve',
                'B-ve',
                'O+ve',
                'O-ve',
                'AB+ve',
                'AB-ve'
              ]
                  .map((bloodGroup) => DropdownMenuItem(
                        value: bloodGroup,
                        child: Text(bloodGroup),
                      ))
                  .toList(),
              onChanged: (value) {
                bloodGroupController.text = value!;
              },
            ),
            SizedBox(height: 10),

            // gender
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                genderController.text = value!;
              },
            ),
            SizedBox(height: 10),

            // Mobile Number
            TextField(
              controller: mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),

            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),

            // Country Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Country'),
              items: ['India']
                  .map((country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ))
                  .toList(),
              onChanged: (value) {
                countryController.text = value!;
              },
            ),
            SizedBox(height: 10),

            // State Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'State'),
              items: ['Tamil nadu']
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) {
                stateController.text = value!;
              },
            ),
            SizedBox(height: 10),

            // District Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'District'),
              items: [
                'Ariyalur',
                'Chennai',
                'Coimbatore',
                'Cuddalore',
                'Dharmapuri',
                'Erode',
                'Kancheepuram',
                'Kanyakumari',
                'Krishnagiri',
                'Madurai',
                'Namakkal',
                'Pudukkottai',
                'Ranipet',
                'Salem',
                'Thanjavur',
                'Tiruvannamalai',
                'Vellore',
                'Vilupuram'
              ]
                  .map((district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ))
                  .toList(),
              onChanged: (value) {
                districtController.text = value!;
              },
            ),
            SizedBox(height: 10),

            // City
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 20),

            // Emergency Checkbox
            Row(
              children: [
                Checkbox(
                  value: isEmergencyAvailable,
                  onChanged: (value) {
                    setState(() {
                      isEmergencyAvailable = value!;
                    });
                  },
                ),
                Text('Available in case of Emergency'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isAuthorized,
                  onChanged: (value) {
                    setState(() {
                      isAuthorized = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                      'I authorize this app and state that I am above 18 years old. I agree to display my details, so that nearby people can contact me.'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: registerPage, // Calls the registration function

                //Handle registration logic here
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Registration Submitted')),
                // );
                child: Text('REGISTER USER'),
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
