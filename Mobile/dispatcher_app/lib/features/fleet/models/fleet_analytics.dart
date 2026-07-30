class FleetAnalytics {
  final int totalVehicles;
  final int movingVehicles;
  final int idleVehicles;
  final int offlineVehicles;

  final int activeTrips;
  final int completedTrips;
  final int delayedTrips;

  final int totalDrivers;
  final int availableDrivers;

  final double averageSpeed;
  final double totalDistanceToday;

  final int alertsToday;

  const FleetAnalytics({
    required this.totalVehicles,
    required this.movingVehicles,
    required this.idleVehicles,
    required this.offlineVehicles,
    required this.activeTrips,
    required this.completedTrips,
    required this.delayedTrips,
    required this.totalDrivers,
    required this.availableDrivers,
    required this.averageSpeed,
    required this.totalDistanceToday,
    required this.alertsToday,
  });

  factory FleetAnalytics.fromJson(Map<String, dynamic> json) {
    return FleetAnalytics(
      totalVehicles: json['totalVehicles'] ?? 0,
      movingVehicles: json['movingVehicles'] ?? 0,
      idleVehicles: json['idleVehicles'] ?? 0,
      offlineVehicles: json['offlineVehicles'] ?? 0,
      activeTrips: json['activeTrips'] ?? 0,
      completedTrips: json['completedTrips'] ?? 0,
      delayedTrips: json['delayedTrips'] ?? 0,
      totalDrivers: json['totalDrivers'] ?? 0,
      availableDrivers: json['availableDrivers'] ?? 0,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0,
      totalDistanceToday:
      (json['totalDistanceToday'] as num?)?.toDouble() ?? 0,
      alertsToday: json['alertsToday'] ?? 0,
    );
  }
}