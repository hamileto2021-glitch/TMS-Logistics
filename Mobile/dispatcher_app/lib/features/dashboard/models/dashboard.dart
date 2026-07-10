class Dashboard {
  final int customers;
  final int shipments;
  final int dispatches;
  final int trips;
  final int vehicles;
  final int drivers;

  final int availableVehicles;
  final int busyVehicles;
  final int availableDrivers;
  final int activeTrips;

  Dashboard({
    required this.customers,
    required this.shipments,
    required this.dispatches,
    required this.trips,
    required this.vehicles,
    required this.drivers,
    required this.availableVehicles,
    required this.busyVehicles,
    required this.availableDrivers,
    required this.activeTrips,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      customers: json["customers"] ?? 0,
      shipments: json["shipments"] ?? 0,
      dispatches: json["dispatches"] ?? 0,
      trips: json["trips"] ?? 0,
      vehicles: json["vehicles"] ?? 0,
      drivers: json["drivers"] ?? 0,
      availableVehicles: json["availableVehicles"] ?? 0,
      busyVehicles: json["busyVehicles"] ?? 0,
      availableDrivers: json["availableDrivers"] ?? 0,
      activeTrips: json["activeTrips"] ?? 0,
    );
  }
}