import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrainStatusSection extends StatelessWidget {
  const DrainStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(flex: 7, child: DrainTable()), // Wider left widget
        SizedBox(width: 10), // Reduced spacing
        Expanded(flex: 3, child: RegionStatus()), // Slightly narrower right widget
      ],
    );
  }
}

// Left Widget - Drain Table
class DrainTable extends StatefulWidget {
  const DrainTable({super.key});

  @override
  _DrainTableState createState() => _DrainTableState();
}

class _DrainTableState extends State<DrainTable> with SingleTickerProviderStateMixin {
  final List<String> sensorTypes = const ['Ultrasonic', 'Flowmeter', 'Floatsensor'];
  final List<String> statuses = const ['Static', 'Rising', 'Overflown'];
  final List<Color> statusColors = const [Colors.green, Colors.orange, Colors.red];

  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();

    List<Map<String, dynamic>> drains = List.generate(60, (index) {
        final drainNumber = (index + 1).toString().padLeft(3, '0');
        final fullNumber = 'Drain $drainNumber';

        // Define blinking and rising drains
        final blinkingDrains = {'005', '014', '019', '032', '042', '045', '056'};
        final risingDrains = {'003', '013', '015', '025', '030', '055'};

        String status;
        int statusIndex;

        if (blinkingDrains.contains(drainNumber)) {
          status = 'Overflown';
          statusIndex = statuses.indexOf('Overflown');
        } else if (risingDrains.contains(drainNumber)) {
          status = 'Rising';
          statusIndex = statuses.indexOf('Rising');
        } else {
          status = 'Static';
          statusIndex = statuses.indexOf('Static');
        }

        final sensor = sensorTypes[random.nextInt(sensorTypes.length)];

        return {
          'number': fullNumber,
          'sensor': sensor,
          'status': status,
          'color': statusColors[statusIndex]
        };
      });


    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Status of Drains",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: drains.length,
              itemBuilder: (context, index) {
                final drain = drains[index];
                final isOverflown = drain['status'] == 'Overflown';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: AnimatedBuilder(
                    animation: _blinkController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isOverflown
                                ? Colors.red.withOpacity(_blinkController.value)
                                : Colors.grey.shade300,
                            width: isOverflown ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: child,
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(drain['number'])),
                        Expanded(flex: 3, child: Text(drain['sensor'])),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 6,
                                backgroundColor: drain['color'],
                              ),
                              const SizedBox(width: 8),
                              Text(drain['status']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// Right Widget - Region Status
class RegionStatus extends StatefulWidget {
  const RegionStatus({super.key});

  @override
  _RegionStatusState createState() => _RegionStatusState();
}

class _RegionStatusState extends State<RegionStatus> with SingleTickerProviderStateMixin {
  final List<String> regions = const ['Bukit Bintang', 'Pudu', 'Brickfields', 'Kampung ATTAP', 'Bukit Pesekutuan'];

  final Map<String, String> regionStatus = {
    'Bukit Bintang': 'No flood alert',
    'Pudu': 'No flood alert',
    'Brickfields': 'No flood alert',
    'Kampung ATTAP': 'High risk',
    'Bukit Pesekutuan': 'Flooding',
  };

  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  String _generateDateTime() {
    final now = DateTime.now();
    return DateFormat('dd MMM yyyy, hh:mm a').format(now);
  }

  String _getCountdown() {
    // Example fixed countdown for demo
    return "Flood in: 15 minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Region Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final region = regions[index];
                final status = regionStatus[region] ?? "No flood alert";

                Color borderColor;
                Widget statusContent;

                switch (status) {
                  case 'Flooding':
                    borderColor = Colors.red;
                    statusContent = const Text("Status: Flooding");
                    break;
                  case 'High risk':
                    borderColor = Colors.orange;
                    statusContent = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Updated: ${_generateDateTime()}"),
                        Text(_getCountdown()),
                      ],
                    );
                    break;
                  default:
                    borderColor = Colors.green;
                    statusContent = const Text("Status: No flood alert");
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        region,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      AnimatedBuilder(
                        animation: _blinkController,
                        builder: (context, child) {
                          final opacity = (status == 'Flooding' || status == 'High risk')
                              ? _blinkController.value
                              : 1.0;

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: borderColor.withOpacity(opacity),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: statusContent,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
