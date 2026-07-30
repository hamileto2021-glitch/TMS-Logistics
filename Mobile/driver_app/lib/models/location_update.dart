class LocationUpdate {
  final int tripId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;

  LocationUpdate({
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
  });

  Map<String, dynamic> toJson() => {
    "tripId": tripId,
    "latitude": latitude,
    "longitude": longitude,
    "speed": speed,
    "heading": heading,
  };
}