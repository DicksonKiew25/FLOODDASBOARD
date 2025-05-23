import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dropdownbutton.dart';
import 'sidewidget.dart';
import 'animatedbackground.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double spacing = 20.0; // ~0.5 cm
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Monitor'),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 6,
        centerTitle: true,
        shadowColor: primaryColor.withOpacity(0.4),
        title: Text(
          'Monitor',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BackgroundWrapper(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Column(
            children: [
              // TOP PART: 60% height
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    // Left Container - 70%
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(right: spacing / 2),
                        padding: const EdgeInsets.all(16),
                        child: const Center(child: Text("Left Widget")),
                      ),
                    ),
                    // Right Container - 30%
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(left: spacing / 2),
                        padding: const EdgeInsets.all(16),
                        child: const Center(child: Text("Right Widget")),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing), // spacing between top and bottom

              // BOTTOM PART: 40% height
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    // Top part of the bottom section (30%)
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: spacing / 2),
                        child: const DrainDropdown(), // Small dropdown in upper part
                      ),
                    ),
                    // Bottom part of the bottom section (70%)
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(child: Text("Bottom Widget Content")),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
