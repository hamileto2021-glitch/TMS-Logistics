class FleetAlert {
  final int tripId;
  final String tripNumber;
  final String vehiclePlate;
  final String driverName;
  final String alertType;
  final String severity;
  final String message;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  const FleetAlert({
    required this.tripId,
    required this.tripNumber,
    required this.vehiclePlate,
    required this.driverName,
    required this.alertType,
    required this.severity,
    required this.message,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory FleetAlert.fromJson(Map<String, dynamic> json) {
    return FleetAlert(
      tripId: json["tripId"],
      tripNumber: json["tripNumber"],
      vehiclePlate: json["vehiclePlate"],
      driverName: json["driverName"],
      alertType: json["alertType"],
      severity: json["severity"],
      message: json["message"],
      createdAt: DateTime.parse(json["createdAt"]),
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
    );
  }
}