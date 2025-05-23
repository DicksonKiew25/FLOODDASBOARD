import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class DrainDataProvider with ChangeNotifier {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("live_data/drain_001");

  double? _flowRate;
  double? _waterLevel;

  double? get flowRate => _flowRate;
  double? get waterLevel => _waterLevel;

  DrainDataProvider() {
    _startListening();
  }

  void _startListening() {
    _ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        _flowRate = (data['flow_rate'] as num?)?.toDouble();
        _waterLevel = (data['water_level'] as num?)?.toDouble();
        notifyListeners();
      }
    });
  }
}
