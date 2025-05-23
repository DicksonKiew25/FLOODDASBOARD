import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = const Color.fromARGB(255, 69, 87, 244);
final Color dropdownColor = const Color(0xFFB0E0E6);

class LocationHistoryGraph extends StatefulWidget {
  const LocationHistoryGraph({super.key});

  @override
  State<LocationHistoryGraph> createState() => _LocationHistoryGraphState();
}

class _LocationHistoryGraphState extends State<LocationHistoryGraph> {
  String? selectedLocation;

  bool isSupportedLocation(String? location) {
    return [
      'Bandar Botanic',
      'Bukit Tinggi',
      'Subang',
      'Kepong',
      'Port Klang'
    ].contains(location);
  }

  void _onLocationChange(String? value) {
    if (value != null && isSupportedLocation(value)) {
      debugPrint("Selected supported location: $value");
    } else {
      debugPrint("Unsupported location or null value selected");
    }
    setState(() {
      selectedLocation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for selecting location
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: DropdownButtonFormField<String>(
              value: selectedLocation,
              hint: const Text('Select Location'),
              items: [
                'Bandar Botanic',
                'Bukit Tinggi',
                'Subang',
                'Kepong',
                'Port Klang'
              ]
                  .map((location) => DropdownMenuItem(
                        value: location,
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
              onChanged: _onLocationChange,
              decoration: InputDecoration(
                filled: true,
                fillColor: dropdownColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: dropdownColor,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.black87),
              iconEnabledColor: primaryColor,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Container to hold your graph
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text("Graph history will be displayed here."),
            ),
          ),
        ),
      ],
    );
  }
}
