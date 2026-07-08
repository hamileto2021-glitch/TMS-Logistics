class Vehicle {
  final int id;
  final String vehicleCode;
  final String plateNumber;
  final String registrationNumber;
  final String make;
  final String model;
  final int year;
  final String vehicleType;
  final double capacityWeight;
  final double capacityVolume;
  final String fuelType;
  final int odometer;
  final String status;
  final String insuranceNumber;
  final DateTime? insuranceExpiry;
  final String roadLicenseNumber;
  final DateTime? roadLicenseExpiry;
  final String notes;

  Vehicle({
    required this.id,
    required this.vehicleCode,
    required this.plateNumber,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    required this.capacityWeight,
    required this.capacityVolume,
    required this.fuelType,
    required this.odometer,
    required this.status,
    required this.insuranceNumber,
    this.insuranceExpiry,
    required this.roadLicenseNumber,
    this.roadLicenseExpiry,
    required this.notes,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"] ?? 0,
      vehicleCode: json["vehicleCode"] ?? "",
      plateNumber: json["plateNumber"] ?? "",
      registrationNumber: json["registrationNumber"] ?? "",
      make: json["make"] ?? "",
      model: json["model"] ?? "",
      year: json["year"] ?? 0,
      vehicleType: json["vehicleType"] ?? "",
      capacityWeight: (json["capacityWeight"] ?? 0).toDouble(),
      capacityVolume: (json["capacityVolume"] ?? 0).toDouble(),
      fuelType: json["fuelType"] ?? "",
      odometer: json["odometer"] ?? 0,
      status: json["status"] ?? "",
      insuranceNumber: json["insuranceNumber"] ?? "",
      insuranceExpiry: json["insuranceExpiry"] == null
          ? null
          : DateTime.parse(json["insuranceExpiry"]),
      roadLicenseNumber: json["roadLicenseNumber"] ?? "",
      roadLicenseExpiry: json["roadLicenseExpiry"] == null
          ? null
          : DateTime.parse(json["roadLicenseExpiry"]),
      notes: json["notes"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "vehicleCode": vehicleCode,
      "plateNumber": plateNumber,
      "registrationNumber": registrationNumber,
      "make": make,
      "model": model,
      "year": year,
      "vehicleType": vehicleType,
      "capacityWeight": capacityWeight,
      "capacityVolume": capacityVolume,
      "fuelType": fuelType,
      "odometer": odometer,
      "status": status,
      "insuranceNumber": insuranceNumber,
      "insuranceExpiry": insuranceExpiry?.toIso8601String(),
      "roadLicenseNumber": roadLicenseNumber,
      "roadLicenseExpiry": roadLicenseExpiry?.toIso8601String(),
      "notes": notes,
    };
  }
}