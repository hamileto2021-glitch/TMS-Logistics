class Trip {
  final int id;
  final String tripNumber;
  final String shipmentNumber;
  final String customerName;
  final String origin;
  final String destination;
  final String driverName;
  final String vehicleCode;
  final String plateNumber;
  final String status;
  final DateTime? dispatchTime;
  final DateTime? arrivalTime;

  const Trip({
    required this.id,
    required this.tripNumber,
    required this.shipmentNumber,
    required this.customerName,
    required this.origin,
    required this.destination,
    required this.driverName,
    required this.vehicleCode,
    required this.plateNumber,
    required this.status,
    this.dispatchTime,
    this.arrivalTime,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json["id"] ?? 0,
      tripNumber: json["tripNumber"] ?? "",
      shipmentNumber: json["shipmentNumber"] ?? "",
      customerName: json["customerName"] ?? "",
      origin: json["origin"] ?? "",
      destination: json["destination"] ?? "",
      driverName: json["driverName"] ?? "",
      vehicleCode: json["vehicleCode"] ?? "",
      plateNumber: json["plateNumber"] ?? "",
      status: json["status"] ?? "",
      dispatchTime: json["dispatchTime"] == null
          ? null
          : DateTime.parse(json["dispatchTime"]),
      arrivalTime: json["arrivalTime"] == null
          ? null
          : DateTime.parse(json["arrivalTime"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tripNumber": tripNumber,
      "shipmentNumber": shipmentNumber,
      "customerName": customerName,
      "origin": origin,
      "destination": destination,
      "driverName": driverName,
      "vehicleCode": vehicleCode,
      "plateNumber": plateNumber,
      "status": status,
      "dispatchTime": dispatchTime?.toIso8601String(),
      "arrivalTime": arrivalTime?.toIso8601String(),
    };
  }
}