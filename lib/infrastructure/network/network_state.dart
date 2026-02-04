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

  Future<void> checkBackendConnection() async {
    try {
      final dio = Get.find<DioClient>().getDio();
      final response = await dio.get('/api/health', options: Options(
        extra: {'skip_auth': true},
      ));
      markBackendReachable();
      
      if (response.data is Map) {
        final data = response.data as Map;
        final services = data['services'] as Map?;
        
        if (services != null) {
          final apiStatus = services['api']?['status'] ?? 'unknown';
          final redisStatus = services['redis']?['status'] ?? 'unknown';
          final cloudinaryStatus = services['cloudinary']?['status'] ?? 'unknown';
          final dbStatus = services['database']?['status'] ?? 'unknown';
          
          final message = 'network.backendConnected'.tr + '\n'
              'API: $apiStatus | Redis: $redisStatus\n'
              'Cloudinary: $cloudinaryStatus | DB: $dbStatus';
          onMessage?.call(message, MessageType.success);
        }
      }
    } catch (e) {
      markBackendUnreachable();      onMessage?.call(
        'network.serverUnavailable'.tr,
        MessageType.error,
      );    }
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
