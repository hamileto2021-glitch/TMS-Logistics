class UpdateTripRequest {
  final DateTime? startTime;
  final DateTime? endTime;
  final double distance;
  final double fuel;
  final double odometer;
  final String currentLocation;
  final String delayReason;
  final String status;
  final String remarks;

  UpdateTripRequest({
    this.startTime,
    this.endTime,
    required this.distance,
    required this.fuel,
    required this.odometer,
    required this.currentLocation,
    required this.delayReason,
    required this.status,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime?.toIso8601String(),
      "endTime": endTime?.toIso8601String(),
      "distance": distance,
      "fuel": fuel,
      "odometer": odometer,
      "currentLocation": currentLocation,
      "delayReason": delayReason,
      "status": status,
      "remarks": remarks,
    };
  }
}