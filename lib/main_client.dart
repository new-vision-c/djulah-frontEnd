import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/components/loading_overlay.widget.dart';
import 'package:djulah/infrastructure/network/connection_service.dart';
import 'package:djulah/infrastructure/services/auth_service.dart';
import 'package:djulah/app/services/profile_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/services/locale_service.dart';
import 'app/services/app_lifecycle_service.dart';
import 'app/services/profile_image_service.dart';
import 'app/services/auth_state_service.dart';
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
        builder: (context, child) {
          return LoadingOverlay(
            child: child ?? const SizedBox.shrink(),
          );
        },
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
  await LocalStorageInitializer.init();
  
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
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  // Configuration de la status bar pour le mode edge-to-edge
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Icônes sombres sur fond clair
      statusBarBrightness: Brightness.light, // iOS: contenu clair = icônes sombres
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  Get.put<NetworkStateService>(NetworkStateService(), permanent: true);

  final lifecycle = AppLifecycleService();
  lifecycle.init();
  Get.put<AppLifecycleService>(lifecycle, permanent: true);

  final localeService = await LocaleService.init();
  Get.put<LocaleService>(localeService, permanent: true);

  Get.put<DioClient>(DioClient(), permanent: true);

  // Initialiser le service de connexion global APRÈS DioClient
  Get.put<ConnectionService>(ConnectionService(), permanent: true);

  Get.put<ProfileImageService>(ProfileImageService(), permanent: true);
  Get.put<SyncService>(SyncServiceFactory.create(), permanent: true);
  final authStateService = AuthStateService();
  Get.put<AuthStateService>(authStateService, permanent: true);
  
  // Service d'authentification (utilisé par profil, sécurité, etc.)
  Get.put<AuthService>(AuthService(), permanent: true);
  
  // Service de cache du profil utilisateur
  Get.put<ProfileCacheService>(ProfileCacheService(), permanent: true);

  // Les handlers de NetworkStateService pour les messages utilisateur
  Get.find<NetworkStateService>().registerHandlers(
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

  // Déterminer la route initiale en fonction de l'état d'authentification
  final initialRoute = authStateService.getInitialRoute();

  return (
    initialRoute: initialRoute,
    translations: translations,
  );
}
