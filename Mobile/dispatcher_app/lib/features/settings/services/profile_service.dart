import '../models/user_profile.dart';
import '../../../core/api/api_client.dart';

class ProfileService {
  Future<UserProfile> getProfile() async {
    final response = await ApiClient.dio.get("/Users/profile");

    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.data);
    }

    throw Exception("Failed to load profile.");
  }
}