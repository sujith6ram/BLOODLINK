import 'package:flutter/material.dart';
import 'package:helloworld/services/admin_services.dart';

class TrackBloodPage extends StatefulWidget {
  const TrackBloodPage({super.key});

  @override
  State<TrackBloodPage> createState() => _TrackbloodPageState();
}

class _TrackbloodPageState extends State<TrackBloodPage> {
  final TextEditingController address = TextEditingController();

  bool _validate() {
    final enteredId = address.text;
    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter address and select a status.")),
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
          'Enter address',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        elevation: 30,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Input Field
            Text("Enter Address:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: address,
              decoration: InputDecoration(
                hintText: "Enter address",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Detailtrack(Address: address.text.trim())),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Detailtrack extends StatefulWidget {
  final String Address;
  const Detailtrack({
    required this.Address,
    Key? key,
  }) : super(key: key);

  @override
  State<Detailtrack> createState() => _DetailtrackState();
}

class _DetailtrackState extends State<Detailtrack> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchStatusList);
  }

  Future<void> fetchStatusList() async {
    final blockchainService =
        AdminService(); // Create an instance of the service

    try {
      await blockchainService.init();
      print("Sending to contract:");
      print("object");
      List<Map<String, dynamic>> req =
          await blockchainService.trackBloodFunction(widget.Address, context);

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
          'TRACKING STATUS\'S',
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
                    "No Status found!",
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
                                'LOCATION: ${request["status"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
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
