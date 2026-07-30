class TripReplayPoint {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DateTime recordedAt;

  const TripReplayPoint({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.recordedAt,
  });

  factory TripReplayPoint.fromJson(Map<String, dynamic> json) {
    return TripReplayPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt']),
    );
  }
}