class CurrentUser {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final int? driverId;
  final int? vehicleId;

  CurrentUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.driverId,
    this.vehicleId,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json["id"],
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
      driverId: json["driverId"],
      vehicleId: json["vehicleId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "role": role,
      "driverId": driverId,
      "vehicleId": vehicleId,
    };
  }
}