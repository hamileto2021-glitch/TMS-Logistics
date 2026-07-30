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
  final double heading;
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
    required this.heading,

    required this.originLatitude,
    required this.originLongitude,

    required this.destinationLatitude,
    required this.destinationLongitude,

    required this.recordedAt,
  });

  LiveTrip copyWith({
    String? tripNumber,
    String? driverName,
    String? vehiclePlate,
    String? origin,
    String? destination,
    String? status,
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    double? originLatitude,
    double? originLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    DateTime? recordedAt,
  }) {
    return LiveTrip(
      tripId: tripId,
      tripNumber: tripNumber ?? this.tripNumber,
      driverName: driverName ?? this.driverName,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      originLatitude: originLatitude ?? this.originLatitude,
      originLongitude: originLongitude ?? this.originLongitude,
      destinationLatitude:
      destinationLatitude ?? this.destinationLatitude,
      destinationLongitude:
      destinationLongitude ?? this.destinationLongitude,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

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
      heading: (json["heading"] as num).toDouble(),

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