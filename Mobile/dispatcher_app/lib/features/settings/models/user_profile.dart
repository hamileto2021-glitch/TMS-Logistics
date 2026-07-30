class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"],
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
      isActive: json["isActive"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}