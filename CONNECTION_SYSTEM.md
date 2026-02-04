# Système Global de Connexion

## Vue d'ensemble

Application "Online-Only" avec gestion globale et immédiate de la connexion via un overlay visible sur toutes les vues.

## Architecture

### Service Principal : `ConnectionService`

**Localisation**: `lib/infrastructure/network/connection_service.dart`

#### Deux états distincts :

1. **`hasInternet`** - Connexion internet (détection immédiate via `internet_connection_checker_plus`)
2. **`isServerReachable`** - Serveur backend accessible (via `/api/health`)

#### Fonctionnement :

```dart
// Détection internet en temps réel
_internetChecker.onStatusChange.listen((status) {
  hasInternet.value = status == InternetStatus.connected;
});

// Vérification serveur toutes les 60 secondes
Timer.periodic(Duration(seconds: 60), (_) => checkServerHealth());
```

### Widget : `LoadingOverlay`

**Localisation**: `lib/presentation/components/loading_overlay.widget.dart`

Appliqué via le `builder` de `GetMaterialApp` pour couvrir TOUTES les pages :

```dart
GetMaterialApp(
  builder: (context, child) => LoadingOverlay(child: child ?? SizedBox.shrink()),
)
```

## États de Connexion

```dart
enum ConnectionProblem {
  none,           // Tout fonctionne
  checking,       // Vérification en cours
  noInternet,     // Pas de connexion internet
  serverUnreachable, // Internet OK mais serveur ne répond pas
}
```

## Écrans d'Erreur

### Pas de connexion internet (Rouge)
- Icône : `wifi_off`
- Message : Vérifier Wi-Fi/données mobiles
- Bouton : Réessayer

### Serveur inaccessible (Orange)
- Icône : `cloud_off`  
- Message : Timeout ou erreur serveur
- Bouton : Réessayer

## Initialisation

L'ordre d'initialisation dans `main_client.dart` / `main_pro.dart` :

```dart
// 1. DioClient en premier
Get.put<DioClient>(DioClient(), permanent: true);

// 2. ConnectionService après (dépend de DioClient)
Get.put<ConnectionService>(ConnectionService(), permanent: true);
```

## Utilisation

Le système est automatique. Aucune action requise dans les vues.

Pour forcer une vérification :
```dart
Get.find<ConnectionService>().retryConnection();
```

Pour vérifier l'état :
```dart
final service = Get.find<ConnectionService>();
if (service.canUseApp) {
  // L'app peut fonctionner
}
```

## Dépendances

```yaml
dependencies:
  internet_connection_checker_plus: ^2.5.2
```