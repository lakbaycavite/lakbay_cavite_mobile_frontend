import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart' as gemaps;
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Use this LatLng
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'buttons/terminal_provider.dart';
import 'buttons/tricycle_terminal_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TricycleTerminalsPage extends StatefulWidget {
  const TricycleTerminalsPage({super.key});

  @override
  _TricycleTerminalsPageState createState() => _TricycleTerminalsPageState();
}

class POI {
  final String name;
  final LatLng location; // Use Google Maps LatLng

  POI(this.name, this.location);
}

class _TricycleTerminalsPageState extends State<TricycleTerminalsPage> {
  TricycleTerminal? _selectedTerminal;
  String _selectedPUVType = 'Tricycle';
  GoogleMapController? _mapController;
  late Location _location;
  LocationData? _userLocation;
  BitmapDescriptor? _customIcon;
  gemaps.Geodesy geodesy = gemaps.Geodesy();

  @override
  void initState() {
    super.initState();
    _location = Location();
    _getUserLocation();
    _setCustomMarkerIcon('tricycless.png');
  }

  Future<void> _setCustomMarkerIcon(String imagePath) async {
    try {
      _customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/$imagePath',
      );
      print('Custom icon loaded: $imagePath');
      setState(() {});
    } catch (e) {
      print('Error loading custom icon: $e');
    }
  }

  Future<void> _getUserLocation() async {
    try {
      _userLocation = await _location.getLocation();
      setState(() {});
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  void _addPOIMarkers(List<POI> pois){
    for (POI poi in pois){
      _markers.add(
        Marker(
          markerId: MarkerId(poi.name),
          position: poi.location,
          infoWindow: InfoWindow(title: poi.name),
          icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    setState(() {

    });
  }

  void _updateMapWithPOIs(TricycleTerminal terminal, List<POI> pois){
    _markers.clear();
    _addPOIMarkers(pois);
    _mapController?.animateCamera(CameraUpdate.newLatLng(terminal.location));
    setState(() {

    });
  }

  // fetch nearby poi based on the polyline generated
  Future<void> fetchNearbyPOIsNearPolyline(TricycleTerminal terminal) async {
    if (terminal.route.isEmpty) return;

    // Create a bounding box around the polyline
    double minLat = terminal.route.map((point) => point.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = terminal.route.map((point) => point.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = terminal.route.map((point) => point.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = terminal.route.map((point) => point.longitude).reduce((a, b) => a > b ? a : b);

    // Call the Places API for nearby locations within the bounding box
    String apiKey = 'AIzaSyCKt9aAIav5_zs11984koU68sGkWYSuCpE';
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${(maxLat + minLat) / 2},${(maxLng + minLng) / 2}'
        '&radius=${_calculateRadius(minLat, maxLat, minLng, maxLng)}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<POI> pois = [];
      for (var result in data['results']) {
        pois.add(POI(result['name'], LatLng(
          result['geometry']['location']['lat'],
          result['geometry']['location']['lng'],
        )));
      }
      _addPOIMarkers(pois);
      _updateMapWithPOIs(terminal, pois);
      _showBottomSheet(terminal, pois);
    } else {
      throw Exception('Failed to load POIs');
    }
  }

  double _calculateRadius(double minLat, double maxLat, double minLng, double maxLng) {
    return 1500;
  }

  @override
  Widget build(BuildContext context) {
    final terminalProvider = Provider.of<TerminalProvider>(context);

    final filteredTerminals = terminalProvider.terminals
        .where((terminal) => terminal.puvType == _selectedPUVType)
        .toList();

    return Scaffold(appBar: AppBar(
      title: const Row(
        children: [
          Icon(Icons.bike_scooter, color: Colors.white, size: 30),
          SizedBox(width: 8),
          Text('TERMINALS', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
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
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedTerminal?.location ?? const LatLng(14.405956, 120.940459),
              zoom: 14.0,
            ),
            polylines: _selectedTerminal != null
                ? _createPolylines([_selectedTerminal!])
                : {},

            markers: _markers,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: _selectedPUVType,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select PUV Type'),
                    ),
                    isExpanded: true,
                    items: <String>['Tricycle', 'Jeepney', 'Van'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(type),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newType) {
                      setState(() {
                        _selectedPUVType = newType ?? 'Tricycle';
                        _selectedTerminal = null;
                        switch (_selectedPUVType) {
                          case 'Jeepney':
                            _setCustomMarkerIcon('OGjeepney.png');
                            break;
                          case 'Van':
                            _setCustomMarkerIcon('vans.png');
                            break;
                          case 'Tricycle':
                          default:
                            _setCustomMarkerIcon('OGTricy.png');
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButton<TricycleTerminal>(
                    value: _selectedTerminal,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select Terminal'),
                    ),
                    isExpanded: true,
                    items: filteredTerminals.map((TricycleTerminal terminal) {
                      return DropdownMenuItem<TricycleTerminal>(
                        value: terminal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(terminal.name),
                        ),
                      );
                    }).toList(),
                    onChanged: (TricycleTerminal? newValue) {
                      setState(() {
                        _selectedTerminal = newValue;
                        if (newValue != null) {
                          _updateMap(newValue);
                          fetchNearbyPOIsNearPolyline(newValue);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: _centerOnUserLocation,
              backgroundColor: Colors.green,
              tooltip: 'Center on My Location',
              child: const Icon(Icons.my_location_sharp),
            ),
          ),
          if(_selectedTerminal != null)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (_userLocation != null) {
                      fetchNearbyPOIsNearPolyline(_selectedTerminal!);
                    }
                  },
                  label: const Text('Nearby Landmarks'),
                  icon: const Icon(Icons.place_outlined),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _updateMap(TricycleTerminal terminal) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(terminal.location));
  }

  Set<Marker> _createMarkers(List<TricycleTerminal> terminals) {
    return terminals.map((terminal) {
      return Marker(
        markerId: MarkerId(terminal.name),
        position: terminal.location,
        infoWindow: InfoWindow(title: terminal.name),
        icon: _customIcon ?? BitmapDescriptor.defaultMarker,
      );
    }).toSet();
  }

  Set<Polyline> _createPolylines(List<TricycleTerminal> terminals) {
    return terminals.map((terminal) {
      return Polyline(
        polylineId: PolylineId(terminal.name),
        points: terminal.route.map((location) {
          return LatLng(location.latitude, location.longitude); // Use Google Maps LatLng
        }).toList(),
        color: Colors.blue,
        width: 5,
      );
    }).toSet();
  }

  Future<void> _centerOnUserLocation() async {
    if (_userLocation != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(
        LatLng(_userLocation!.latitude!, _userLocation!.longitude!),
      ));
    }
  }

  final Set<Marker> _markers = {};
  void _centerOnPOI(LatLng location, String poiName){
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));

    //marker
    _markers.add(Marker(
      markerId: MarkerId(poiName),
      position: location,
      infoWindow: InfoWindow(title: poiName),
      icon:  _customIcon ?? BitmapDescriptor.defaultMarker,
    ));
    setState(() {

    });
  }


  void _showBottomSheet(TricycleTerminal terminal, List<POI> pois) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Make the bottom sheet background transparent to show custom design
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF035594), // Background color for the bottom sheet
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                terminal.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change text color to white for better contrast
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nearby Points of Interest:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change text color to white for better contrast
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: pois.length,
                  itemBuilder: (context, index) {
                    final poi = pois[index];
                    return ListTile(
                      leading: const Icon(Icons.place, color: Color(0xFF32CD32)), // Icon color changed to white
                      title: Text(
                        poi.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Change text color to white
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        'Coordinates: ${poi.location.latitude}, ${poi.location.longitude}',
                        style: const TextStyle(color: Colors.white70), // Subtitle color for contrast
                      ),
                      onTap: () {
                        _centerOnPOI(pois[index].location, pois[index].name);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}