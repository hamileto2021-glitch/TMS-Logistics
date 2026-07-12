class CompleteDeliveryRequest {
  final String receiverName;
  final String? receiverPhone;
  final String? notes;
  final double latitude;
  final double longitude;
  final String? photoPath;
  final String? signaturePath;

  CompleteDeliveryRequest({
    required this.receiverName,
    this.receiverPhone,
    this.notes,
    required this.latitude,
    required this.longitude,
    this.photoPath,
    this.signaturePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "receiverName": receiverName,
      "receiverPhone": receiverPhone,
      "notes": notes,
      "latitude": latitude,
      "longitude": longitude,
      "photoPath": photoPath,
      "signaturePath": signaturePath,
    };
  }
}