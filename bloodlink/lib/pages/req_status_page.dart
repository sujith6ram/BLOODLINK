import 'package:flutter/material.dart';
import 'package:helloworld/services/bloodlink_services.dart';
import 'package:helloworld/services/constants.dart';

class RequestStatus extends StatefulWidget {
  const RequestStatus({super.key});

  @override
  State<RequestStatus> createState() => _RequestStatusState();
}

class _RequestStatusState extends State<RequestStatus> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchStatusList);
  }

  Future<void> fetchStatusList() async {
    final blockchainService =
        BloodLinkService(); // Create an instance of the service

    try {
      await blockchainService.init();
      print("Sending to contract:");
      print("object");
      String? add = GlobalData.address;
      List<Map<String, dynamic>> req =
          await blockchainService.getRequestStatusFunction(add!, context);

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
          'REQUEST STATUS\'S',
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
                                'ID: ${request["id"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'NAME: ${request["name"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'BLOODGROUP: ${request["bg"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'STATUS: ${request["status"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
