import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class JeepTerminal{
  final String name;
  final gmaps.LatLng location;
  final List<gmaps.LatLng> route;
  final List<String> fareMatrices;
  final List<String> landmarks;
  final String puvType;

  JeepTerminal({
    required this.name,
    required this.location,
    required this.route,
    required this.fareMatrices,
    required this.landmarks,
    required this.puvType,
  });
}

class VanTerminal {
  final String name;
  final gmaps.LatLng location;
  final List<gmaps.LatLng> route;
  final List<String> fareMatrices;
  final List<String> landmarks;
  final String puvType;

  VanTerminal({
    required this.name,
    required this.location,
    required this.route,
    required this.fareMatrices,
    required this.landmarks,
    required this.puvType,
  });
}