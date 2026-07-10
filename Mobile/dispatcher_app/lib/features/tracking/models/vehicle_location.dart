class VehicleLocation {
  final int id;
  final int tripId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DateTime recordedAt;

  VehicleLocation({
    required this.id,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.recordedAt,
  });

  factory VehicleLocation.fromJson(Map<String, dynamic> json) {
    return VehicleLocation(
      id: json["id"],
      tripId: json["tripId"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      speed: (json["speed"] as num).toDouble(),
      heading: (json["heading"] as num).toDouble(),
      recordedAt: DateTime.parse(json["recordedAt"]),
    );
  }
}