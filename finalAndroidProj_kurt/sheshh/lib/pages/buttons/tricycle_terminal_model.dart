import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geodesy/geodesy.dart' as gemaps;
class TricycleTerminal{
  final String name;
  final gmaps.LatLng location;
  final List<gmaps.LatLng> route;
  final List<String> fareMatrices;
  final List<String> landmarks;
  final String puvType;

  TricycleTerminal({
    required this.name,
    required this.location,
    required this.route,
    required this.fareMatrices,
    required this.landmarks,
    required this.puvType,
});
}

// class POI{
//   final String name;
//   final gemaps.LatLng location;
//
//   POI(this.name, this.location)
//
// }