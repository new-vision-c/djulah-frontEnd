import '../../infrastructure/shared/app_enums.dart';
import 'package:get/get.dart';

class AppConfig {
  static late AppType appType;
  static late String apiBaseUrl;
  static late String appName;
  // paddingAdaptationPixelPerfect =EdgeInsets.all(21.r),
  
  // Loading global de l'application
  static RxBool isLoadingApp = false.obs;
  static RxInt limitCharPassword = 8.obs;



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