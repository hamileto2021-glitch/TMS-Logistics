class LocationModel {
  final int tripId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;

  LocationModel({
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
  });

  Map<String, dynamic> toJson() {
    return {
      "tripId": tripId,
      "latitude": latitude,
      "longitude": longitude,
      "speed": speed,
      "heading": heading,
    };
  }
}