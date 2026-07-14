class DeliveryDetails {
  final int tripId;
  final String tripNumber;
  final String shipmentNumber;
  final String driverName;
  final String vehiclePlate;
  final String receiverName;
  final String receiverPhone;
  final String notes;
  final String? photoPath;
  final String? signaturePath;
  final double latitude;
  final double longitude;
  final DateTime deliveredAt;

  DeliveryDetails({
    required this.tripId,
    required this.tripNumber,
    required this.shipmentNumber,
    required this.driverName,
    required this.vehiclePlate,
    required this.receiverName,
    required this.receiverPhone,
    required this.notes,
    required this.photoPath,
    required this.signaturePath,
    required this.latitude,
    required this.longitude,
    required this.deliveredAt,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryDetails(
      tripId: json["tripId"],
      tripNumber: json["tripNumber"],
      shipmentNumber: json["shipmentNumber"],
      driverName: json["driverName"],
      vehiclePlate: json["vehiclePlate"],
      receiverName: json["receiverName"],
      receiverPhone: json["receiverPhone"],
      notes: json["notes"] ?? "",
      photoPath: json["photoPath"],
      signaturePath: json["signaturePath"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      deliveredAt: DateTime.parse(json["deliveredAt"]),
    );
  }
}