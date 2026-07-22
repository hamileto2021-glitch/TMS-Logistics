class DriverDashboard {
  final int driverId;
  final String driverName;
  final String vehicleCode;
  final String plateNumber;
  final String driverStatus;
  final ActiveTrip? activeTrip;

  DriverDashboard({
    required this.driverId,
    required this.driverName,
    required this.vehicleCode,
    required this.plateNumber,
    required this.driverStatus,
    this.activeTrip,
  });

  factory DriverDashboard.fromJson(Map<String, dynamic> json) {
    return DriverDashboard(
      driverId: json["driverId"],
      driverName: json["driverName"] ?? "",
      vehicleCode: json["vehicleCode"] ?? "",
      plateNumber: json["plateNumber"] ?? "",
      driverStatus: json["driverStatus"] ?? "",
      activeTrip: json["activeTrip"] == null
          ? null
          : ActiveTrip.fromJson(json["activeTrip"]),
    );
  }
}

class ActiveTrip {
  final int tripId;
  final String shipmentNumber;
  final String origin;
  final String destination;
  final String status;

  ActiveTrip({
    required this.tripId,
    required this.shipmentNumber,
    required this.origin,
    required this.destination,
    required this.status,
  });

  factory ActiveTrip.fromJson(Map<String, dynamic> json) {
    return ActiveTrip(
      tripId: json["tripId"],
      shipmentNumber: json["shipmentNumber"] ?? "",
      origin: json["origin"] ?? "",
      destination: json["destination"] ?? "",
      status: json["status"] ?? "",
    );
  }
}