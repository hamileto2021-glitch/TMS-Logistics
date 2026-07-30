class FleetSummary {
  final int activeTrips;
  final int delayedTrips;
  final int completedTrips;
  final int idleVehicles;
  final int activeDrivers;

  const FleetSummary({
    required this.activeTrips,
    required this.delayedTrips,
    required this.completedTrips,
    required this.idleVehicles,
    required this.activeDrivers,
  });

  factory FleetSummary.empty() {
    return const FleetSummary(
      activeTrips: 0,
      delayedTrips: 0,
      completedTrips: 0,
      idleVehicles: 0,
      activeDrivers: 0,
    );
  }
}