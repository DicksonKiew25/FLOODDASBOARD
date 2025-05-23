import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'databasewritor.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);
final Color dropdownColor = Color(0xFFB0E0E6);

class DrainDropdown extends StatefulWidget {
  const DrainDropdown({super.key});

  @override
  State<DrainDropdown> createState() => _DrainDropdownState();
}

class _DrainDropdownState extends State<DrainDropdown> {
  String? selectedDrain;

  bool isSupportedDrain(String? drain) {
    return ['Drain 001', 'Drain 002', 'Drain 003', 'Drain 004'].contains(drain);
  }

  void _onDrainChange(String? value) {
    if (value != null && isSupportedDrain(value)) {
      debugPrint("Selected supported drain: $value");
    } else {
      debugPrint("Unsupported drain or null value selected");
    }
    setState(() {
      selectedDrain = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dropdown
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: DropdownButtonFormField<String>(
            value: selectedDrain,
            hint: const Text('Drain Data'),
            items: List.generate(
              6,
              (index) => DropdownMenuItem(
                value: 'Drain 00${index + 1}',
                child: Text('Drain 00${index + 1}', style: const TextStyle(fontSize: 14)),
              ),
            ),
            onChanged: _onDrainChange,
            decoration: InputDecoration(
              filled: true,
              fillColor: dropdownColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            dropdownColor: dropdownColor,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            iconEnabledColor: primaryColor,
          ),
        ),

        const SizedBox(width: 20),

        // Flowrate
        Expanded(
          child: Row(
            children: [
              const Text("Flowrate:", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              const Expanded(
                child: FlowrateWidget(),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Water level
       Expanded(
            child: Row(
              children: [
                const Text("Water Level:", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                const Expanded(
                  child: WaterLevelWidget(),
                ),
              ],
            ),
          ),

        const SizedBox(width: 20),

   ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32), // White edge (~1cm)
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Stack(
                      children: [
                        // Storm Channel Background Image
                        Image.asset(
                          'assets/stormchannel.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                        // Overlay UI
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                // Top Row (REC & Battery)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "● REC",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.battery_full, color: Colors.white),
                                  ],
                                ),
                                const Spacer(),

                                // Crosshair
                                const Center(
                                  child: Icon(Icons.add, size: 40, color: Colors.white),
                                ),
                                const Spacer(),

                                // Bottom Row (Timer & Icon)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("00:00:01", style: TextStyle(color: Colors.white)),
                                    Icon(Icons.rectangle_rounded, color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button (Top-Right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
  child: const Text(
    "Storm Channel Condition",
    style: TextStyle(fontSize: 12, color: Colors.white),
  ),
),



      ],
    );
  }
}
