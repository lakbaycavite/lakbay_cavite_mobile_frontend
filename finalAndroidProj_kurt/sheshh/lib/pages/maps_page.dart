import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'buttons/maps_POI_model.dart';
import 'package:http/http.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final loc.Location _locationController = loc.Location();
  bool _isLoading = false;
  final gmap.LatLng _pImusCity = const gmap.LatLng(14.4064, 120.9405);
  gmap.LatLng? _currentP;
  gmap.LatLng? _destinationP;
  gmap.LatLng? _startP;
  gmap.LatLng? _endP;
  Set<Marker> _markers={};



  List<gmap.LatLng> polygonPoints= const[gmap.LatLng(14.354700, 120.920124),
    gmap.LatLng(14.357522, 120.934447),
    gmap.LatLng(14.360697, 120.934083),
    gmap.LatLng(14.359239, 120.975317),
    gmap.LatLng(14.364601, 120.972494),
    gmap.LatLng(14.364961, 120.976840),
    gmap.LatLng(14.372520, 120.980177),
    gmap.LatLng(14.375087, 120.978940),
    gmap.LatLng(14.375515, 120.977173),
    gmap.LatLng(14.377826, 120.976113),
    gmap.LatLng(14.378596, 120.976555),
    gmap.LatLng(14.380479, 120.975583),
    gmap.LatLng(14.382402, 120.973411),
    gmap.LatLng(14.392236, 120.972292),
    gmap.LatLng(14.396111, 120.968836),
    gmap.LatLng(14.403246, 120.965062),
    gmap.LatLng(14.403675, 120.962825),
    gmap.LatLng(14.404302, 120.960286),
    gmap.LatLng(14.406865, 120.958664),
    gmap.LatLng(14.408798, 120.959399),
    gmap.LatLng(14.410222, 120.958979),
    gmap.LatLng(14.413288, 120.955532),
    gmap.LatLng(14.415845, 120.955392),
    gmap.LatLng(14.416562, 120.954630),
    gmap.LatLng(14.417123, 120.951701),
    gmap.LatLng(14.417767, 120.950940),
    gmap.LatLng(14.421134, 120.948847),
    gmap.LatLng(14.421591, 120.947442),
    gmap.LatLng(14.423388, 120.946981),
    gmap.LatLng(14.429467, 120.947624),
    gmap.LatLng(14.431567, 120.948543),
    gmap.LatLng(14.432605, 120.948569),
    gmap.LatLng(14.433396, 120.946680),
    gmap.LatLng(14.431394, 120.939531),
    gmap.LatLng(14.436298, 120.936270),
    gmap.LatLng(14.437379, 120.936227),
    gmap.LatLng(14.439569, 120.935542),
    gmap.LatLng(14.440375, 120.934692),
    gmap.LatLng(14.442746, 120.933398),
    gmap.LatLng(14.443015, 120.932839),
    gmap.LatLng(14.442980, 120.932512),
    gmap.LatLng(14.442462, 120.931725),
    gmap.LatLng(14.442670, 120.931107),
    gmap.LatLng(14.443327, 120.931059),
    gmap.LatLng(14.444006, 120.931027),
    gmap.LatLng(14.444834, 120.931270),
    gmap.LatLng(14.445514, 120.931232),
    gmap.LatLng(14.446391, 120.930555),
    gmap.LatLng(14.446245, 120.922804),
    gmap.LatLng(14.445546, 120.919971),
    gmap.LatLng(14.444667, 120.917408),
    gmap.LatLng(14.443763, 120.915766),
    gmap.LatLng(14.443576, 120.915423),
    gmap.LatLng(14.443795, 120.914554),
    gmap.LatLng(14.443576, 120.913695),
    gmap.LatLng(14.443047, 120.913170),
    gmap.LatLng(14.441606, 120.910575),
    gmap.LatLng(14.441447, 120.910982),
    gmap.LatLng(14.440565, 120.910587),
    gmap.LatLng(14.440290, 120.911452),
    gmap.LatLng(14.440055, 120.911599),
    gmap.LatLng(14.439709, 120.911178),
    gmap.LatLng(14.439328, 120.910956),
    gmap.LatLng(14.439040, 120.911100),
    gmap.LatLng(14.439144, 120.911669),
    gmap.LatLng(14.438987, 120.911732),
    gmap.LatLng(14.438472, 120.911506),
    gmap.LatLng(14.438236, 120.911750),
    gmap.LatLng(14.438026, 120.911984),
    gmap.LatLng(14.437450, 120.912138),
    gmap.LatLng(14.437135, 120.912580),
    gmap.LatLng(14.436681, 120.912670),
    gmap.LatLng(14.436593, 120.912977),
    gmap.LatLng(14.436174, 120.913184),
    gmap.LatLng(14.435973, 120.913572),
    gmap.LatLng(14.435289, 120.914199),
    gmap.LatLng(14.435048, 120.914046),
    gmap.LatLng(14.434931, 120.914116),
    gmap.LatLng(14.434984, 120.914341),
    gmap.LatLng(14.434678, 120.914702),
    gmap.LatLng(14.434390, 120.914585),
    gmap.LatLng(14.433880, 120.914992),
    gmap.LatLng(14.433435, 120.915145),
    gmap.LatLng(14.425605, 120.914928),
    gmap.LatLng(14.422672, 120.915178),
    gmap.LatLng(14.421472, 120.915570),
    gmap.LatLng(14.418849, 120.915318),
    gmap.LatLng(14.413840, 120.918300),
    gmap.LatLng(14.409183, 120.898874),
    gmap.LatLng(14.410680, 120.897321),
    gmap.LatLng(14.409017, 120.892944),
    gmap.LatLng(14.406925, 120.895627),
    gmap.LatLng(14.404711, 120.897139),
    gmap.LatLng(14.402944, 120.897461),
    gmap.LatLng(14.402342, 120.897998),
    gmap.LatLng(14.401739, 120.900101),
    gmap.LatLng(14.400104, 120.901298),
    gmap.LatLng(14.398181, 120.901623),
    gmap.LatLng(14.398111, 120.902453),
    gmap.LatLng(14.397762, 120.902593),
    gmap.LatLng(14.397034, 120.902199),
    gmap.LatLng(14.396006, 120.902503),
    gmap.LatLng(14.395124, 120.903322),
    gmap.LatLng(14.394507, 120.904733),
    gmap.LatLng(14.393360, 120.905871),
    gmap.LatLng(14.392331, 120.906205),
    gmap.LatLng(14.390142, 120.905841),
    gmap.LatLng(14.389833, 120.905446),
    gmap.LatLng(14.388907, 120.906023),
    gmap.LatLng(14.388246, 120.906068),
    gmap.LatLng(14.387584, 120.905461),
    gmap.LatLng(14.387157, 120.905423),
    gmap.LatLng(14.386195, 120.906272),
    gmap.LatLng(14.384688, 120.908161),
    gmap.LatLng(14.384497, 120.909352),
    gmap.LatLng(14.384181, 120.909663),
    gmap.LatLng(14.383048, 120.909714),
    gmap.LatLng(14.380898, 120.911374),
    gmap.LatLng(14.378451, 120.912456),
    gmap.LatLng(14.376528, 120.913990),
    gmap.LatLng(14.372336, 120.913355),
    gmap.LatLng(14.371323, 120.912615),
    gmap.LatLng(14.369963, 120.913661),
    gmap.LatLng(14.370183, 120.914617),
    gmap.LatLng(14.369641, 120.914779),
    gmap.LatLng(14.361583, 120.915699),
    gmap.LatLng(14.360185, 120.915681),
    gmap.LatLng(14.359521, 120.916457),
    gmap.LatLng(14.359870, 120.918315),
    gmap.LatLng(14.359625, 120.918911),
    gmap.LatLng(14.359084, 120.919380),
    gmap.LatLng(14.357823, 120.919582),
    gmap.LatLng(14.356971, 120.919357),
    gmap.LatLng(14.356337, 120.919819),
    gmap.LatLng(14.355796, 120.920033),

  ];

  Map<gmap.PolylineId, gmap.Polyline> polylines = {};
  String _distanceText = "Distance: ";
  final Completer<gmap.GoogleMapController> _mapController = Completer<gmap.GoogleMapController>();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startingPointController = TextEditingController();



  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final loc.LocationData currentLocation = await _locationController.getLocation();
      _currentP = gmap.LatLng(currentLocation.latitude!, currentLocation.longitude!);

      // Update the starting point text field with the current location address
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      if (placemarks.isNotEmpty) {
        _startingPointController.text = '${placemarks[0].name}, ${placemarks[0].locality}';
      }

      await _fetchNearbyPlaces();

      // Check if you've arrived at the destination
      _checkIfArrived();

      // Optionally, set this to periodically check the location
      Timer.periodic(const Duration(seconds: 5), (timer) {
        _getCurrentLocation(); // Re-check location every 5 seconds
      });
    } catch (e) {
      print("Could not get current location: $e");
    }
  }


  Future<void> _calculateRoute() async {
    // Get location from address
    List<geo.Location> startPlacemark = await geo.locationFromAddress(_startingPointController.text);
    List<geo.Location> destinationPlacemark = await geo.locationFromAddress(_destinationController.text);

    if (startPlacemark.isNotEmpty && destinationPlacemark.isNotEmpty) {
      _startP = gmap.LatLng(startPlacemark[0].latitude, startPlacemark[0].longitude);
      _destinationP = gmap.LatLng(destinationPlacemark[0].latitude, destinationPlacemark[0].longitude);
      
      //check if both points are within ImusCity
      if (_isPointInPolygon(_startP!, polygonPoints) && _isPointInPolygon(_destinationP!, polygonPoints)){
        List<gmap.LatLng> routePoints = await _getRoutePoints(_startP!, _destinationP!);
        _drawPolyline(routePoints);

        // Add markers for start and destination
        _addMarkers(_startP!, _destinationP!);

        // Move camera to start point
        final gmap.GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          gmap.CameraUpdate.newLatLngZoom(_startP!, 12.0),
        );
      } else{
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Color(0xFF035594),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: const Text (
                  'Invalid Location',
                style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),

              ),
              content: const Text(
                  'Both the start and destination points must be within Imus City',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              actions: [
                TextButton(
                    onPressed: ()=> Navigator.pop(context)
                    , child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ))
              ],
            )
        );
      }

    }
  }

  Future<List<gmap.LatLng>> _getRoutePoints(gmap.LatLng start, gmap.LatLng end) async {
    const String googleApiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Replace with your API Key
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> routes = data['routes'];

      if (routes.isNotEmpty) {
        List<gmap.LatLng> points = [];
        final List<dynamic> legs = routes[0]['legs'];
        if (legs.isNotEmpty) {
          final List<dynamic> steps = legs[0]['steps'];
          for (var step in steps) {
            // Decode polyline
            String polyline = step['polyline']['points'];
            points.addAll(_decodePoly(polyline));
          }
        }
        return points;
      }
    }
    return []; // Return an empty list if the request failed
  }

  void _drawPolyline(List<gmap.LatLng> points) {
    final gmap.PolylineId polylineId = const gmap.PolylineId('polyline');
    final gmap.Polyline polyline = gmap.Polyline(
      polylineId: polylineId,
      color: Colors.blue,
      points: points,
      width: 5,
    );
    setState(() {
      polylines[polylineId] = polyline;

      // Calculate distance between start and end
      double totalDistance = 0.0;
      for (int i = 0; i < points.length - 1; i++) {
        totalDistance += _calculateDistance(points[i], points[i + 1]);
      }
      _distanceText = "Distance: ${totalDistance.toStringAsFixed(2)} meters";
    });
  }

  double _calculateDistance(gmap.LatLng point1, gmap.LatLng point2) {
    final double lat1 = point1.latitude;
    final double lon1 = point1.longitude;
    final double lat2 = point2.latitude;
    final double lon2 = point2.longitude;

    const double earthRadius = 6371000; // meters
    double dLat = (lat2 - lat1) * (3.14159 / 180);
    double dLon = (lon2 - lon1) * (3.14159 / 180);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(lat1 * (3.14159 / 180)) * cos(lat2 * (3.14159 / 180)) * (sin(dLon / 2) * sin(dLon / 2)));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  List<gmap.LatLng> _decodePoly(String poly) {
    List<gmap.LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result >> 1) ^ -(result & 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result >> 1) ^ -(result & 1));
      lng += dlng;

      points.add(gmap.LatLng((lat / 1E5), (lng / 1E5)));
    }
    return points;
  }



  void _addMarkers(gmap.LatLng start, gmap.LatLng end) {
    setState(() {
      _markers.add(
        gmap.Marker(
          markerId: const gmap.MarkerId('start_marker'),
          position: start,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
        )
      );

      _markers.add(
        gmap.Marker(
          markerId: const gmap.MarkerId('end_marker'),
          position: end,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )
      );
    });
  }
  Future<void> _getRouteSteps() async {
    if (_currentP == null || _destinationP == null) return;

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentP!.latitude},${_currentP!.longitude}&destination=${_destinationP!.latitude},${_destinationP!.longitude}&key=AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Replace with your API key
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Handle the polyline points here
      // You can store the route information if needed
    } else {
      throw Exception('Failed to load directions');
    }
  }

  void _startNavigation() async {
    if (_currentP == null || _destinationP == null) return;

    final String googleMapUrl = 'https://www.google.com/maps/dir/?api=1&origin=${_currentP!.latitude},${_currentP!.longitude}&destination=${_destinationP!.latitude},${_destinationP!.longitude}&travelmode=driving';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch $googleMapUrl';
    }
  }

  Future<List<String>> getDirections(gmap.LatLng start, gmap.LatLng destination) async {
    final apiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Replace with your Google Directions API key
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> steps = [];

      if (data['status'] == 'OK') {
        for (var step in data['routes'][0]['legs'][0]['steps']) {
          steps.add(step['html_instructions']);
        }
      }
      return steps;
    } else {
      throw Exception('Failed to load directions');
    }
  }

  IconData _getTurnIcon(String instruction) {
    if (instruction.contains('left')) {
      return Icons.arrow_left;
    } else if (instruction.contains('right')) {
      return Icons.arrow_right;
    } else {
      return Icons.arrow_forward; // For straight directions
    }
  }

  Widget _buildDirectionStep(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            _getTurnIcon(instruction),
            color: Colors.blue,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              instruction.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  void _checkIfArrived() {
    if (_currentP != null && _destinationP != null) {
      // Calculate the distance between the current location and the destination
      double distance = _calculateDistance(_currentP!, _destinationP!);

      // Set a threshold for arrival, for example, 10 meters
      const double arrivalThreshold = 100.0;

      if (distance <= arrivalThreshold) {
        // Notify user that they have arrived
        _showArrivalNotification();
      }
    }
  }

  void _showArrivalNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("You have arrived!"),
        content: const Text("You have reached your destination."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  //point-in-polygon algorithm to determine the imus border
  bool _isPointInPolygon(gmap.LatLng point, List<gmap.LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      if (_rayCastIntersect(point, polygon[j], polygon[j + 1])) {
        intersectCount++;
      }
    }
    return ((intersectCount % 2) == 1); // Odd number of intersections means inside
  }

  bool _rayCastIntersect(gmap.LatLng point, gmap.LatLng vertA, gmap.LatLng vertB) {
    double px = point.latitude;
    double py = point.longitude;
    double ax = vertA.latitude;
    double ay = vertA.longitude;
    double bx = vertB.latitude;
    double by = vertB.longitude;

    if ((ay > py) != (by > py) &&
        (px < (bx - ax) * (py - ay) / (by - ay) + ax)) {
      return true;
    }
    return false;
  }

  Future<List<Place>> fetchNearbyPlaces(double lat, double lng) async {
    final String apiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Replace with your actual API key
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=restaurant&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((place) => Place.fromJson(place))
          .toList();
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  Future<void>_fetchAndDisplayNearbyPlaces()async {
    if (_currentP != null) {
      try {
        List<Place> places = await fetchNearbyPlaces(
            _currentP!.latitude, _currentP!.longitude);
        setState(() {
          _markers.clear();
          for (var place in places) {
            _markers.add(
                Marker(
                  markerId: MarkerId(place.name),
                  position: LatLng(place.lat, place.lng),
                  infoWindow: InfoWindow(title: place.name),
                )
            );
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load nearby places: $e')),
        );
      }
    }
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentP == null) return; // Ensure current position is available

    const String googleApiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE'; // Replace with your API Key
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentP!.latitude},${_currentP!.longitude}&radius=1500&type=restaurant&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      // Clear previous markers
      _markers.clear();

      // Add markers for each place
      for (var place in results) {
        double lat = place['geometry']['location']['lat'];
        double lng = place['geometry']['location']['lng'];
        String name = place['name'];

        _addMarker(gmap.LatLng(lat, lng), name);
      }
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  void _addMarker(gmap.LatLng position, String name) {
    setState(() {
      _markers.add(
        gmap.Marker(
          markerId: gmap.MarkerId(name),
          position: position,
          infoWindow: gmap.InfoWindow(title: name),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.map, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text('MAPS', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
          ],
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4286f4), Color(0xFF035594)],
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
          Positioned.fill(
            child: gmap.GoogleMap(

              initialCameraPosition: gmap.CameraPosition(
                target: _pImusCity,
                zoom: 18,
              ),
              polygons: {
                gmap.Polygon(
                  polygonId: const gmap.PolygonId("border"),
                  points: polygonPoints,
                  strokeColor: Colors.blue,
                  strokeWidth: 2,
                  fillColor: Colors.blue.withOpacity(0.15),
                ),
              },
              onMapCreated: (gmap.GoogleMapController controller) {
                _mapController.complete(controller);
              },
              myLocationEnabled: true,
              trafficEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: true,
              markers: _markers,
              polylines: Set<gmap.Polyline>.of(polylines.values),
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
              children: [
                Column(
                  children: [
                    TextField(
                      controller: _startingPointController,
                      decoration: InputDecoration(
                        labelText: "Starting Point",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _getCurrentLocation,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          borderSide: BorderSide.none, // No visible border
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        labelText: "Destination",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)), // Rounded corners
                          borderSide: BorderSide.none, // No visible border
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF035594), // Background color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16), // Padding around the container
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF32CD32), // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Button padding
                              elevation: 5, // Elevation for shadow effect
                            ),
                            onPressed: _calculateRoute,
                            child: const Text(
                              "Get Route",
                              style: TextStyle(
                                fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white,
                                // Bold text
                              ),

                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(
                            _distanceText,
                            style: TextStyle(
                              fontSize: 16, // Font size for distance text
                              fontFamily: 'Poppins',
                              color: Colors.white, // Color for distance text
                              fontWeight: FontWeight.w600, // Medium weight
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _startNavigation, // Start the navigation
                            child: const Text('Go'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_currentP != null && _destinationP != null) {
                                List<String> directions = await getDirections(_currentP!, _destinationP!);
                                // Show the directions in a dialog, bottom sheet, or another screen
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Directions'),
                                    content: Container(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: directions.length,
                                        itemBuilder: (context, index) {
                                          return _buildDirectionStep(directions[index]);
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text('Route Steps'),
                          )

                        ],
                      ),
                    ),
                  ],
                )

              ],
            ),
          )


        ],
      ),
    );
  }
}
