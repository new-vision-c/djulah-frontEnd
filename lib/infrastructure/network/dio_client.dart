import 'package:dio/dio.dart';

import '../../app/config/app_config.dart';
import 'jwt_interceptor.dart';

class DioClient {
  final Dio dio;
  DioClient()
      : dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.networkTimeout,
      receiveTimeout: AppConfig.networkTimeout,
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
