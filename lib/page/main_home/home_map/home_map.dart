// import 'package:flutter/material.dart';

// class HomeMap extends StatelessWidget {
//   final List<Map<String, dynamic>> hospitals = [
//     {
//       "name": "Da Nang Hospital",
//       "address": "124 Hai Phong Street, Thach Thang Ward, Da Nang",
//       "schedule": "7:15 AM - 6:30 PM",
//       "distance": "2.5 Km",
//       "rating": 3,
//     },
//     {
//       "name": "Da Nang Hospital C",
//       "address": "122 Hai Phong Street, Thach Thang Ward, Da Nang",
//       "schedule": "9:00 AM - 8:30 PM",
//       "distance": "5 Km",
//       "rating": 2,
//     },
//     {
//       "name": "Da Nang Obstetrics And Pediatrics Hospital",
//       "address": "402 Le Van Hien Street, Khue My Ward, Da Nang",
//       "schedule": "9:00 AM - 8:30 PM",
//       "distance": "5 Km",
//       "rating": 4,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Hospitals List")),
//       body: ListView.builder(
//         itemCount: hospitals.length,
//         itemBuilder: (context, index) {
//           final hospital = hospitals[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               leading: Icon(Icons.local_hospital, color: Colors.blue),
//               title: Text(
//                 hospital["name"],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(hospital["address"]),
//                   Text("Hours: ${hospital["schedule"]}"),
//                   Row(
//                     children: List.generate(5, (i) {
//                       return Icon(
//                         i < hospital["rating"] ? Icons.star : Icons.star_border,
//                         color: Colors.orange,
//                         size: 16,
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//               trailing: Text(hospital["distance"]),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:assistantstroke/page/main_home/home_map/map.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class HomeMap extends StatelessWidget {
//   final List<Map<String, dynamic>> hospitals = [
//     {
//       "name": "Da Nang Hospital",
//       "address": "124 Hai Phong Street, Thach Thang Ward, Da Nang",
//       "schedule": "7:15 AM - 6:30 PM",
//       "distance": "2.5 Km",
//       "rating": 3,
//       "location": LatLng(16.0718, 108.2150), // Tọa độ bệnh viện
//     },
//     {
//       "name": "Da Nang Hospital C",
//       "address": "122 Hai Phong Street, Thach Thang Ward, Da Nang",
//       "schedule": "9:00 AM - 8:30 PM",
//       "distance": "5 Km",
//       "rating": 2,
//       "location": LatLng(16.0725, 108.2145),
//     },
//     {
//       "name": "Da Nang Obstetrics And Pediatrics Hospital",
//       "address": "402 Le Van Hien Street, Khue My Ward, Da Nang",
//       "schedule": "9:00 AM - 8:30 PM",
//       "distance": "5 Km",
//       "rating": 4,
//       "location": LatLng(16.0503, 108.2500),
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Hospitals List")),
//       body: Column(
//         children: [
//           // Bản đồ hiển thị các bệnh viện
//           Expanded(
//             flex: 2,
//             child: FlutterMap(
//               options: MapOptions(
//                 center: LatLng(16.0718, 108.2150), // Tọa độ trung tâm Đà Nẵng
//                 zoom: 13.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers:
//                       hospitals.map((hospital) {
//                         return Marker(
//                           width: 40.0,
//                           height: 40.0,
//                           point: hospital["location"],
//                           child: Icon(
//                             Icons.location_on,
//                             color: Colors.red,
//                             size: 30,
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ],
//             ),
//           ),

//           // Danh sách bệnh viện
//           Expanded(
//             flex: 3,
//             child: ListView.builder(
//               itemCount: hospitals.length,
//               itemBuilder: (context, index) {
//                 final hospital = hospitals[index];
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     leading: Icon(Icons.local_hospital, color: Colors.blue),
//                     title: Text(
//                       hospital["name"],
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(hospital["address"]),
//                         Text("Hours: ${hospital["schedule"]}"),
//                         Row(
//                           children: List.generate(5, (i) {
//                             return Icon(
//                               i < hospital["rating"]
//                                   ? Icons.star
//                                   : Icons.star_border,
//                               color: Colors.orange,
//                               size: 16,
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                     trailing: Text(hospital["distance"]),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HospitalMapScreen(hospital),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'location_service.dart';
// import 'hospital_service.dart';

// class HomeMap extends StatefulWidget {
//   @override
//   _HomeMapState createState() => _HomeMapState();
// }

// class _HomeMapState extends State<HomeMap> {
//   List<Map<String, dynamic>> hospitals = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAndDisplayHospitals();
//   }

//   Future<void> fetchAndDisplayHospitals() async {
//     try {
//       Position userLocation = await LocationService.getUserLocation();
//       List<Map<String, dynamic>> hospitalList =
//           await HospitalService.getNearbyHospitals(
//             userLocation.latitude,
//             userLocation.longitude,
//           );

//       for (var hospital in hospitalList) {
//         double distance = HospitalService.calculateDistance(
//           userLocation.latitude,
//           userLocation.longitude,
//           hospital["lat"],
//           hospital["lon"],
//         );

//         hospital["distance"] = "${distance.toStringAsFixed(2)} Km";
//       }

//       hospitalList.sort(
//         (a, b) => double.parse(
//           a["distance"].split(" ")[0],
//         ).compareTo(double.parse(b["distance"].split(" ")[0])),
//       );

//       setState(() {
//         hospitals = hospitalList;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Lỗi: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Bệnh viện gần nhất")),
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                 itemCount: hospitals.length,
//                 itemBuilder: (context, index) {
//                   final hospital = hospitals[index];
//                   return ListTile(
//                     title: Text(hospital["name"]),
//                     subtitle: Text("Khoảng cách: ${hospital["distance"]}"),
//                     trailing: Icon(Icons.local_hospital, color: Colors.red),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'package:assistantstroke/page/main_home/home_map/map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import 'hospital_service.dart';

class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  List<Map<String, dynamic>> hospitals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayHospitals();
  }

  Future<void> fetchAndDisplayHospitals() async {
    try {
      Position userLocation = await LocationService.getUserLocation();
      print(
        "📍 Vị trí hiện tại: ${userLocation.latitude}, ${userLocation.longitude}",
      );

      List<Map<String, dynamic>> hospitalList =
          await HospitalService.getNearbyHospitals(
            userLocation.latitude,
            userLocation.longitude,
          );

      for (var hospital in hospitalList) {
        double distance = HospitalService.calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          hospital["lat"],
          hospital["lon"],
        );

        hospital["distance"] = "${distance.toStringAsFixed(2)} Km";
      }

      hospitalList.sort(
        (a, b) => double.parse(
          a["distance"].split(" ")[0],
        ).compareTo(double.parse(b["distance"].split(" ")[0])),
      );

      setState(() {
        hospitals = hospitalList;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bệnh viện gần nhất")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = hospitals[index];
                  return ListTile(
                    title: Text(hospital["name"]),
                    subtitle: Text("Khoảng cách: ${hospital["distance"]}"),
                    trailing: Icon(Icons.local_hospital, color: Colors.red),
                    onTap: () {
                      // Chuyển đến màn hình bản đồ khi nhấn vào bệnh viện
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  HospitalMapScreen(hospital: hospital),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
