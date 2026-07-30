class DriverDashboard {
  final int driverId;
  final String driverName;
  final String vehicleCode;
  final String plateNumber;
  final String driverStatus;

  final int totalTrips;
  final int scheduledTrips;
  final int activeTrips;
  final int completedTrips;

  final ActiveTrip? activeTrip;

  DriverDashboard({
    required this.driverId,
    required this.driverName,
    required this.vehicleCode,
    required this.plateNumber,
    required this.driverStatus,
    required this.totalTrips,
    required this.scheduledTrips,
    required this.activeTrips,
    required this.completedTrips,
    this.activeTrip,
  });

  factory DriverDashboard.fromJson(Map<String, dynamic> json) {
    return DriverDashboard(
      driverId: json['driverId'],
      driverName: json['driverName'] ?? '',
      vehicleCode: json['vehicleCode'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      driverStatus: json['driverStatus'] ?? '',

      totalTrips: json['totalTrips'] ?? 0,
      scheduledTrips: json['scheduledTrips'] ?? 0,
      activeTrips: json['activeTrips'] ?? 0,
      completedTrips: json['completedTrips'] ?? 0,

      activeTrip: json['activeTrip'] == null
          ? null
          : ActiveTrip.fromJson(json['activeTrip']),
    );
  }
}

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
  final DateTime? dispatchDate;
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
    this.dispatchDate,
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
      shipmentId: json['shipmentId'] ?? 0,
      shipmentNumber: json['shipmentNumber'] ?? '',
      customerName: json['customerName'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      vehicleCode: json['vehicleCode'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      driverName: json['driverName'] ?? '',
      dispatchDate: json['dispatchDate'] == null
          ? null
          : DateTime.parse(json['dispatchDate']),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime']),
      estimatedArrival: json['estimatedArrival'] == null
          ? null
          : DateTime.parse(json['estimatedArrival']),
      status: json['status'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}