import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/services/admin_services.dart';
import 'package:provider/provider.dart';
import 'modules/home.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AdminService>(
      create: (context) => AdminService(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}
