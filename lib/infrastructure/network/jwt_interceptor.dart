import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../../app/config/app_config.dart';
import '../../datas/local_storage/app_storage.dart';
import '../ui/app_flushbar.dart';
import 'dio_client.dart';
import 'network_state.dart';
import '../shared/app_enums.dart';

class JwtInterceptor extends Interceptor {
  static Future<String?>? _refreshingAccessToken;
  
  /// Helper pour afficher un message seulement si l'app n'est pas en loading
  /// Évite les messages d'erreur pendant le chargement (le controller gère ça)
  static void _showMessageIfNotLoading(
    BuildContext context, {
    required String message,
    required MessageType type,
    String title = "",
  }) {
    // Ne pas afficher si l'app est en mode loading
    // Le controller qui a lancé la requête va gérer l'erreur dans son finally
    if (AppConfig.isLoadingApp.value) {
      return;
    }
    
    AppFlushBar.show(
      context,
      message: message,
      type: type,
      title: title,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final storage = Get.find<AppStorage>();
    options.headers['Accept-Language'] = storage.languageHeaderValue;

    if (options.extra['skip_auth'] == true) {
      return handler.next(options);
    }

    // Routes auth qui nécessitent le JWT (pas le sessionToken)
    final jwtProtectedAuthRoutes = [
      '/me',
      '/update-profile',
      '/update-password',
      '/update-avatar',
      '/logout',
      '/location',
    ];
    
    // Vérifie si c'est une route auth protégée par JWT
    final isJwtProtectedAuthRoute = jwtProtectedAuthRoutes.any(
      (route) => options.path.contains(route)
    );

    if (!options.path.contains("/auth") || isJwtProtectedAuthRoute) {
      final token = storage.token;
      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    } else {
      // Pour les routes auth spécifiques qui ont besoin du sessionToken
      final sessionToken = storage.sessionToken;
      if (sessionToken != null && sessionToken.isNotEmpty) {
        // verify-otp: sessionToken dans le body
        if (options.path.contains('verify-otp')) {
          if (options.data is Map) {
            options.data['sessionToken'] = sessionToken;
          }
        }
        // resend-otp: sessionToken dans le header Authorization
        else if (options.path.contains('resend-otp')) {
          options.headers["Authorization"] = "Bearer $sessionToken";
        }
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
        message: 'network.serverError'.tr,
        type: MessageType.error,
      );
      
      // Afficher le message à l'utilisateur (seulement si pas en loading)
      final context = Get.context;
      if (context != null) {
        final data = response.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? 'network.serverError'.tr)
            : 'network.serverError'.tr;
        _showMessageIfNotLoading(
          context,
          message: message,
          type: MessageType.error,
        );
      }
      return handler.next(response);
    }
    else if (response.statusCode == HttpStatus.locked) {
      networkState.markLocked();
      print("Compte bloqué (423)");
      
      // Afficher le message à l'utilisateur (seulement si pas en loading)
      final context = Get.context;
      if (context != null) {
        final data = response.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? 'auth.accountLockedContact'.tr)
            : 'auth.accountLockedContact'.tr;
        _showMessageIfNotLoading(
          context,
          message: message,
          type: MessageType.error,
        );
      }
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

        final context = Get.context;
        
        if (statusCode != null && statusCode >= 500) {
          networkState.notifyMessage(
            message: message ?? 'network.serverError'.tr,
            type: MessageType.error,
          );
          
          // Afficher à l'utilisateur (seulement si pas en loading)
          if (context != null) {
            _showMessageIfNotLoading(
              context,
              message: message ?? 'network.serverError'.tr,
              type: MessageType.error,
            );
          }
        } else {
          // Erreurs 4xx (sauf 401 et 423 déjà gérés)
          if (context != null && statusCode != HttpStatus.unauthorized && statusCode != HttpStatus.locked) {
            _showMessageIfNotLoading(
              context,
              message: message ?? 'network.errorOccurred'.tr,
              type: MessageType.warning,
            );
          }
        }

        return handler.next(response);
      }

      networkState.markAccountOk();
      final data = response.data;
      String? accessToken;
      String? refreshToken;
      String? sessionToken;

