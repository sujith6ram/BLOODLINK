import 'package:flutter/material.dart';
import 'package:helloworld/services/constants.dart';
import 'package:provider/provider.dart';

import '../services/bloodlink_services.dart';

class SearchResultsPage extends StatefulWidget {
  final String bloodGroup;
  final String country;
  final String state;

  const SearchResultsPage({
    required this.bloodGroup,
    required this.country,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchDonorList);
  }

  Future<void> fetchDonorList() async {
    final blockchainService =
        BloodLinkService(); // Create an instance of the service

    try {
      await blockchainService.init();
      print("Sending to contract:");
      print(
          "BloodGroup: ${widget.bloodGroup} (${widget.bloodGroup.runtimeType})");
      print("Country: ${widget.country} (${widget.country.runtimeType})");
      print("State: ${widget.state} (${widget.state.runtimeType})");
      List<Map<String, dynamic>> req =
          await blockchainService.getEligibleDonorsFunction(widget.bloodGroup,
              widget.country, widget.state, true, true, context);

      setState(() {
        requests = req;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching donors history: $e");
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
          'LIST OF DONOR\'S',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : requests.isEmpty
              ? Center(
                  child: Text(
                    "No Donors found!",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NAME: ${request["name"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'GENDER: ${request["gender"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'BLOODGROUP: ${request["bloodgroup"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'CONTACT: ${request["contact"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RequestPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red[400], // Background color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'REQUEST',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController donorAddress = TextEditingController();

  Future<void> giveReq() async {
    print("entred00");
    // if (_validateInputs()) return;
    final donorAdd = donorAddress.text.trim();
    final patientK = GlobalData.privatekey;
    final name = GlobalData.name;
    final contact = GlobalData.contact;
    final bgroup = GlobalData.bg;
    try {
      print("entred00");
      final bloodLinkService =
          Provider.of<BloodLinkService>(context, listen: false);
      while (bloodLinkService.requestBlood == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (bloodLinkService.requestBlood == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash = await bloodLinkService.requestBloodFunction(
        donorAdd,
        patientK!,
        name!,
        contact!,
        bgroup!,
        context,
      );

      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request Successful! TxHash: $txHash')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blockchain Registration Failed!')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _validateInputs() {
    if (donorAddress.text.isEmpty) {
      print('Please fill in all the fields');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Id
            TextField(
              controller: donorAddress,
              decoration: InputDecoration(labelText: 'Donor Address'),
            ),
            SizedBox(height: 20),

            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: giveReq, // Calls the registration function

                //Handle registration logic here
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Registration Submitted')),
                // );
                child: Text('REQUEST'),
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
