import 'package:dio/dio.dart';

import '../models/api_response.dart';
import 'api_client.dart';

abstract class BaseApiService {
  Dio get dio => ApiClient.dio;

  Future<ApiResponse<T>> get<T>(
      String url,
      T Function(dynamic data) converter,
      ) async {
    final response = await dio.get(url);

    return ApiResponse<T>.fromJson(
      response.data,
      converter,
    );
  }

  Future<ApiResponse<T>> post<T>(
      String url,
      dynamic body,
      T Function(dynamic data) converter,
      ) async {
    final response = await dio.post(
      url,
      data: body,
    );

    return ApiResponse<T>.fromJson(
      response.data,
      converter,
    );
  }
}