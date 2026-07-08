class Trip {
  final int id;
  final String tripNumber;

  final int dispatchId;
  final String dispatchNumber;

  final int shipmentId;
  final String shipmentNumber;

  final int vehicleId;
  final String vehiclePlateNumber;

  final int driverId;
  final String driverName;

  final DateTime? startTime;
  final DateTime? endTime;

  final double distanceKm;
  final double fuelUsed;

  final double odometer;

  final String currentLocation;

  final String delayReason;

  final String status;

  final String remarks;

  final DateTime createdAt;

  Trip({
    required this.id,
    required this.tripNumber,

    required this.dispatchId,
    required this.dispatchNumber,

    required this.shipmentId,
    required this.shipmentNumber,

    required this.vehicleId,
    required this.vehiclePlateNumber,

    required this.driverId,
    required this.driverName,

    this.startTime,
    this.endTime,

    required this.distanceKm,
    required this.fuelUsed,

    required this.odometer,

    required this.currentLocation,

    required this.delayReason,

    required this.status,

    required this.remarks,

    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json["id"],

      tripNumber: json["tripNumber"] ?? "",

      dispatchId: json["dispatchId"] ?? 0,
      dispatchNumber: json["dispatchNumber"] ?? "",

      shipmentId: json["shipmentId"] ?? 0,
      shipmentNumber: json["shipmentNumber"] ?? "",

      vehicleId: json["vehicleId"] ?? 0,
      vehiclePlateNumber: json["vehiclePlateNumber"] ?? "",

      driverId: json["driverId"] ?? 0,
      driverName: json["driverName"] ?? "",

      startTime: json["startTime"] != null
          ? DateTime.parse(json["startTime"])
          : null,

      endTime: json["endTime"] != null
          ? DateTime.parse(json["endTime"])
          : null,

      distanceKm:
      (json["distanceKm"] ?? 0).toDouble(),

      fuelUsed:
      (json["fuelUsed"] ?? 0).toDouble(),

      odometer:
      (json["odometer"] ?? 0).toDouble(),

      currentLocation:
      json["currentLocation"] ?? "",

      delayReason:
      json["delayReason"] ?? "",

      status:
      json["status"] ?? "",

      remarks:
      json["remarks"] ?? "",

      createdAt:
      DateTime.parse(json["createdAt"]),
    );
  }
}