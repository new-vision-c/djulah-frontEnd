import 'package:get/get.dart';
import '../../datas/local_storage/app_storage.dart';
import '../../infrastructure/navigation/route_names.dart';

/// Service qui gère l'état d'authentification au démarrage de l'app
class AuthStateService {
  final AppStorage _storage = Get.find<AppStorage>();

  /// Détermine la route initiale en fonction de l'état d'authentification
  String getInitialRoute() {
    // Vérifier si le token est valide (non expiré)
    if (_storage.isTokenValid) {
      print('✅ Token valide trouvé - Redirection vers splash animé puis dashboard');
      return RouteNames.clientSplashScreenCustom2;
    }
    
    print('❌ Aucun token valide - Affichage du splash avec options login/register');
    return RouteNames.clientSplashScreenCustom;
  }

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated => _storage.isTokenValid;

  /// Déconnexion complète (supprime tous les tokens)
  Future<void> logout() async {
    await _storage.clearAuth();
    print('🔓 Déconnexion - Tous les tokens supprimés');
  }
}
