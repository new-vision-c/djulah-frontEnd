import '../../infrastructure/shared/app_enums.dart';
import 'package:get/get.dart';

class AppConfig {
  static late AppType appType;
  static late String apiBaseUrl;
  static late String appName;
  static RxBool isLoadingApp = false.obs;
  static RxString loadingMessage = ''.obs;
  static Rx<LoadingPosition> loadingPosition = LoadingPosition.center.obs;
  static RxInt limitCharPassword = 8.obs;
  
  // Timeout réseau commun (en secondes)
  static const int networkTimeoutSeconds = 30;
  static const Duration networkTimeout = Duration(seconds: networkTimeoutSeconds);

  static void showLoading({String? message, LoadingPosition position = LoadingPosition.center}) {
    isLoadingApp.value = true;
    loadingMessage.value = message ?? '';
    loadingPosition.value = position;
  }

  static void hideLoading() {
    isLoadingApp.value = false;
    loadingMessage.value = '';
    loadingPosition.value = LoadingPosition.center;
  }

  static void configure({
    required AppType appType,
    required String apiBaseUrl,
    required String appName,
  }) {
    AppConfig.appType = appType;
    AppConfig.apiBaseUrl = apiBaseUrl;
    AppConfig.appName = appName;
  }

  static bool get isClient => appType == AppType.client;
  static bool get isPro => appType == AppType.pro;
}