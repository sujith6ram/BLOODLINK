import 'package:flutter/material.dart';

class StatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select State'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tamil Nadu'),
            onTap: () {
              // Navigate to another page or perform an action
            },
          ),
        ],
      ),
    );
  }
}
