import 'package:flutter/material.dart';
import 'loginscreen.dart'; // Make sure this file contains LoginPage

void main() {
  runApp(const DrainDashboardApp());
}

class DrainDashboardApp extends StatelessWidget {
  const DrainDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flood Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Only show login page
    );
  }
}
