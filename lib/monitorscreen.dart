import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dropdownbutton.dart';
import 'sidewidget.dart';
import 'animatedbackground.dart';
import 'timefloodingdetection.dart';
import 'locationhistory.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late GoogleMapController _mapController;

  final LatLng _defaultCenter = const LatLng(3.1390, 101.6869);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDrainTopology();
  }

  Future<void> _loadDrainTopology() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/drain_topology.json');
      final Map<String, dynamic> drains = jsonDecode(jsonString);

      Set<Marker> markers = {};
      Set<Polyline> polylines = {};
      int polylineIdCounter = 1;

      drains.forEach((id, data) {
        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lon'] as num).toDouble();

        markers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: id),
          ),
        );

        final List<dynamic> connections = data['connected_to'] ?? [];
        for (var connectedId in connections) {
          // Check if connected drain exists in map to avoid errors
          if (drains.containsKey(connectedId)) {
            final double connectedLat =
                (drains[connectedId]['lat'] as num).toDouble();
            final double connectedLng =
                (drains[connectedId]['lon'] as num).toDouble();

            polylines.add(
              Polyline(
                polylineId: PolylineId('polyline_$polylineIdCounter'),
                points: [
                  LatLng(lat, lng),
                  LatLng(connectedLat, connectedLng),
                ],
                color: Colors.blueAccent,
                width: 3,
              ),
            );
            polylineIdCounter++;
          }
        }
      });

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
        _polylines.clear();
        _polylines.addAll(polylines);
        _loading = false;
      });
    } catch (e) {
      print('Error loading drain topology JSON: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = 20.0;

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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _loading
                              ? const Center(child: CircularProgressIndicator())
                              : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _markers.isNotEmpty
                                        ? _markers.first.position
                                        : _defaultCenter,
                                    zoom: 13,
                                  ),
                                  markers: _markers,
                                  polylines: _polylines,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController = controller;
                                  },
                                ),
                        ),
                      ),
                    ),

                    // Right Container - 30%
                    Expanded(
                      flex: 3,
                      child: const DrainStatusSection(),
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
                    // Top part of bottom section (30%)
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.4) * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: spacing / 2),
                      child: const DrainDropdown(),
                    ),

                    // Bottom part of bottom section (70%)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const LocationHistoryGraph(),
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
