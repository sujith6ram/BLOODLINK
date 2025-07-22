import 'package:flutter/material.dart';
import 'package:helloworld/services/admin_services.dart';

class ViewDonorsPage extends StatefulWidget {
  const ViewDonorsPage({Key? key}) : super(key: key);

  @override
  State<ViewDonorsPage> createState() => _ViewDonorsPageState();
}

class _ViewDonorsPageState extends State<ViewDonorsPage> {
  List<Map<String, dynamic>> donorsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  Future<void> fetchDonors() async {
    final service = AdminService();
    try {
      List<Map<String, dynamic>> donors =
          await service.viewDonorsFunction(context);
      setState(() {
        donorsList = donors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching donors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DONOR\'S',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : donorsList.isEmpty
              ? Center(
                  child: Text(
                    "No donors found!",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: donorsList.length,
                    itemBuilder: (context, index) {
                      final request = donorsList[index];
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
                                'ID: ${request["ID"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Name: ${request["name"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'BG: ${request["bloodGroup"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Location: ${request["location"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Contact: ${request["contact"]}',
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
