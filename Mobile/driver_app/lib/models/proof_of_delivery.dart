class ProofOfDelivery {

  final int tripId;

  final String receiverName;

  final String? notes;

  final String? signaturePath;

  final String? photoPath;

  final double latitude;

  final double longitude;

  ProofOfDelivery({
    required this.tripId,
    required this.receiverName,
    this.notes,
    this.signaturePath,
    this.photoPath,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "tripId": tripId,
      "receiverName": receiverName,
      "receiverSignaturePath": signaturePath,
      "deliveryPhotoPath": photoPath,
      "notes": notes,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}