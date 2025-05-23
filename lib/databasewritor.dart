import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'databaseextractor.dart';

class FlowrateWidget extends StatelessWidget {
  const FlowrateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final flowrate = context.watch<DrainDataProvider>().flowRate;
    return Text(
      flowrate != null ? "${flowrate.toStringAsFixed(2)} L/s" : "Loading...",
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class WaterLevelWidget extends StatelessWidget {
  const WaterLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final level = context.watch<DrainDataProvider>().waterLevel;
    return Text(
      level != null ? "${level.toStringAsFixed(2)} cm" : "Loading...",
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
