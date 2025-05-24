import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

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
      'Bukit Bintang',
      'Subang',
      'Kepong',
      'Port Klang'
    ].contains(location);
  }

  void _onLocationChange(String? value) {
    if (value != null && isSupportedLocation(value)) {
      debugPrint("Selected supported location: $value");
      if (value == 'Bukit Bintang') {
        showDialog(
          context: context,
          builder: (_) => LocationHistoryGraphPopup(
            location: value,
            onClose: () {
              Navigator.of(context).pop();
              setState(() {
                selectedLocation = null;
              });
            },
          ),
        );
      } else {
        setState(() {
          selectedLocation = value;
        });
      }
    }
  }

  Future<void> _generateReport() async {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }

    final pdf = pw.Document();

    final Map<String, Map<String, String>> floodData = {
      'Bandar Botanic': {
        'Jan': 'No Flood',
        'Feb': 'No Flood',
        'Mar': 'High Risk',
        'Apr': 'No Flood',
        'May': 'No Flood',
        'Jun': 'No Flood',
        'Jul': 'No Flood',
        'Aug': 'High Risk',
        'Sep': 'Flood',
        'Oct': 'High Risk',
        'Nov': 'No Flood',
        'Dec': 'No Flood',
      },
      // Use the popup flood risk data for Bukit Bintang too
      'Bukit Bintang': LocationHistoryGraphPopup.floodRiskByMonth,
      'Subang': {
        'Jan': 'No Flood',
        'Feb': 'No Flood',
        'Mar': 'No Flood',
        'Apr': 'No Flood',
        'May': 'High Risk',
        'Jun': 'No Flood',
        'Jul': 'No Flood',
        'Aug': 'High Risk',
        'Sep': 'Flood',
        'Oct': 'Flood',
        'Nov': 'No Flood',
        'Dec': 'No Flood',
      },
      'Kepong': {
        'Jan': 'No Flood',
        'Feb': 'High Risk',
        'Mar': 'No Flood',
        'Apr': 'No Flood',
        'May': 'No Flood',
        'Jun': 'No Flood',
        'Jul': 'High Risk',
        'Aug': 'Flood',
        'Sep': 'Flood',
        'Oct': 'High Risk',
        'Nov': 'No Flood',
        'Dec': 'No Flood',
      },
      'Port Klang': {
        'Jan': 'No Flood',
        'Feb': 'No Flood',
        'Mar': 'No Flood',
        'Apr': 'High Risk',
        'May': 'High Risk',
        'Jun': 'Flood',
        'Jul': 'Flood',
        'Aug': 'High Risk',
        'Sep': 'Flood',
        'Oct': 'Flood',
        'Nov': 'No Flood',
        'Dec': 'No Flood',
      },
    };

    final floodRisk = floodData[selectedLocation!] ?? {};

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Flood History Location Data Report',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#4557F4'),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text('Location: $selectedLocation', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Month', 'Flood Risk'],
                data: floodRisk.entries.map((e) => [e.key, e.value]).toList(),
                headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#4557F4')),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFE0E5FF),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: pw.TextStyle(fontSize: 14),
                cellHeight: 20,
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Note: This report summarizes flood risk levels for each month in 2025.',
                style: pw.TextStyle(fontSize: 12, color: PdfColor.fromHex('808080')),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flood History Location Data',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                width: 180,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: DropdownButtonFormField<String>(
                    value: selectedLocation,
                    hint: const Text('Select Location'),
                    items: [
                      'Bandar Botanic',
                      'Bukit Bintang',
                      'Subang',
                      'Kepong',
                      'Port Klang'
                    ]
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: _onLocationChange,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: dropdownColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: dropdownColor,
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                    iconEnabledColor: primaryColor,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('Generate Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(fontSize: 12),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LocationHistoryGraphPopup extends StatelessWidget {
  final String location;
  final VoidCallback onClose;

  const LocationHistoryGraphPopup({
    Key? key,
    required this.location,
    required this.onClose,
  }) : super(key: key);

  static const Map<String, String> floodRiskByMonth = {
    'Jan': 'No Flood',
    'Feb': 'No Flood',
    'Mar': 'No Flood',
    'Apr': 'No Flood',
    'May': 'No Flood',
    'Jun': 'No Flood',
    'Jul': 'No Flood',
    'Aug': 'High Risk',
    'Sep': 'Flood',
    'Oct': 'High Risk',
    'Nov': 'No Flood',
    'Dec': 'No Flood',
  };

  Color riskColor(String risk) {
    switch (risk) {
      case 'No Flood':
        return Colors.green;
      case 'High Risk':
        return Colors.orange;
      case 'Flood':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.2,
        vertical: MediaQuery.of(context).size.height * 0.2,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$location Flood History 2025',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.black54,
                    onPressed: onClose,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _LegendItem(color: Colors.green, label: 'No Flood'),
                  const SizedBox(width: 12),
                  _LegendItem(color: Colors.orange, label: 'High Risk'),
                  const SizedBox(width: 12),
                  _LegendItem(color: Colors.red, label: 'Flood'),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4,
                ),
                itemBuilder: (context, index) {
                  final month = months[index];
                  final risk = floodRiskByMonth[month] ?? 'No Flood';
                  return Row(
                    children: [
                      Text(month),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: riskColor(risk),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Note: The color indicates flood risk level for each month.',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 7, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
