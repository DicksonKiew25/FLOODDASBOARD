import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dropdownbutton.dart';
import 'sidewidgetclient.dart';
import 'animatedbackground.dart';
import 'timefloodingdetection.dart';
import 'locationhistory.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);

class MonitorScreenclient extends StatefulWidget {
  const MonitorScreenclient({super.key});

  @override
  State<MonitorScreenclient> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreenclient> {
  late GoogleMapController _mapController;

  final LatLng _defaultCenter = const LatLng(3.1390, 101.6869);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

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

      // ✅ Print the entire decoded JSON
      print('Decoded JSON:');
      print(jsonEncode(drains)); // Pretty-print as a JSON string

      Set<Marker> markers = {};
      Set<Polyline> polylines = {};
      Set<Circle> circles = {};
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

        if (id == "drain_014" || id == "drain_045") {
          circles.add(
            Circle(
              circleId: CircleId('circle_$id'),
              center: LatLng(lat, lng),
              radius: 500,
              fillColor: const Color.fromARGB(255, 243, 33, 33).withOpacity(0.3),
              strokeColor: Colors.transparent,
              strokeWidth: 0,
            ),
          );
        }

        if (id == "drain_015" || id == "drain_025") {
          circles.add(
            Circle(
              circleId: CircleId('circle_$id'),
              center: LatLng(lat, lng),
              radius: 500,
              fillColor: const Color.fromARGB(255, 243, 194, 33).withOpacity(0.3),
              strokeColor: Colors.transparent,
              strokeWidth: 0,
            ),
          );
        }

        final List<dynamic> connections = data['connected_to'] ?? [];
        for (var connectedId in connections) {
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
        _circles.clear();
        _circles.addAll(circles);
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
      drawer: const AppDrawerclient(currentScreen: 'Monitor'),
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
              // TOP PART: 60%
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
                                  circles: _circles,
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
              SizedBox(height: spacing),
              // BOTTOM PART: 40%
              Expanded(
                flex: 4,
                child: Column(
                  children: [
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
