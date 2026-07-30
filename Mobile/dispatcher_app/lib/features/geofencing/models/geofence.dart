class Geofence {
  final int id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final double radius;
  final String? polygonCoordinates;
  final int? customerId;
  final int? warehouseId;
  final bool isActive;

  const Geofence({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.polygonCoordinates,
    this.customerId,
    this.warehouseId,
    required this.isActive,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) {
    return Geofence(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      polygonCoordinates: json['polygonCoordinates'],
      customerId: json['customerId'],
      warehouseId: json['warehouseId'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'polygonCoordinates': polygonCoordinates,
      'customerId': customerId,
      'warehouseId': warehouseId,
      'isActive': isActive,
    };
  }

  Geofence copyWith({
    int? id,
    String? name,
    String? type,
    double? latitude,
    double? longitude,
    double? radius,
    String? polygonCoordinates,
    int? customerId,
    int? warehouseId,
    bool? isActive,
  }) {
    return Geofence(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      polygonCoordinates: polygonCoordinates ?? this.polygonCoordinates,
      customerId: customerId ?? this.customerId,
      warehouseId: warehouseId ?? this.warehouseId,
      isActive: isActive ?? this.isActive,
    );
  }
}