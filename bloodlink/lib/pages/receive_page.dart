// receive_page.dart
import 'package:flutter/material.dart';
import 'donor_list_page.dart';
import 'req_status_page.dart';

class RecipientPage extends StatefulWidget {
  @override
  _RecipientPageState createState() => _RecipientPageState();
}

class _RecipientPageState extends State<RecipientPage> {
  // Variables to store selected options
  String? selectedBloodGroup;
  String? selectedCountry;
  String? selectedState;

  // Sample data for dropdowns
  final List<String> bloodGroups = [
    'A+ve',
    'A-ve',
    'B+ve',
    'B-ve',
    'O+ve',
    'O-ve',
    'AB+ve',
    'AB-ve'
  ];
  final List<String> countries = ['India', 'USA', 'UK', 'Canada'];
  final List<String> states = ['Tamil nadu', 'California', 'London', 'Ontario'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RECIPIENT',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 30,
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Status Button
            Center(
              child: Container(
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
                alignment:
                    Alignment.center, // Center the text inside the container
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestStatus()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Transparent background for the button itself
                    elevation:
                        30, // Remove button elevation (handled by the container)
                    padding: EdgeInsets
                        .zero, // Remove padding to make button fit container
                  ),
                  child: Text(
                    'REQUEST STATUS',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Search Donor Header
            Text(
              'SEARCH DONOR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Dropdown: Select Blood Group
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'SELECT BLOODGROUP',
              ),
              value: selectedBloodGroup,
              items: bloodGroups.map((String bloodGroup) {
                return DropdownMenuItem<String>(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBloodGroup = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Dropdown: Select Country
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'SELECT COUNTRY',
              ),
              value: selectedCountry,
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Dropdown: Select State
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'SELECT STATE',
              ),
              value: selectedState,
              items: states.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                });
              },
            ),
            SizedBox(height: 24),

            // Search Button
            Center(
              child: Container(
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
                alignment:
                    Alignment.center, // Center the text inside the container
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedBloodGroup == null ||
                        selectedCountry == null ||
                        selectedState == null) {
                      // Show Snackbar error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Please fill all fields before searching!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchResultsPage(
                                  bloodGroup: selectedBloodGroup!,
                                  country: selectedCountry!,
                                  state: selectedState!,
                                )),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Transparent background for the button itself
                    elevation:
                        30, // Remove button elevation (handled by the container)
                    padding: EdgeInsets
                        .zero, // Remove padding to make button fit container
                  ),
                  child: Text(
                    'SEARCH',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
