class TripHistory {
  final int tripId;
  final String tripNumber;
  final String shipmentNumber;
  final String customerName;
  final String origin;
  final String destination;
  final DateTime? startTime;
  final DateTime? endTime;
  final double distanceKm;
  final double fuelUsed;
  final String status;

  TripHistory({
    required this.tripId,
    required this.tripNumber,
    required this.shipmentNumber,
    required this.customerName,
    required this.origin,
    required this.destination,
    this.startTime,
    this.endTime,
    required this.distanceKm,
    required this.fuelUsed,
    required this.status,
  });

  factory TripHistory.fromJson(Map<String, dynamic> json) {
    return TripHistory(
      tripId: json['tripId'],
      tripNumber: json['tripNumber'] ?? '',
      shipmentNumber: json['shipmentNumber'] ?? '',
      customerName: json['customerName'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime']),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime']),
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      fuelUsed: (json['fuelUsed'] ?? 0).toDouble(),
      status: json['status'] ?? '',
    );
  }
}