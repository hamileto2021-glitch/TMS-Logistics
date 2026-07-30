class ReportSummary {
  // Fleet
  final int totalVehicles;
  final int availableVehicles;
  final int busyVehicles;
  final int maintenanceVehicles;

  // Drivers
  final int totalDrivers;
  final int availableDrivers;
  final int assignedDrivers;

  // Shipments
  final int totalShipments;
  final int pendingShipments;
  final int deliveredShipments;

  // Dispatches
  final int totalDispatches;
  final int activeDispatches;

  // Trips
  final int totalTrips;
  final int activeTrips;
  final int completedTrips;

  ReportSummary({
    required this.totalVehicles,
    required this.availableVehicles,
    required this.busyVehicles,
    required this.maintenanceVehicles,
    required this.totalDrivers,
    required this.availableDrivers,
    required this.assignedDrivers,
    required this.totalShipments,
    required this.pendingShipments,
    required this.deliveredShipments,
    required this.totalDispatches,
    required this.activeDispatches,
    required this.totalTrips,
    required this.activeTrips,
    required this.completedTrips,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalVehicles: json["totalVehicles"] ?? 0,
      availableVehicles: json["availableVehicles"] ?? 0,
      busyVehicles: json["busyVehicles"] ?? 0,
      maintenanceVehicles: json["maintenanceVehicles"] ?? 0,
      totalDrivers: json["totalDrivers"] ?? 0,
      availableDrivers: json["availableDrivers"] ?? 0,
      assignedDrivers: json["assignedDrivers"] ?? 0,
      totalShipments: json["totalShipments"] ?? 0,
      pendingShipments: json["pendingShipments"] ?? 0,
      deliveredShipments: json["deliveredShipments"] ?? 0,
      totalDispatches: json["totalDispatches"] ?? 0,
      activeDispatches: json["activeDispatches"] ?? 0,
      totalTrips: json["totalTrips"] ?? 0,
      activeTrips: json["activeTrips"] ?? 0,
      completedTrips: json["completedTrips"] ?? 0,
    );
  }
}