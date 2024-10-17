class Place {
  final String name;
  final double lat;
  final double lng;

  Place({required this.name, required this.lat, required this.lng});

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    return Place(
      name: json['name'],
      lat: location['lat'],
      lng: location['lng'],
    );
  }
}