import 'package:flutter/material.dart';
import 'package:helloworld/services/bloodlink_services.dart';
import '../services/constants.dart';
import 'edit_page.dart';
import 'changepwd_page.dart';
import 'logout_page.dart';
import 'Events_page.dart';
import 'disp_req_page.dart';

class DonorPage extends StatefulWidget {
  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  // Sample donation history data
  List<Map<String, dynamic>> donationHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonationHistory();
  }

  Future<void> fetchDonationHistory() async {
    final blockchainService =
        BloodLinkService(); // Create an instance of the service

    try {
      List<Map<String, dynamic>> history = await blockchainService
          .donateHistoryFunction(GlobalData.address!, context);

      setState(() {
        donationHistory = history;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching donation history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donor\'s My Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffcd6155), // Custom color
        elevation: 30,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Events') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              } else if (value == 'Edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPage()),
                );
              } else if (value == 'Change Password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              } else if (value == 'Logout') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Events',
                child: Text('Events'),
              ),
              PopupMenuItem(
                value: 'Edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'Change Password',
                child: Text('Change Password'),
              ),
              PopupMenuItem(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      MaterialPageRoute(
                          builder: (context) => RequestListPage()),
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
                    'DONATE',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'LAST DONATED HISTORY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : donationHistory.isEmpty
                      ? Center(child: Text("No donation history found"))
                      : ListView.builder(
                          itemCount: donationHistory.length,
                          itemBuilder: (context, index) {
                            final item = donationHistory[index];
                            print(item["place"]);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PLACE: ${item["place"]}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'STATUS: ${item["status"]}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'DATE: ${item["date"]}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
//   return Container(
//     margin: EdgeInsets.only(bottom: 16.0),
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.lightBlue,
//         padding: EdgeInsets.symmetric(vertical: 15),
//         textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       child: Text(text),
//     ),
//   );
// }
