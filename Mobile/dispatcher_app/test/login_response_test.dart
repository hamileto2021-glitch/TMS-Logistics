import 'package:flutter_test/flutter_test.dart';
import 'package:dispatcher_app/models/login_response.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('extracts token from a direct token field', () {
      final response = LoginResponse.fromJson({
        'token': 'abc123',
        'message': 'success',
      });

      expect(response.token, 'abc123');
      expect(response.message, 'success');
    });

    test('extracts token from an accessToken field', () {
      final response = LoginResponse.fromJson({
        'accessToken': 'def456',
        'message': 'success',
      });

      expect(response.token, 'def456');
    });

    test('extracts token from a nested data payload', () {
      final response = LoginResponse.fromJson({
        'data': {
          'token': 'ghi789',
        },
        'message': 'success',
      });

      expect(response.token, 'ghi789');
    });

    test('strips Bearer prefix and trims whitespace', () {
      final response = LoginResponse.fromJson({
        'token': '  Bearer jwt-token  ',
      });

      expect(response.token, 'jwt-token');
    });
  });
}
