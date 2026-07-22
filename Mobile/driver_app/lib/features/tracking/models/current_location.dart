class CurrentLocation {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;

  CurrentLocation({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      speed: (json["speed"] as num?)?.toDouble() ?? 0,
      heading: (json["heading"] as num?)?.toDouble() ?? 0,
    );
  }
}