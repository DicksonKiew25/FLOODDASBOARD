import 'package:flutter/material.dart';

import 'sidewidget.dart';         // For owner
import 'sidewidgetclient.dart';  // For client

class Dashboard extends StatelessWidget {
  final String role; // "owner" or "client"

  const Dashboard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Redirect immediately after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (role == 'owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppDrawer(currentScreen: 'Drain Map')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppDrawerclient(currentScreen: 'Drain Map')),
        );
      }
    });

    // Temporary scaffold shown before redirection
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
