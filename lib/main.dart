import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Add this line
import 'databaseextractor.dart'; // This file contains DrainDataProvider class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDgA0xnDPAqxFQGfQxn7EF9rZeE26tExPg",
      appId: "1:YOUR_PROJECT_ID:web:somehash",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "drain-monitor-live",
      databaseURL: "https://drain-monitor-live-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => DrainDataProvider(), // 👈 make DrainDataProvider available
      child: const DrainDashboardApp(),         // 👈 pass your app as child
    ),
  );
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
      home: const LoginPage(),
    );
  }
}
