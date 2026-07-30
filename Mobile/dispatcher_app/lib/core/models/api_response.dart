class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic data) converter,
      ) {
    return ApiResponse<T>(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: converter(json["data"]),
      errors: json["errors"] == null
          ? null
          : List<String>.from(json["errors"]),
    );
  }
}