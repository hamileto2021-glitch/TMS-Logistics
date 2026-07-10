class Dispatch {
  final int id;
  final String dispatchNumber;

  final int shipmentId;
  final String shipmentNumber;

  final int vehicleId;
  final String vehiclePlate;

  final int driverId;
  final String driverName;

  final DateTime dispatchDate;

  final String status;

  final String notes;

  Dispatch({
    required this.id,
    required this.dispatchNumber,

    required this.shipmentId,
    required this.shipmentNumber,

    required this.vehicleId,
    required this.vehiclePlate,

    required this.driverId,
    required this.driverName,

    required this.dispatchDate,

    required this.status,

    required this.notes,
  });

  factory Dispatch.fromJson(Map<String, dynamic> json) {
    return Dispatch(
      id: json["id"] ?? 0,

      dispatchNumber: json["dispatchNumber"] ?? "",

      shipmentId: json["shipmentId"] ?? 0,

      shipmentNumber: json["shipmentNumber"] ?? "",

      vehicleId: json["vehicleId"] ?? 0,

      vehiclePlate: json["vehiclePlate"] ?? "",

      driverId: json["driverId"] ?? 0,

      driverName: json["driverName"] ?? "",

      dispatchDate: json["dispatchDate"] == null
          ? DateTime.now()
          : DateTime.parse(json["dispatchDate"]),

      status: json["status"] ?? "Scheduled",

      notes: json["notes"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "shipmentId": shipmentId,
      "vehicleId": vehicleId,
      "driverId": driverId,
      "dispatchDate": dispatchDate.toIso8601String(),
      "status": status,
      "notes": notes,
    };
  }
}