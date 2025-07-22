import 'package:flutter/material.dart';
import 'package:helloworld/services/admin_services.dart';
import 'package:provider/provider.dart';

class ViewPatientsPage extends StatefulWidget {
  const ViewPatientsPage({Key? key}) : super(key: key);

  @override
  State<ViewPatientsPage> createState() => _ViewPatientsPageState();
}

class _ViewPatientsPageState extends State<ViewPatientsPage> {
  List<Map<String, dynamic>> patientList = [];
  bool isLoading = true;
  String? Id;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final service = AdminService();
    try {
      List<Map<String, dynamic>> patients =
          await service.viewPatientsFunction(context);
      setState(() {
        patientList = patients;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching patients: $e");
    }
  }

  Future<void> approveit(int _id) async {
    print("entred00");
    // if (_validateInputs()) return;
    final int ID = _id;

    try {
      print("entred00");
      final adminservice = Provider.of<AdminService>(context, listen: false);
      while (adminservice.approveRequestFunction == null) {
        print("Waiting for contract initialization...");
        await Future.delayed(Duration(seconds: 1));
      }
      if (adminservice.approveRequestFunction == null) {
        print("Error: function is null!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: Smart contract function not initialized')),
        );
        return;
      }
      String txHash = await adminservice.approveRequestFunction(
        ID,
        context,
      );

      if (txHash.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Approved Successful! TxHash: $txHash')),
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
          'PATIENT REQUEST\'S',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : patientList.isEmpty
              ? Center(
                  child: Text(
                    "No patients found!",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: patientList.length,
                    itemBuilder: (context, index) {
                      final request = patientList[index];
                      Id = request["ID"];
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
                              SizedBox(height: 8),
                              Text(
                                'NAME: ${request["name"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'BG: ${request["bloodGroup"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'CONTACT: ${request["contact"]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      approveit(int.parse(request["ID"])),
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
                                    'APPROVE',
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
