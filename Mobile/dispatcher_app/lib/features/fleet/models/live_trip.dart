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
  final double originLatitude;
  final double originLongitude;

  final double destinationLatitude;
  final double destinationLongitude;

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

    required this.originLatitude,
    required this.originLongitude,

    required this.destinationLatitude,
    required this.destinationLongitude,

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

      originLatitude: (json["originLatitude"] as num).toDouble(),
      originLongitude: (json["originLongitude"] as num).toDouble(),

      destinationLatitude:
      (json["destinationLatitude"] as num).toDouble(),

      destinationLongitude:
      (json["destinationLongitude"] as num).toDouble(),

      recordedAt: DateTime.parse(json["recordedAt"]),
    );
  }
}