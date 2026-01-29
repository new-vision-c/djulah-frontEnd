import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../../datas/local_storage/app_storage.dart';
import 'dio_client.dart';
import 'network_state.dart';
import '../shared/app_enums.dart';

class JwtInterceptor extends Interceptor {
  static Future<String?>? _refreshingAccessToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = Get.find<AppStorage>();
    options.headers['Accept-Language'] = storage.languageHeaderValue;

    if (!options.path.contains("/auth")) {
      final token = storage.token;
      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final networkState = Get.find<NetworkStateService>();
    networkState.markBackendReachable();

    networkState.updateFromBackendPayload(response.data);

    print("status code rep ${response.statusCode}");
    print("status code rep ${response.statusMessage}");
    print("data : ${response.data}");

    if (response.statusCode == HttpStatus.unauthorized) {
      networkState.markUnauthorized();

      // If refresh endpoint itself is unauthorized => logout.
      if (response.requestOptions.path.contains('/token/refresh')) {
        await networkState.triggerLogout();
        return handler.next(response);
      }

      if (response.requestOptions.extra['__jwt_retry'] == true) {
        await networkState.triggerLogout();
        return handler.next(response);
      }

      if (!response.requestOptions.path.contains("/auth")) {
        final storage = Get.find<AppStorage>();
        final newToken = await _refreshAccessToken();
        if (newToken == null || newToken.isEmpty) {
          await networkState.triggerLogout();
          return handler.next(response);
        }

        final requestOptions = response.requestOptions;
        if (requestOptions.data is FormData) {
          requestOptions.data = await _recreateFormData(requestOptions.data as FormData);
        }

        requestOptions.headers['Authorization'] = 'Bearer $newToken';
        requestOptions.headers['Accept-Language'] = storage.languageHeaderValue;
        requestOptions.extra['__jwt_retry'] = true;

        final dioClient = Get.find<DioClient>();
        final cloneReq = await dioClient.dio.fetch(requestOptions);

        if (cloneReq.statusCode == HttpStatus.unauthorized) {
          await networkState.triggerLogout();
        }

        return handler.next(cloneReq);
      } else {
        // _goToErrorPage();
        return handler.next(response);
      }
    }
    else if (response.statusCode == HttpStatus.internalServerError) {
      networkState.notifyMessage(
        message: 'Erreur serveur. Réessaie plus tard.',
        type: MessageType.error,
      );
      return handler.next(response);
    }
    else if (response.statusCode == HttpStatus.locked) {
      networkState.markLocked();
      print("je suis bloquer");
      // _goToAccountLockedPage();
      return handler.next(response);
    }
    else {
      final statusCode = response.statusCode;
      final isSuccess = statusCode != null && statusCode >= 200 && statusCode < 300;

      if (!isSuccess) {
        final data = response.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? data['error']?.toString())
            : null;

        if (statusCode != null && statusCode >= 500) {
          networkState.notifyMessage(
            message: message ?? 'Erreur serveur. Réessaie plus tard.',
            type: MessageType.error,
          );
        } else {
          networkState.notifyMessage(
            message: message ?? 'Une erreur est survenue.',
            type: MessageType.warning,
          );
        }

        return handler.next(response);
      }

      networkState.markAccountOk();

      final data = response.data;
      String? accessToken;
      String? refreshToken;

      if (data is Map<String, dynamic>) {
        // Case 1: tokens at root level
        if (data.containsKey('accessToken') || data.containsKey('refreshToken')) {
          accessToken = data['accessToken']?.toString();
          refreshToken = data['refreshToken']?.toString();
        }
        // Case 2: tokens nested under success.data
        else if (data['success'] is Map && (data['success']['data'] is Map)) {
          final inner = data['success']['data'] as Map;
          accessToken = inner['accessToken']?.toString();
          refreshToken = inner['refreshToken']?.toString();
        }
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await Get.find<AppStorage>().saveRefreshToken(refreshToken);
      }
      if (accessToken != null && accessToken.isNotEmpty) {
        await Get.find<AppStorage>().saveToken(accessToken);
      }

      return handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final networkState = Get.find<NetworkStateService>();

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      networkState.markBackendUnreachable();
    }

    final statusCode = err.response?.statusCode;
    if (statusCode == HttpStatus.unauthorized) {
      networkState.markUnauthorized();
    }
    if (statusCode == HttpStatus.locked) {
      networkState.markLocked();
    }

    if (statusCode != null && statusCode >= 500) {
      networkState.notifyMessage(
        message: 'Erreur serveur. Réessaie plus tard.',
        type: MessageType.error,
      );
    }

    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      final data = err.response?.data;
      final message = (data is Map)
          ? (data['message']?.toString() ?? data['error']?.toString())
          : null;

      networkState.notifyMessage(
        message: message ?? 'Requête invalide.',
        type: MessageType.warning,
      );
    }

    print('Erreur Dio : $err');
    return handler.next(err);
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshingAccessToken != null) {
      return _refreshingAccessToken!;
    }

    final storage = Get.find<AppStorage>();
    final refreshToken = storage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final completer = Completer<String?>();
    _refreshingAccessToken = completer.future;

    try {
      final dioClient = Get.find<DioClient>();
      final response = await dioClient.dio.post(
        '/api/auth/token/refresh',
        queryParameters: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode != 200) {
        completer.complete(null);
        return _refreshingAccessToken;
      }

      final data = response.data;
      final token = (data is Map)
          ? (data['token']?.toString() ?? data['accessToken']?.toString() ?? '')
          : '';

      if (token.isEmpty) {
        completer.complete(null);
        return _refreshingAccessToken;
      }

      await storage.saveToken(token);
      completer.complete(token);
      return _refreshingAccessToken;
    } catch (_) {
      completer.complete(null);
      return _refreshingAccessToken;
    } finally {
      _refreshingAccessToken = null;
    }
  }

  Future<FormData> _recreateFormData(FormData original) async {
    final formDataMap = <String, dynamic>{};
    List<MultipartFile> multipartFiles = [];

    for (final field in original.fields) {
      formDataMap[field.key] = field.value;
    }

    for (final file in original.files) {
      final multipartFile = file.value;
      if (multipartFile != null) {
        final content = await file.value.clone().finalize().toList();
        final fileBytes = content.expand((e) => e).toList();

        final fileToUpload = MultipartFile.fromBytes(
          fileBytes,
          filename: multipartFile.filename,
          contentType: multipartFile.contentType,
        );

        multipartFiles.add(fileToUpload);
        formDataMap[file.key] = multipartFiles;
      }
    }

    return FormData.fromMap(formDataMap);
  }
}

Future<void> jwtLogout() async {
  await Get.find<NetworkStateService>().triggerLogout();
}
