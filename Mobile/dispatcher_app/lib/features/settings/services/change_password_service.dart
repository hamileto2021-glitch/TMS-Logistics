
import '../../../core/api/api_client.dart';
import '../models/change_password_request.dart';

class ChangePasswordService {
  Future<String> changePassword(ChangePasswordRequest request) async {
    final response = await ApiClient.dio.put(
      "/Users/change-password",
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return response.data["message"] ?? "Password changed successfully.";
    }

    if (response.data is Map &&
        response.data["message"] != null) {
      throw Exception(response.data["message"]);
    }

    throw Exception("Unable to change password.");
  }
}