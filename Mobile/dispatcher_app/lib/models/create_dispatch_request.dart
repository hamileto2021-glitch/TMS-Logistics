class CreateDispatchRequest {
  final int shipmentId;
  final int vehicleId;
  final int driverId;
  final DateTime dispatchDate;
  final String notes;

  CreateDispatchRequest({
    required this.shipmentId,
    required this.vehicleId,
    required this.driverId,
    required this.dispatchDate,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "shipmentId": shipmentId,
      "vehicleId": vehicleId,
      "driverId": driverId,
      "dispatchDate": dispatchDate.toIso8601String(),
      "notes": notes,
    };
  }
}