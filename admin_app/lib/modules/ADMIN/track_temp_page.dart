import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackTempPage extends StatefulWidget {
  const TrackTempPage({Key? key}) : super(key: key);

  @override
  State<TrackTempPage> createState() => _TrackTempPageState();
}

class _TrackTempPageState extends State<TrackTempPage> {
  // Example temperature value (you can update it dynamically from a sensor or API)
  double temperature = 0.0;

  // Function to determine the condition based on the temperature
  Future<void> fetchTemperature() async {
    final response = await http.get(
      Uri.parse(
          "PASTE FIREBASE LINK FOR TEMPERATURE"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperature = data["temperature"] ?? 0.0;
      });
    } else {
      print("Failed to fetch data");
    }
  }

  String getTemperatureCondition() {
    if (temperature > 20) {
      return "Alert";
    } else if (temperature < 10) {
      return "Danger";
    } else {
      return "Invalid";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Status'),
        backgroundColor: Colors.red[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the temperature value
            Text(
              "Temperature: ${temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchTemperature,
              child: Text("Refresh Data"),
            ),
            const SizedBox(height: 20),

            // Display the condition based on the temperature
            Text(
              getTemperatureCondition(),
              style: TextStyle(
                fontSize: 20,
                color: getTemperatureCondition() == "Danger"
                    ? Colors.red
                    : (getTemperatureCondition() == "Alert"
                        ? Colors.orange
                        : Colors.grey),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
