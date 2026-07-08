class Driver {
  final int id;
  final String driverNumber;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final DateTime? licenseExpiry;
  final String address;
  final String status;
  final int? vehicleId;

  Driver({
    required this.id,
    required this.driverNumber,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    this.licenseExpiry,
    required this.address,
    required this.status,
    this.vehicleId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json["id"] ?? 0,
      driverNumber: json["driverNumber"] ?? "",
      fullName: json["fullName"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      email: json["email"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",
      licenseExpiry: json["licenseExpiry"] == null
          ? null
          : DateTime.parse(json["licenseExpiry"]),
      address: json["address"] ?? "",
      status: json["status"] ?? "Available",
      vehicleId: json["vehicleId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverNumber": driverNumber,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "email": email,
      "licenseNumber": licenseNumber,
      "licenseExpiry": licenseExpiry?.toIso8601String(),
      "address": address,
      "status": status,
      "vehicleId": vehicleId,
    };
  }

  Driver copyWith({
    int? id,
    String? driverNumber,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? licenseNumber,
    DateTime? licenseExpiry,
    String? address,
    String? status,
    int? vehicleId,
  }) {
    return Driver(
      id: id ?? this.id,
      driverNumber: driverNumber ?? this.driverNumber,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      address: address ?? this.address,
      status: status ?? this.status,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }
}