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
        // Show popup with graph when Bukit Bintang is selected
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
    } else {
      debugPrint("Unsupported location or null value selected");
      setState(() {
        selectedLocation = value;
      });
    }
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
          // Title above dropdown
          Text(
            'Flood History Location Data',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 9),

          // Dropdown expanded full width of container
          SizedBox(
  width: double.infinity,
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
              child: Text(
                location,
                style: const TextStyle(fontSize: 13), // slightly smaller font
              ),
            ))
        .toList(),
    onChanged: _onLocationChange,
    decoration: InputDecoration(
      filled: true,
      fillColor: dropdownColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // less vertical padding
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    dropdownColor: dropdownColor,
    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87), // match font size
    iconEnabledColor: primaryColor,
  ),
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

  // Flood risk by month for 2025
  final Map<String, String> floodRiskByMonth = const {
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
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title and close button
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

            // Legend
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

            // Graph area
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                final totalHeight = constraints.maxHeight;
                const double xAxisHeight = 30;
                const double topMargin = 10;

                final chartHeight = totalHeight - xAxisHeight - topMargin;

                final barWidth = chartWidth / (months.length * 2);

                final yLabels = ['Flood', 'High Risk', 'No Flood'];
                final yLabelPositions = [0.1, 0.5, 0.9];

                return Stack(
                  children: [
                    // Y axis labels and horizontal grid lines
                    Positioned.fill(
                      left: 40,
                      top: topMargin,
                      child: CustomPaint(
                        painter: _GridPainter(
                          yLabelPositions: yLabelPositions,
                          yLabels: yLabels,
                          chartHeight: chartHeight,
                        ),
                      ),
                    ),

                    // Bars and X axis labels
                    Positioned(
                      left: 40,
                      bottom: xAxisHeight,
                      right: 0,
                      height: chartHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: months.map((month) {
                          final risk = floodRiskByMonth[month]!;
                          Color color = riskColor(risk);
                          double heightFactor;
                          switch (risk) {
                            case 'No Flood':
                              heightFactor = 0.2;
                              break;
                            case 'High Risk':
                              heightFactor = 0.55;
                              break;
                            case 'Flood':
                              heightFactor = 0.9;
                              break;
                            default:
                              heightFactor = 0.1;
                          }
                          final barHeight = chartHeight * heightFactor;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: barWidth,
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                month,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    // Y axis line
                    Positioned(
                      left: 40,
                      top: topMargin,
                      bottom: xAxisHeight,
                      child: Container(
                        width: 1,
                        color: Colors.black54,
                      ),
                    ),

                    // X axis line
                    Positioned(
                      left: 40,
                      bottom: xAxisHeight,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 18, height: 12, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final List<double> yLabelPositions;
  final List<String> yLabels;
  final double chartHeight;

  _GridPainter({
    required this.yLabelPositions,
    required this.yLabels,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < yLabels.length; i++) {
      final yPos = size.height * yLabelPositions[i];
      // Draw horizontal line
      canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), paintGrid);

      // Draw label
      textPainter.text = TextSpan(
        text: yLabels[i],
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
        ),
      );
      textPainter.layout(minWidth: 0, maxWidth: 40);
      textPainter.paint(canvas, Offset(-6 - textPainter.width, yPos - 7));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
