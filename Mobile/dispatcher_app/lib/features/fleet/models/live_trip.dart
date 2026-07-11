class LiveTrip {
  final int tripId;
  final String tripNumber;
  final String driverName;
  final String vehiclePlate;
  final String origin;
  final String destination;
  final String status;
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime recordedAt;

  LiveTrip({
    required this.tripId,
    required this.tripNumber,
    required this.driverName,
    required this.vehiclePlate,
    required this.origin,
    required this.destination,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.recordedAt,
  });

  factory LiveTrip.fromJson(Map<String, dynamic> json) {
    return LiveTrip(
      tripId: json["tripId"],
      tripNumber: json["tripNumber"],
      driverName: json["driverName"],
      vehiclePlate: json["vehiclePlate"],
      origin: json["origin"],
      destination: json["destination"],
      status: json["status"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      speed: (json["speed"] as num).toDouble(),
      recordedAt: DateTime.parse(json["recordedAt"]),
    );
  }
}