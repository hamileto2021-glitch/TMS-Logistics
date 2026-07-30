class DriverTrip {
  final int id;
  final String tripNumber;
  final String shipmentNumber;

  final String origin;
  final String destination;

  String status;

  final String vehicle;
  final String driver;

  final DateTime? startTime;
  final DateTime? endTime;

  DriverTrip({
    required this.id,
    required this.tripNumber,
    required this.shipmentNumber,
    required this.origin,
    required this.destination,
    required this.status,
    required this.vehicle,
    required this.driver,
    this.startTime,
    this.endTime,
  });

  factory DriverTrip.fromJson(Map<String, dynamic> json) {
    return DriverTrip(
      id: json['id'],
      tripNumber: json['tripNumber'],
      shipmentNumber: json['shipmentNumber'],
      origin: json['origin'],
      destination: json['destination'],
      status: json['status'],
      vehicle: json['vehicle'],
      driver: json['driver'],
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime']),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime']),
    );
  }
}