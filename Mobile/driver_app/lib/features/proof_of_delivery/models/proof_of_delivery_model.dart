class ProofOfDeliveryModel {
  final int tripId;
  final String receiverName;
  final String notes;
  final double latitude;
  final double longitude;
  final String signaturePath;
  final String photoPath;

  const ProofOfDeliveryModel({
    required this.tripId,
    required this.receiverName,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.signaturePath,
    required this.photoPath,
  });

  ProofOfDeliveryModel copyWith({
    int? tripId,
    String? receiverName,
    String? notes,
    double? latitude,
    double? longitude,
    String? signaturePath,
    String? photoPath,
  }) {
    return ProofOfDeliveryModel(
      tripId: tripId ?? this.tripId,
      receiverName: receiverName ?? this.receiverName,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      signaturePath: signaturePath ?? this.signaturePath,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  String toString() {
    return 'ProofOfDeliveryModel('
        'tripId: $tripId, '
        'receiverName: $receiverName, '
        'notes: $notes, '
        'latitude: $latitude, '
        'longitude: $longitude, '
        'signaturePath: $signaturePath, '
        'photoPath: $photoPath'
        ')';
  }
}