class CreateTripRequest {
  final int dispatchId;
  final DateTime? plannedStartTime;
  final String remarks;

  CreateTripRequest({
    required this.dispatchId,
    this.plannedStartTime,
    this.remarks = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "dispatchId": dispatchId,
      "plannedStartTime": plannedStartTime?.toIso8601String(),
      "remarks": remarks,
    };
  }
}