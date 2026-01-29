import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/components/loading_overlay.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/services/locale_service.dart';
import 'app/services/app_lifecycle_service.dart';
import 'app/services/profile_image_service.dart';
import 'datas/local_storage/app_storage.dart';
import 'datas/local_storage/local_storage_initializer.dart';
import 'datas/local_storage/favorites_storage_service.dart';
import 'datas/local_storage/pending_messages_storage_service.dart';
import 'datas/local_storage/conversations_storage_service.dart';
import 'datas/local_storage/recently_viewed_storage_service.dart';
import 'datas/local_storage/sync_service.dart';
import 'generated/locales.g.dart';
import 'app/config/app_config.dart';
import 'config.dart';
import 'infrastructure/network/dio_client.dart';
import 'infrastructure/network/network_state.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/theme/client_theme.dart';
import 'infrastructure/ui/app_flushbar.dart';
import 'infrastructure/shared/app_enums.dart';

void main() async {
  final bootstrap = await _bootstrapClient();

  runApp( Main(bootstrap.initialRoute, bootstrap.translations));
}


class Main extends StatelessWidget {
  final String initialRoute;
  final AppTranslations translations;

  const Main(this.initialRoute, this.translations, {super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      child: LoadingOverlay(
        child: GetMaterialApp(
          title: AppConfig.appName,
          theme: ClientTheme.lightTheme,
          smartManagement: SmartManagement.full,
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
        ),
      ),
    );
  }

}

Future<({String initialRoute, AppTranslations translations})> _bootstrapClient() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.configure(
    appType: AppType.client,
    apiBaseUrl: ConfigEnvironments.getEnvironments()['url'] ?? '',
    appName: 'Djulah',
  );

  final appStorage = await AppStorage.init();
  Get.put<AppStorage>(appStorage, permanent: true);
  
  // Initialiser le stockage local (Hive + GetStorage)
  await LocalStorageInitializer.init();
  
  // Enregistrer les services de stockage local
  Get.put<FavoritesStorageService>(
    FavoritesStorageService(),
    permanent: true,
  );
  Get.put<PendingMessagesStorageService>(
    PendingMessagesStorageService(),
    permanent: true,
  );
  Get.put<ConversationsStorageService>(
    ConversationsStorageService(),
    permanent: true,
  );
  Get.put<RecentlyViewedStorageService>(
    RecentlyViewedStorageService(),
    permanent: true,
  );
  
  // Configuration des barres système - Status bar et navbar visibles
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  Get.put<NetworkStateService>(NetworkStateService(), permanent: true);

  final lifecycle = AppLifecycleService();
  lifecycle.init();
  Get.put<AppLifecycleService>(lifecycle, permanent: true);

  final localeService = await LocaleService.init();
  Get.put<LocaleService>(localeService, permanent: true);

  Get.put<DioClient>(DioClient(), permanent: true);

  Get.put<ProfileImageService>(ProfileImageService(), permanent: true);
  
  // Initialiser le service de synchronisation (après DioClient)
  Get.put<SyncService>(SyncServiceFactory.create(), permanent: true);

  Get.find<NetworkStateService>().registerHandlers(
    onBackendUnreachable: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        title: "Serveur inaccessible",
        message: 'Veuillez Vous rassurer que vous etez connecter.',
        type: MessageType.error,
      );
    },
    onUnauthorized: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        title: "Not authorize",
        message: 'Reconnexion requise.',
        type: MessageType.warning,
      );
    },
    onLocked: () {
      final ctx = Get.context;
      if (ctx == null) return;
      AppFlushBar.show(
        ctx,
        title: "Compte bloqué",
        message: 'Contacte le support.',
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

  // Tester la connexion au backend après un court délai (pour laisser l'app se charger)
  Future.delayed(const Duration(seconds: 2), () {
    Get.find<NetworkStateService>().checkBackendConnection();
  });

  final translations = await AppTranslations.load();

  return (
  initialRoute: RouteNames.clientSplashScreenCustom,
  translations: translations,
  );
}
