import 'package:flutter/material.dart';
import 'package:helloworld/services/bloodlink_services.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'package:get/get.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BloodLinkService>(
      create: (context) => BloodLinkService(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Signin(),
      ),
    );
  }
}
