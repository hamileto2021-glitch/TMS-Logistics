class VehicleLocation {
  final int tripId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DateTime recordedAt;

  VehicleLocation({
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.recordedAt,
  });

  factory VehicleLocation.fromJson(Map<String, dynamic> json) {
    return VehicleLocation(
      tripId: json["tripId"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      speed: (json["speed"] as num).toDouble(),
      heading: (json["heading"] as num?)?.toDouble() ?? 0,
      recordedAt: DateTime.parse(json["recordedAt"]),
    );
  }
}