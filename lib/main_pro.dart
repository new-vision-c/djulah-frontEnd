import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/config/app_config.dart';
import 'app/services/locale_service.dart';
import 'app/services/app_lifecycle_service.dart';
import 'config.dart';
import 'datas/local_storage/app_storage.dart';
import 'generated/locales.g.dart';
import 'infrastructure/network/dio_client.dart';
import 'infrastructure/network/network_state.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/theme/pro_theme.dart';
import 'infrastructure/ui/app_flushbar.dart';
import 'infrastructure/shared/app_enums.dart';

void main() async {
  final bootstrap = await _bootstrapPro();
  runApp(Main(bootstrap.initialRoute, bootstrap.translations));
}


class Main extends StatelessWidget {
  final String initialRoute;
  final AppTranslations translations;
  Main(this.initialRoute, this.translations);

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    return GetMaterialApp(
      title: AppConfig.appName,
      theme: ProTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: Nav.routes,
      translations: translations,
      locale: localeService.currentLocale,
      fallbackLocale: LocaleService.fallbackLocale,
      supportedLocales: LocaleService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

Future<({String initialRoute, AppTranslations translations})> _bootstrapPro() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.configure(
    appType: AppType.pro,
    apiBaseUrl: ConfigEnvironments.getEnvironments()['url'] ?? '',
    appName: 'Djulah Host',
  );

  final appStorage = await AppStorage.init();
  Get.put<AppStorage>(appStorage, permanent: true);

  Get.put<NetworkStateService>(NetworkStateService(), permanent: true);

  final lifecycle = AppLifecycleService();
  lifecycle.init();
  Get.put<AppLifecycleService>(lifecycle, permanent: true);

  final localeService = await LocaleService.init();
  Get.put<LocaleService>(localeService, permanent: true);

  Get.put<DioClient>(DioClient(), permanent: true);

  Get.find<NetworkStateService>().registerHandlers(
    onBackendUnreachable: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        message: 'Backend inaccessible. Vérifie ta connexion.',
        type: MessageType.error,
      );
    },
    onUnauthorized: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        message: 'Session expirée. Reconnexion requise.',
        type: MessageType.warning,
      );
    },
    onLocked: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        message: 'Compte bloqué. Contacte le support.',
        type: MessageType.error,
      );
    },
    onLogout: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        message: 'Déconnexion.',
        type: MessageType.info,
      );
    },
    onMessage: (message, type) {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        message: message,
        type: type,
      );
    },
  );

  final translations = await AppTranslations.load();

  return (
  initialRoute: RouteNames.proTest,
  translations: translations,
  );
}


