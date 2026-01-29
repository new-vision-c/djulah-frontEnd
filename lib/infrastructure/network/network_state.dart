import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../datas/local_storage/app_storage.dart';
import '../shared/app_enums.dart';
import 'dio_client.dart';

class NetworkStateService extends GetxService {
  final backendReachability = BackendReachability.unknown.obs;
  final accountStatus = AccountStatus.unknown.obs;

  void Function()? onBackendUnreachable;
  void Function()? onUnauthorized;
  void Function()? onLocked;
  void Function()? onLogout;
  void Function(String message, MessageType type)? onMessage;

  void registerHandlers({
    void Function()? onBackendUnreachable,
    void Function()? onUnauthorized,
    void Function()? onLocked,
    void Function()? onLogout,
    void Function(String message, MessageType type)? onMessage,
  }) {
    this.onBackendUnreachable = onBackendUnreachable;
    this.onUnauthorized = onUnauthorized;
    this.onLocked = onLocked;
    this.onLogout = onLogout;
    this.onMessage = onMessage;
  }

  void notifyMessage({
    required String message,
    required MessageType type,
  }) {
    onMessage?.call(message, type);
  }

  /// Test de connexion au backend
  Future<void> checkBackendConnection() async {
    try {
      final dio = Get.find<DioClient>().getDio();
      // Faire une requête simple de test (peut être un endpoint /health ou /ping)
      await dio.get('/health', options: Options(
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));
      markBackendReachable();
    } catch (e) {
      markBackendUnreachable();
    }
  }

  void markBackendReachable() {
    if (backendReachability.value == BackendReachability.reachable) return;
    backendReachability.value = BackendReachability.reachable;
  }

  void markBackendUnreachable() {
    if (backendReachability.value == BackendReachability.unreachable) {
      return;
    }
    backendReachability.value = BackendReachability.unreachable;
    onBackendUnreachable?.call();
  }

  void markAccountOk() {
    if (accountStatus.value == AccountStatus.ok) return;
    accountStatus.value = AccountStatus.ok;
  }

  void markUnauthorized() {
    if (accountStatus.value == AccountStatus.unauthorized) {
      return;
    }
    accountStatus.value = AccountStatus.unauthorized;
    onUnauthorized?.call();
  }

  void markLocked() {
    if (accountStatus.value == AccountStatus.locked) {
      return;
    }
    accountStatus.value = AccountStatus.locked;
    onLocked?.call();
  }

  Future<void> triggerLogout() async {
    final storage = Get.find<AppStorage>();
    await storage.removeToken();
    await storage.removeRefreshToken();

    accountStatus.value = AccountStatus.unauthorized;
    onLogout?.call();
  }

  void updateFromBackendPayload(dynamic data) {
    if (data is! Map) return;

    final code = data['code']?.toString().toUpperCase();
    final status = data['status']?.toString().toUpperCase();

    if (code == null && status == null) return;

    if (code == 'ACCOUNT_LOCKED' || code == 'LOCKED' || status == 'LOCKED') {
      markLocked();
      return;
    }

    if (code == 'UNAUTHORIZED' || status == 'UNAUTHORIZED') {
      markUnauthorized();
      return;
    }
  }
}
