import 'package:flutter/material.dart';
import 'package:helloworld/services/bloodlink_services.dart';
import 'package:helloworld/services/constants.dart';
import 'package:provider/provider.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({Key? key}) : super(key: key);

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchReqList);
  }

  Future<void> fetchReqList() async {
    final blockchainService =
        BloodLinkService(); // Create an instance of the service

    try {
      await blockchainService.init();
      print("Sending to contract:");
      List<Map<String, dynamic>> req = await blockchainService
          .getApprovedRequestsFunction(GlobalData.address!, context);

      setState(() {
        requests = req;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching Requests: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> acceptit(int _id) async {
    print("entred00");
    // if (_validateInputs()) return;
    final int ID = _id;

    try {
      print("entred00");
      final service = Provider.of<BloodLinkService>(context, listen: false);
      while (service.respondToRequestFunction == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (service.respondToRequestFunction == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash = await service.respondToRequestFunction(
        ID,
        GlobalData.privatekey!,
        context,
      );

      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Accepted Successful! TxHash: $txHash')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BLOOD REQUEST\'S',
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
                    "No Requests found!",
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
                                'ID: ${request["id"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'NAME: ${request["patientName"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'BLOOD GROUP: ${request["requestedBloodGroup"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      acceptit(int.parse(request["id"])),
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
                                    'ACCEPT',
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
