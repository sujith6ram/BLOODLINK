import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController yearOfBirthController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donor Registration Form'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Id
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User Id'),
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
              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                  .map((bloodGroup) => DropdownMenuItem(
                        value: bloodGroup,
                        child: Text(bloodGroup),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 10),

            // Year of Birth
            TextField(
              controller: yearOfBirthController,
              decoration: InputDecoration(labelText: 'Year of Birth'),
              keyboardType: TextInputType.number,
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
              onChanged: (value) {},
            ),
            SizedBox(height: 10),

            // State Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'State'),
              items: ['Tamil Nadu']
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 10),

            // District Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'District'),
              items: ['Andaman And Nicobar', 'Chennai', 'Bangalore']
                  .map((district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 10),

            // City
            TextField(
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 20),

            // Emergency Checkbox
            Row(
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                Text('Available in case of Emergency'),
              ],
            ),
            SizedBox(height: 10),

            // Confirm availability
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: 'Please Confirm your availability to donate'),
              items: ['Available', 'Not Available']
                  .map((availability) => DropdownMenuItem(
                        value: availability,
                        child: Text(availability),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),

            // Authorization Checkbox
            Row(
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                Expanded(
                  child: Text(
                      'I authorize this app and state that I am above 18 years old. I agree to display my details, so that Nearby could contact me.'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle registration logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration Submitted')),
                  );
                },
                child: Text('REGISTER'),
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
