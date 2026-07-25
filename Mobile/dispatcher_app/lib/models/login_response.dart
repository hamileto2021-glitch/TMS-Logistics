class LoginResponse {
  final String token;
  final String message;

  final int id;
  final String fullName;
  final String email;
  final String role;
  final int? driverId;
  final int? vehicleId;

  LoginResponse({
    required this.token,
    required this.message,
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.driverId,
    this.vehicleId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = _extractToken(json);

    return LoginResponse(
      token: token,
      message: json["message"]?.toString() ?? "",

      id: json["id"] ?? 0,
      fullName: json["fullName"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      role: json["role"]?.toString() ?? "",
      driverId: json["driverId"],
      vehicleId: json["vehicleId"],
    );
  }

  static String _extractToken(Map<String, dynamic> json) {
    final candidates = <String?>[
      json["token"]?.toString(),
      json["accessToken"]?.toString(),
      json["access_token"]?.toString(),
      json["jwt"]?.toString(),
      json["authToken"]?.toString(),
    ];

    for (final candidate in candidates) {
      final normalized = _normalizeToken(candidate);
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    final data = json["data"];

    if (data is Map<String, dynamic>) {
      final nested = _extractToken(data);
      if (nested.isNotEmpty) {
        return nested;
      }
    } else if (data is Map) {
      final nested = _extractToken(
        Map<String, dynamic>.from(data),
      );

      if (nested.isNotEmpty) {
        return nested;
      }
    }

    return "";
  }

  static String _normalizeToken(String? rawToken) {
    if (rawToken == null) return "";

    final trimmed = rawToken.trim();

    if (trimmed.isEmpty) return "";

    return trimmed.toLowerCase().startsWith("bearer ")
        ? trimmed.substring(7).trim()
        : trimmed;
  }
}