      if (data is Map<String, dynamic>) {
        // Case 1: tokens at root level
        if (data.containsKey('accessToken') || data.containsKey('refreshToken')) {
          accessToken = data['accessToken']?.toString();
          refreshToken = data['refreshToken']?.toString();
        }
        // Case 2: token in data.token (for auth endpoints) - vérifier que c'est un String
        else if (data.containsKey('token') && data['token'] is String) {
          accessToken = data['token'] as String;
        }
        // Case 3: tokens nested under success.data
        else if (data['success'] is Map && (data['success']['data'] is Map)) {
          final inner = data['success']['data'] as Map;
          if (inner['accessToken'] is String) {
            accessToken = inner['accessToken'] as String;
          }
          if (inner['refreshToken'] is String) {
            refreshToken = inner['refreshToken'] as String;
          }
        }
        // Case 4: tokens nested under data.data (for register/login endpoints)
        else if (data.containsKey('data') && data['data'] is Map) {
          final inner = data['data'] as Map;
          
          // Pour register/step1: token est un String (sessionToken)
          if (response.requestOptions.path.contains('register/step1')) {
            if (inner['token'] is String) {
              sessionToken = inner['token'] as String;
            }
          } else {
            // Pour login et autres: chercher accessToken et refreshToken
            if (inner['accessToken'] is String) {
              accessToken = inner['accessToken'] as String;
            } else if (inner['token'] is String) {
              accessToken = inner['token'] as String;
            }
          }
          
          if (inner['refreshToken'] is String) {
            refreshToken = inner['refreshToken'] as String;
          }
        }
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await Get.find<AppStorage>().saveRefreshToken(refreshToken);
      }
      if (accessToken != null && accessToken.isNotEmpty) {
        await Get.find<AppStorage>().saveToken(accessToken);
        print("Token sauvegardé automatiquement par JwtInterceptor");
      }
      if (sessionToken != null && sessionToken.isNotEmpty) {
        await Get.find<AppStorage>().saveSessionToken(sessionToken);
        print("SessionToken sauvegardé automatiquement par JwtInterceptor");
      }

      return handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final networkState = Get.find<NetworkStateService>();
    final context = Get.context;

    // Gestion des erreurs de connexion (timeout, connection error)
    // CES ERREURS SONT CRITIQUES ET DOIVENT TOUJOURS ÊTRE AFFICHÉES
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      networkState.markBackendUnreachable();
      
      // Afficher TOUJOURS (ne pas vérifier isLoadingApp)
      if (context != null) {
        String message;
        if (err.type == DioExceptionType.connectionTimeout || 
            err.type == DioExceptionType.receiveTimeout) {
          // Timeout = serveur trop lent ou inaccessible
          message = 'network.serverUnavailable'.tr;
        } else {
          // Connection error = problème réseau
          message = 'network.connectionProblem'.tr;
        }
        AppFlushBar.show(
          context,
          message: message,
          type: MessageType.error,
        );
      }
    }

    final statusCode = err.response?.statusCode;
    
    if (statusCode == HttpStatus.unauthorized) {
      networkState.markUnauthorized();
      if (context != null) {
        _showMessageIfNotLoading(
          context,
          message: 'auth.sessionExpired'.tr,
          type: MessageType.warning,
        );
      }
    }
    
    if (statusCode == HttpStatus.locked) {
      networkState.markLocked();
      if (context != null) {
        final data = err.response?.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? 'auth.accountLocked'.tr)
            : 'auth.accountLocked'.tr;
        _showMessageIfNotLoading(
          context,
          message: message,
          type: MessageType.error,
        );
      }
    }

    if (statusCode != null && statusCode >= 500) {
      if (context != null) {
        final data = err.response?.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? 'network.serverError'.tr)
            : 'network.serverError'.tr;
        _showMessageIfNotLoading(
          context,
          message: message,
          type: MessageType.error,
        );
      }
    }

    if (statusCode != null && statusCode >= 400 && statusCode < 500 &&
        statusCode != HttpStatus.unauthorized && statusCode != HttpStatus.locked) {
      if (context != null) {
        final data = err.response?.data;
        final message = (data is Map)
            ? (data['message']?.toString() ?? data['error']?.toString() ?? 'network.invalidRequest'.tr)
            : 'network.invalidRequest'.tr;
        _showMessageIfNotLoading(
          context,
          message: message,
          type: MessageType.warning,
        );
      }
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
