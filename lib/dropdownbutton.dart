import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Expanded(
                child: Container(
                  height: 30,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  // Replace with actual widget to fetch Flowrate
                  child: Text("___"), // TODO: Call flowrate widget
                ),
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
              Expanded(
                child: Container(
                  height: 30,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  // Replace with actual widget to fetch water level
                  child: Text("___"), // TODO: Call water level widget
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Storm channel condition
        ElevatedButton(
          onPressed: () {
            // TODO: Call external Dart file or method
            debugPrint("Storm channel condition pressed");
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
