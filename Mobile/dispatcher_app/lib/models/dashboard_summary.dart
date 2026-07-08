class DashboardSummary {
  final int totalCustomers;

  final int totalShipments;
  final int pendingShipments;
  final int dispatchedShipments;
  final int deliveredShipments;

  final int availableVehicles;
  final int assignedVehicles;
  final int maintenanceVehicles;

  final int availableDrivers;
  final int assignedDrivers;

  final int activeDispatches;
  final int activeTrips;

  DashboardSummary({
    required this.totalCustomers,

    required this.totalShipments,
    required this.pendingShipments,
    required this.dispatchedShipments,
    required this.deliveredShipments,

    required this.availableVehicles,
    required this.assignedVehicles,
    required this.maintenanceVehicles,

    required this.availableDrivers,
    required this.assignedDrivers,

    required this.activeDispatches,
    required this.activeTrips,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalCustomers: json["totalCustomers"] ?? 0,

      totalShipments: json["totalShipments"] ?? 0,
      pendingShipments: json["pendingShipments"] ?? 0,
      dispatchedShipments: json["dispatchedShipments"] ?? 0,
      deliveredShipments: json["deliveredShipments"] ?? 0,

      availableVehicles: json["availableVehicles"] ?? 0,
      assignedVehicles: json["assignedVehicles"] ?? 0,
      maintenanceVehicles: json["maintenanceVehicles"] ?? 0,

      availableDrivers: json["availableDrivers"] ?? 0,
      assignedDrivers: json["assignedDrivers"] ?? 0,

      activeDispatches: json["activeDispatches"] ?? 0,
      activeTrips: json["activeTrips"] ?? 0,
    );
  }
}