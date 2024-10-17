import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:geodesy/geodesy.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  late gmaps.GoogleMapController _mapController;
  gmaps.LatLng _currentLocation = const gmaps.LatLng(0, 0);
  final List<gmaps.Marker> _hospitalMarkers = [];
  final Set<gmaps.Polyline> _polylines = {};
  String googleMapsApiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Add your API key
  gmaps.Marker? _userLocationMarker;
  List<dynamic> _hospitals = [];
  int _selectedRadius = 5000; // Default radius

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _setMapBounds() {
    final imusBounds = gmaps.LatLngBounds(
      southwest: const gmaps.LatLng(14.3720, 120.9070),
      northeast: const gmaps.LatLng(14.4720, 120.9880),
    );
    _mapController.setLatLngBoundsForCameraTarget(imusBounds);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation =
          gmaps.LatLng(position.latitude, position.longitude);

      _userLocationMarker = gmaps.Marker(
        markerId: const gmaps.MarkerId('current_location'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const gmaps.InfoWindow(title: 'You are here'),
      );
      _hospitalMarkers.add(_userLocationMarker!);
    });

    _mapController.animateCamera(
      gmaps.CameraUpdate.newLatLng(_currentLocation),
    );

    _getHospitals();
  }

  Future<void> _getHospitals({int radius = 5000}) async {
    setState(() {
      _selectedRadius = radius;
    });

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation.latitude},${_currentLocation.longitude}&radius=$radius&type=hospital&key=$googleMapsApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> hospitals = jsonData['results'];

      setState(() {
        _hospitalMarkers.clear();
        _hospitalMarkers.add(_userLocationMarker!);
        _hospitals = hospitals; // Update the list of hospitals

        for (var hospital in hospitals) {
          final hospitalLatLng = gmaps.LatLng(
            hospital['geometry']['location']['lat'],
            hospital['geometry']['location']['lng'],
          );

          _hospitalMarkers.add(
            gmaps.Marker(
              markerId: gmaps.MarkerId(hospital['place_id']),
              position: hospitalLatLng,
              infoWindow: gmaps.InfoWindow(
                title: hospital['name'],
                snippet: hospital['vicinity'],
                onTap: () {
                  _showHospitalDetailsDialog(hospital, hospitalLatLng);
                },
              ),
            ),
          );
        }
      });
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  late bool _showMarkers = false;

  Future<void> _startNavigation(dynamic hospital) async {
    final hospitalLatLng = gmaps.LatLng(
      hospital['geometry']['location']['lat'],
      hospital['geometry']['location']['lng'],
    );

    final url = Uri.parse(
      'google.navigation:q=${hospitalLatLng.latitude},${hospitalLatLng.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _drawPolylineToHospital(gmaps.LatLng destination) async {
    setState(() {
      _polylines.clear();
    });

    final directionsUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$googleMapsApiKey',
    );

    final response = await http.get(directionsUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['routes'].isNotEmpty) {
        final points = jsonData['routes'][0]['overview_polyline']['points'];
        final List<gmaps.LatLng> polylinePoints = _decodePolyline(points);

        setState(() {
          _polylines.add(
            gmaps.Polyline(
              polylineId: gmaps.PolylineId(destination.toString()),
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<gmaps.LatLng> _decodePolyline(String encoded) {
    List<gmaps.LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(gmaps.LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _showHospitalDetailsDialog(dynamic hospital, gmaps.LatLng hospitalLatLng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF035594),  // Set background color here
          title: Text(
            hospital['name'],
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,  // Ensure the text is visible on the dark background
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Address: ${hospital['vicinity']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.white,  // Adjust text color
                ),
              ),
              Text(
                'Rating: ${hospital['rating'] ?? 'No rating'}',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: Colors.white,  // Adjust text color
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Get Directions', style: TextStyle(color: Colors.white)),  // Ensure buttons are visible
              onPressed: () async {
                Navigator.of(context).pop();
                await _drawPolylineToHospital(hospitalLatLng);
              },
            ),
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Go', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();  // Close dialog
                _startNavigation(hospital);
              },
            ),
          ],
        );
      },
    );
  }


  void _centerOnUserLocation() {
    _mapController.animateCamera(
      gmaps.CameraUpdate.newLatLng(_currentLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.local_hospital, // Use the gas icon from Material Icons
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 8), // Add space between icon and text
            Text(
              'Hospitals',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF035594), Color(0xFF4286f4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.all(1.20),
            child: SizedBox(
              width: 90,
              height: 90,
              child: Image.asset('assets/lakbay_cavite_logo.png'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (gmaps.GoogleMapController controller) {
              _mapController = controller;
              _setMapBounds();
            },
            initialCameraPosition: gmaps.CameraPosition(
              target: _currentLocation,
              zoom: 12,
            ),
            markers: _showMarkers ? _hospitalMarkers.toSet() : {},
            polylines: _polylines,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF035594), Color(0xFF4286f4)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Hospitals',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 80, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: _hospitals.length,
                        itemBuilder: (context, index) {
                          final hospital = _hospitals[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            title: Text(
                              hospital['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(hospital['vicinity']),
                            onTap: () {
                              _showHospitalDetailsDialog(
                                hospital,
                                gmaps.LatLng(
                                  hospital['geometry']['location']['lat'],
                                  hospital['geometry']['location']['lng'],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 600,
            right: 16,
            child: FloatingActionButton(
              onPressed: _centerOnUserLocation,
              backgroundColor: Color(0xFF32CD32),
              tooltip: 'Center on My Location',
              child: const Icon(Icons.my_location_sharp, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 600,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFF32CD32),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0,2),
                  )
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Colors.white),
                      onPressed: () {
                        _mapController.animateCamera(
                           gmaps.CameraUpdate.zoomIn(),
                         );
                      },
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_out, color:Colors.white),
                    onPressed: (){
                      _mapController.animateCamera(
                        gmaps.CameraUpdate.zoomOut(),
                      );
                    },
                  )
                ],
              ),
            )
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<int>(

                value: _selectedRadius,
                underline: const SizedBox(),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 500, child: Text('500 meters', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),)),
                  DropdownMenuItem(value: 1000, child: Text('1 km', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),)),
                  DropdownMenuItem(value: 5000, child: Text('5 km', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),)),
                  DropdownMenuItem(value: 10000, child: Text('10 km', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _showMarkers = true;
                    });
                    _getHospitals(radius: value);
                  }
                },
                hint: const Text('Select Radius'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on gmaps.GoogleMapController {
  void setLatLngBoundsForCameraTarget(gmaps.LatLngBounds imusBounds) {}
}
