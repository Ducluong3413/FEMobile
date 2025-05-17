import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HospitalMapScreen extends StatefulWidget {
  final Map<String, dynamic> hospital;

  const HospitalMapScreen({Key? key, required this.hospital}) : super(key: key);

  @override
  _HospitalMapScreenState createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  LatLng? currentLocation;
  List<LatLng> routePoints = [];
  List<Map<String, dynamic>> steps = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
      _trackUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      _getRoute();
    }
  }

  void _trackUserLocation() {
    Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) {
      if (mounted) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
        _getRoute();
      }
    });
  }

  Future<void> _getRoute() async {
    if (currentLocation == null) return;

    final start = "${currentLocation!.longitude},${currentLocation!.latitude}";
    final end = "${widget.hospital["lon"]},${widget.hospital["lat"]}";
    final url = "https://router.project-osrm.org/route/v1/driving/$start;$end?overview=full&geometries=geojson&steps=true";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["routes"].isEmpty) return;

        final List coordinates = data["routes"][0]["geometry"]["coordinates"];
        final List<dynamic>? stepsData = data["routes"][0]["legs"][0]["steps"];

        if (mounted) {
          setState(() {
            routePoints = coordinates.map<LatLng>((coord) => LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble())).toList();
            steps = stepsData?.map((step) {
              String direction = _parseDirection(step["maneuver"]?["modifier"], step["maneuver"]?["type"]);
              return {
                "distance": step["distance"] ?? 0,
                "instruction": direction,
              };
            }).toList() ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Lỗi khi tải tuyến đường: $e");
    }
  }

  String _parseDirection(String? modifier, String? type) {
    if (modifier == null || type == null) return "Tiếp tục đi thẳng";

    switch (type) {
      case "turn":
        if (modifier == "left") return "Rẽ trái";
        if (modifier == "right") return "Rẽ phải";
        if (modifier == "uturn") return "Quay đầu";
        break;
      default:
        return "Tiếp tục đi thẳng";
    }

    return "Tiếp tục đi thẳng";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bản đồ bệnh viện")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation ?? LatLng(widget.hospital["lat"], widget.hospital["lon"]),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'tuvo120703@gmail.com',
                ),
                if (currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation!,
                        child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                      ),
                    ],
                  ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blueAccent,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(widget.hospital["lat"], widget.hospital["lon"]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_hospital, color: Colors.redAccent, size: 22),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: steps.map((step) => ListTile(
                  leading: Icon(Icons.directions, color: Colors.blue),
                  title: Text(step["instruction"]),
                  subtitle: Text("${step["distance"]} m"),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}