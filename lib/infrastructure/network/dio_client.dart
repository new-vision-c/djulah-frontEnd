import 'package:dio/dio.dart';

import '../../app/config/app_config.dart';
import 'jwt_interceptor.dart';

class DioClient {
  final Dio dio;
  DioClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: "application/json",
      headers: {
        'Content-Type': 'application/json',
        'Time-Zone': "UTC",
      },
      validateStatus: (status) => (status ?? 500) < 600,
    ),
  ) {
    dio.interceptors.addAll([
      JwtInterceptor(),
    ]);
  }

  Dio getDio() => dio;
}
