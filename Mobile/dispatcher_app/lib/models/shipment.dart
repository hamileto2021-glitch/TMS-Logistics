class Shipment {
  final int id;
  final String shipmentNumber;

  final int customerId;
  final int? vehicleId;
  final int? driverId;

  final String? customerName;

  final String? vehiclePlateNumber;

  final String? vehicleName;

  final String? driverName;

  final String? driverPhone;
  final String origin;
  final String destination;
  final String cargoType;

  final double weight;
  final double volume;

  final int numberOfPackages;

  final DateTime bookingDate;
  final DateTime? dispatchDate;
  final DateTime? expectedDeliveryDate;

  final String status;
  final String notes;

  Shipment({
    required this.id,
    required this.shipmentNumber,
    required this.customerId,

    this.customerName,

    this.vehicleId,
    this.vehiclePlateNumber,
    this.vehicleName,

    this.driverId,
    this.driverName,
    this.driverPhone,

    required this.origin,
    required this.destination,
    required this.cargoType,
    required this.weight,
    required this.volume,
    required this.numberOfPackages,
    required this.bookingDate,
    this.dispatchDate,
    this.expectedDeliveryDate,
    required this.status,
    required this.notes,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json["id"] ?? 0,
      shipmentNumber: json["shipmentNumber"] ?? "",
      customerId: json["customerId"] ?? 0,
      customerName: json["customerName"],

      vehiclePlateNumber: json["vehiclePlateNumber"],

      vehicleName: json["vehicleName"],

      driverName: json["driverName"],

      driverPhone: json["driverPhone"],
      vehicleId: json["vehicleId"],
      driverId: json["driverId"],
      origin: json["origin"] ?? "",
      destination: json["destination"] ?? "",
      cargoType: json["cargoType"] ?? "",
      weight: (json["weight"] ?? 0).toDouble(),
      volume: (json["volume"] ?? 0).toDouble(),
      numberOfPackages: json["numberOfPackages"] ?? 0,
      bookingDate: json["bookingDate"] == null
          ? DateTime.now()
          : DateTime.parse(json["bookingDate"]),
      dispatchDate: json["dispatchDate"] == null
          ? null
          : DateTime.parse(json["dispatchDate"]),
      expectedDeliveryDate:
      json["expectedDeliveryDate"] == null
          ? null
          : DateTime.parse(
        json["expectedDeliveryDate"],
      ),
      status: json["status"] ?? "Pending",
      notes: json["notes"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "shipmentNumber": shipmentNumber,
      "customerId": customerId,
      "customerName": customerName,

      "vehiclePlateNumber": vehiclePlateNumber,

      "vehicleName": vehicleName,

      "driverName": driverName,

      "driverPhone": driverPhone,
      "vehicleId": vehicleId,
      "driverId": driverId,
      "origin": origin,
      "destination": destination,
      "cargoType": cargoType,
      "weight": weight,
      "volume": volume,
      "numberOfPackages": numberOfPackages,
      "bookingDate": bookingDate.toIso8601String(),
      "dispatchDate": dispatchDate?.toIso8601String(),
      "expectedDeliveryDate":
      expectedDeliveryDate?.toIso8601String(),
      "status": status,
      "notes": notes,
    };
  }

  Shipment copyWith({
    int? id,
    String? shipmentNumber,
    int? customerId,

    String? customerName,

    int? vehicleId,
    String? vehiclePlateNumber,
    String? vehicleName,

    int? driverId,
    String? driverName,
    String? driverPhone,

    String? origin,
    String? destination,
    String? cargoType,
    double? weight,
    double? volume,
    int? numberOfPackages,
    DateTime? bookingDate,
    DateTime? dispatchDate,
    DateTime? expectedDeliveryDate,
    String? status,
    String? notes,
  }) {
    return Shipment(
      id: id ?? this.id,
      shipmentNumber:
      shipmentNumber ?? this.shipmentNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,

      vehicleId: vehicleId ?? this.vehicleId,

      vehiclePlateNumber:
      vehiclePlateNumber ?? this.vehiclePlateNumber,

      vehicleName:
      vehicleName ?? this.vehicleName,

      driverId: driverId ?? this.driverId,

      driverName:
      driverName ?? this.driverName,

      driverPhone:
      driverPhone ?? this.driverPhone,

      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      cargoType: cargoType ?? this.cargoType,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      numberOfPackages:
      numberOfPackages ?? this.numberOfPackages,
      bookingDate: bookingDate ?? this.bookingDate,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      expectedDeliveryDate:
      expectedDeliveryDate ??
          this.expectedDeliveryDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}