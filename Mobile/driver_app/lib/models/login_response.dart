class LoginResponse {
  final String token;
  final int id;
  final String fullName;
  final String email;
  final String role;
  final int? driverId;
  final int? vehicleId;

  LoginResponse({
    required this.token,
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.driverId,
    this.vehicleId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      id: json["id"],
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
      driverId: json["driverId"],
      vehicleId: json["vehicleId"],
    );
  }
}