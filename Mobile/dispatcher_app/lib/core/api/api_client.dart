import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../storage/token_storage.dart';

class ApiClient {
  static final TokenStorage _tokenStorage = TokenStorage();
  
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
      validateStatus: (status) => true, // Don't throw on any status code
    ),
  )
    ..interceptors.add(_AuthInterceptor(_tokenStorage))
    ..interceptors.add(_ErrorInterceptor());
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  _AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token attachment for login endpoint
    if (options.path.contains('/Auth/login')) {
      return handler.next(options);
    }

    try {
      final token = await _tokenStorage.getToken();
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        print("[AUTH] ✅ Token attached: ${token.substring(0, 20)}...");
      } else {
        print("[AUTH] ⚠️ No token found in storage!");
      }
    } catch (e) {
      print("[AUTH] ❌ Error retrieving token: $e");
    }
    
    return handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      print("[ERROR] ❌ 401 Unauthorized");
      print("[ERROR] URL: ${response.requestOptions.path}");
      print("[ERROR] Response: ${response.data}");
    }
    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    print("[ERROR] DioException: ${err.type}");
    print("[ERROR] Message: ${err.message}");
    print("[ERROR] Status: ${err.response?.statusCode}");
    handler.next(err);
  }
}