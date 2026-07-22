class RouteInfo {
  final double distanceKm;
  final int durationMinutes;
  final String encodedPolyline;

  RouteInfo({
    required this.distanceKm,
    required this.durationMinutes,
    required this.encodedPolyline,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      distanceKm: (json["distanceKm"] as num).toDouble(),
      durationMinutes: json["durationMinutes"],
      encodedPolyline: json["encodedPolyline"],
    );
  }
}