class GeofenceNotification {
  final int tripId;
  final int geofenceId;
  final String tripNumber;
  final String vehiclePlate;
  final String geofenceName;
  final String eventType;
  final DateTime time;
  final double latitude;
  final double longitude;

  GeofenceNotification({
    required this.tripId,
    required this.geofenceId,
    required this.tripNumber,
    required this.vehiclePlate,
    required this.geofenceName,
    required this.eventType,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory GeofenceNotification.fromJson(Map<String, dynamic> json) {
    return GeofenceNotification(
      tripId: json['tripId'],
      geofenceId: json['geofenceId'],
      tripNumber: json['tripNumber'] ?? '',
      vehiclePlate: json['vehiclePlate'] ?? '',
      geofenceName: json['geofenceName'] ?? '',
      eventType: json['eventType'] ?? '',
      time: DateTime.parse(json['time']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}