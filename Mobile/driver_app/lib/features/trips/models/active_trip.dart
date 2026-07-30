class ActiveTrip {
  final int tripId;
  final String tripNumber;
  final int shipmentId;
  final String shipmentNumber;
  final String customerName;
  final String origin;
  final String destination;
  final String vehicleCode;
  final String plateNumber;
  final String driverName;
  final DateTime dispatchDate;
  final DateTime? startTime;
  final DateTime? estimatedArrival;
  final String status;
  final double? latitude;
  final double? longitude;

  ActiveTrip({
    required this.tripId,
    required this.tripNumber,
    required this.shipmentId,
    required this.shipmentNumber,
    required this.customerName,
    required this.origin,
    required this.destination,
    required this.vehicleCode,
    required this.plateNumber,
    required this.driverName,
    required this.dispatchDate,
    this.startTime,
    this.estimatedArrival,
    required this.status,
    this.latitude,
    this.longitude,
  });

  factory ActiveTrip.fromJson(Map<String, dynamic> json) {
    return ActiveTrip(
      tripId: json['tripId'],
      tripNumber: json['tripNumber'] ?? '',
      shipmentId: json['shipmentId'],
      shipmentNumber: json['shipmentNumber'] ?? '',
      customerName: json['customerName'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      vehicleCode: json['vehicleCode'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      driverName: json['driverName'] ?? '',
      dispatchDate: DateTime.parse(json['dispatchDate']),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime']),
      estimatedArrival: json['estimatedArrival'] == null
          ? null
          : DateTime.parse(json['estimatedArrival']),
      status: json['status'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
  ActiveTrip copyWith({
    int? tripId,
    String? tripNumber,
    int? shipmentId,
    String? shipmentNumber,
    String? customerName,
    String? origin,
    String? destination,
    String? vehicleCode,
    String? plateNumber,
    String? driverName,
    DateTime? dispatchDate,
    DateTime? startTime,
    DateTime? estimatedArrival,
    String? status,
    double? latitude,
    double? longitude,
  }) {
    return ActiveTrip(
      tripId: tripId ?? this.tripId,
      tripNumber: tripNumber ?? this.tripNumber,
      shipmentId: shipmentId ?? this.shipmentId,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      customerName: customerName ?? this.customerName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      vehicleCode: vehicleCode ?? this.vehicleCode,
      plateNumber: plateNumber ?? this.plateNumber,
      driverName: driverName ?? this.driverName,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      startTime: startTime ?? this.startTime,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}