import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../app/config/app_config.dart';
import 'dio_client.dart';
import 'network_state.dart';

/// Service global de gestion de la connexion internet
/// 
/// Gère uniquement la connexion internet :
/// - [hasInternet] : Connexion internet disponible
///   → Vérifié automatiquement toutes les 30s par internet_connection_checker_plus
///   → Léger, ne sollicite PAS votre serveur
/// 
/// Note : La disponibilité du serveur est vérifiée implicitement par chaque requête
/// via son timeout (30s). Pas besoin de vérification /api/health séparée.
class ConnectionService extends GetxService {
  // ==================== ÉTATS OBSERVABLES ====================
  
  /// État de la connexion internet (détection immédiate)
  final RxBool hasInternet = true.obs;
  
  /// Vérification en cours
  final RxBool isChecking = false.obs;
  
  /// Message d'état actuel
  final RxString statusMessage = ''.obs;
  
  /// Flag pour éviter le flash au démarrage
  final RxBool _initialized = false.obs;
  
  // ==================== INTERNET CHECKER ====================
  
  late final InternetConnection _internetChecker;
  StreamSubscription<InternetStatus>? _internetSubscription;
  
  // ==================== HEALTH CHECK ====================
  
  Timer? _healthCheckTimer;
  late Dio _dio;
  
  // ==================== LIFECYCLE ====================
  
  @override
  void onInit() {
    super.onInit();
    _setupInternetChecker();
    _setupDio();
    _startHealthCheck();
    
    // Première vérification après un court délai
    Future.delayed(const Duration(milliseconds: 300), () {
      _performInitialCheck();
    });
  }

  @override
  void onClose() {
    _internetSubscription?.cancel();
    _healthCheckTimer?.cancel();
    super.onClose();
  }
  
  // ==================== SETUP ====================
  
  void _setupInternetChecker() {
    // Configuration similaire à votre exemple
    _internetChecker = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 30),
      useDefaultOptions: false,
      customCheckOptions: [
        InternetCheckOption(
          timeout: const Duration(seconds: 5),
          uri: Uri.parse('https://www.google.com'),
        ),
        InternetCheckOption(
          timeout: const Duration(seconds: 5),
          uri: Uri.parse('https://www.cloudflare.com'),
        ),
      ],
    );
    
    // Écouter les changements de connexion internet EN TEMPS RÉEL
    _internetSubscription = _internetChecker.onStatusChange.listen(
      _onInternetStatusChanged,
    );
  }
  
  void _setupDio() {
    try {
      _dio = Get.find<DioClient>().getDio();
    } catch (e) {
      // Fallback si DioClient pas encore disponible
      _dio = Dio(BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.networkTimeout,
        receiveTimeout: AppConfig.networkTimeout,
      ));
    }
  }
  
  void _startHealthCheck() {
    // Plus de vérification serveur /api/health
    // Chaque requête métier vérifie déjà la disponibilité via son timeout
  }
  
  Future<void> _performInitialCheck() async {
    isChecking.value = true;
    
    // Vérifier seulement internet
    hasInternet.value = await _internetChecker.hasInternetAccess;
    
    isChecking.value = false;
    _initialized.value = true;
  }
  
  // ==================== HANDLERS ====================
  
  void _onInternetStatusChanged(InternetStatus status) {
    final bool connected = status == InternetStatus.connected;
    hasInternet.value = connected;
    
    if (connected) {
      statusMessage.value = 'network.internetRestored'.tr;
    } else {
      statusMessage.value = 'network.noInternet'.tr;
    }
  }
  
  // ==================== VÉRIFICATIONS ====================
  
  /// Vérifie l'état de la connexion internet
  Future<bool> checkInternetAccess() async {
    final result = await _internetChecker.hasInternetAccess;
    hasInternet.value = result;
    return result;
  }
  
  /// Force une vérification de la connexion internet
  Future<void> retryConnection() async {
    isChecking.value = true;
    statusMessage.value = 'network.checking'.tr;
    
    await checkInternetAccess();
    
    isChecking.value = false;
  }
  
  // ==================== GETTERS ====================
  
  /// L'application peut fonctionner (a internet)
  bool get canUseApp => hasInternet.value;
  
  /// L'overlay doit être affiché (après initialisation et pas d'internet)
  bool get shouldShowOverlay => _initialized.value && !hasInternet.value;
  
  /// Type de problème de connexion
  ConnectionProblem get currentProblem {
    if (isChecking.value) return ConnectionProblem.checking;
    if (!hasInternet.value) return ConnectionProblem.noInternet;
    return ConnectionProblem.none;
  }
}

/// Types de problèmes de connexion
enum ConnectionProblem {
  none,
  checking,
  noInternet,
}
