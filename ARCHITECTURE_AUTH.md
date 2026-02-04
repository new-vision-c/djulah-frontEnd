# Architecture d'Authentification - Djulah

## 📋 Vue d'ensemble

L'architecture suit un pattern en couches inspiré de votre projet précédent, garantissant une séparation claire des responsabilités.

```
Controller → Service → Repository → API
```

## 🏗️ Structure des Couches

### 1. **Controller** (`presentation/`)
- Gère l'interface utilisateur et les interactions
- Appelle les services métier
- Affiche les messages de succès/erreur
- Exemple: `InscriptionController`

### 2. **Service** (`infrastructure/services/`)
- Couche intermédiaire entre le contrôleur et le repository
- Contient la logique métier
- Initialise et utilise les repositories
- Exemple: `AuthService`

### 3. **Repository** (`domain/repositories/`)
- Effectue les appels HTTP via Dio
- Gère les codes de statut HTTP
- Retourne des entités avec statut
- Exemple: `AuthRepository`

### 4. **Entity** (`domain/entities/`)
- Modèles de données métier
- Wrapper avec statut pour la gestion d'erreurs
- Exemple: `RegisterStep1Entity`, `RegisterStep1EntityWithStatus`

### 5. **Enum** (`domain/enums/`)
- Définit les différents statuts possibles
- Exemple: `RegisterStatus`

## 🔐 Gestion des Tokens

Les tokens sont stockés de manière sécurisée via `AppStorage` qui utilise `EncryptedSharedPreferences`:

```dart
// Sauvegarde du token après une inscription réussie
await Get.find<AppStorage>().saveToken(token);

// Récupération du token
final token = Get.find<AppStorage>().token;

// Suppression du token
await Get.find<AppStorage>().removeToken();
```

## 🔄 Flux d'Inscription (Step 1)

### Étape par Étape

1. **Utilisateur remplit le formulaire**
   - Email, nom complet, mot de passe

2. **Controller (`InscriptionController.goToVerificationEmail()`)**
   - Valide les données
   - Appelle `AuthService().registerStep1()`

3. **Service (`AuthService.registerStep1()`)**
   - Transmet la requête au repository

4. **Repository (`AuthRepository.registerStep1()`)**
   - Appelle l'API via Dio
   - Endpoint: `GET /api/auth/client/register/step1`
   - Analyse le code de statut HTTP
   - Retourne `RegisterStep1EntityWithStatus`

5. **Intercepteur JWT (`JwtInterceptor`)**
   - Intercepte automatiquement la réponse
   - Sauvegarde le token si présent
   - Gère les erreurs 401, 500, etc.

6. **Controller (suite)**
   - Reçoit `RegisterStep1EntityWithStatus`
   - Évalue le `RegisterStatus`
   - Sauvegarde le token dans `AppStorage`
   - Affiche un message approprié
   - Navigue vers la vérification OTP si succès

## 📊 Codes de Statut

### RegisterStatus
```dart
enum RegisterStatus {
  SUCCESS,                  // Inscription réussie
  ERROR,                    // Erreur générique
  LOCK,                     // Compte bloqué
  API_ERROR,                // Erreur API inattendue
  TIMEOUT,                  // Délai d'attente dépassé
  INVALID_CREDENTIALS,      // Données invalides
  EMAIL_ALREADY_EXISTS,     // Email déjà utilisé
  UNAUTHORIZED              // Non autorisé
}
```

## 🌐 Configuration API

### Base URL
Configurée dans `config.dart`:
```dart
{
  'env': Environments.PRODUCTION,
  'url': 'https://manager-api-d5ty.onrender.com/',
}
```

## 📝 Exemple d'Utilisation

### Dans le Controller

```dart
Future<void> goToVerificationEmail() async {
  AppConfig.isLoadingApp.value = true;

  try {
    // Appel du service
    final result = await AuthService().registerStep1(
      email: email.value,
      fullname: name.value,
      password: password.value,
    );

    AppConfig.isLoadingApp.value = false;

    // Gestion des statuts
    if (result.registerStatus == RegisterStatus.SUCCESS && result.entity != null) {
      final entity = result.entity!;
      
      // Sauvegarder le token
      if (entity.data != null && entity.data!.token.isNotEmpty) {
        await Get.find<AppStorage>().saveToken(entity.data!.token);
      }

      // Afficher un message
      AppFlushBar.show(
        context,
        message: entity.data?.message ?? entity.message,
        type: MessageType.success,
      );

      // Naviguer
      Get.toNamed(RouteNames.clientVerificationIdentity, arguments: {...});
    }
    else if (result.registerStatus == RegisterStatus.EMAIL_ALREADY_EXISTS) {
      // Gérer l'erreur
    }
    // ... autres cas
  } catch (e) {
    // Gérer l'exception
  }
}
```

## 🛡️ Sécurité

- **Tokens chiffrés**: Utilisation de `EncryptedSharedPreferences`
- **Intercepteur JWT**: Gestion automatique de l'authentification
- **Refresh automatique**: Via `JwtInterceptor`
- **Timeout**: 60 secondes pour les requêtes

## 🔍 Debugging

### Logs Repository
```dart
print("Response status: ${response.statusCode}");
print("Response data: ${response.data}");
```

### Logs Intercepteur
Les logs sont automatiques dans `JwtInterceptor`:
- Codes de statut HTTP
- Messages d'erreur
- Tentatives de refresh token

## 📦 Fichiers Créés/Modifiés

### Nouveaux fichiers:
- `lib/domain/enums/register_status.dart`
- `lib/domain/entities/auth/register_step1_entity.dart`
- `lib/infrastructure/services/auth_service.dart`

### Fichiers modifiés:
- `lib/config.dart` - Base URL production
- `lib/domain/repositories/auth_repository.dart` - Architecture en couches
- `lib/presentation/client/inscription/controllers/inscription.controller.dart` - Utilisation du service

## ✅ Avantages de cette Architecture

1. **Séparation des préoccupations**: Chaque couche a une responsabilité unique
2. **Testabilité**: Facile de tester chaque couche indépendamment
3. **Maintenabilité**: Code organisé et facile à comprendre
4. **Réutilisabilité**: Services et repositories réutilisables
5. **Gestion d'erreurs robuste**: Status pattern pour gérer tous les cas
6. **Sécurité**: Tokens chiffrés et gérés automatiquement

## 🚀 Prochaines Étapes

Pour ajouter de nouveaux endpoints d'authentification:

1. Créer l'enum de statut dans `domain/enums/`
2. Créer l'entité dans `domain/entities/auth/`
3. Ajouter la méthode dans `AuthRepository`
4. Ajouter la méthode dans `AuthService`
5. Utiliser le service dans le contrôleur

## 📚 Références

- Dio: https://pub.dev/packages/dio
- GetX: https://pub.dev/packages/get
- EncryptedSharedPreferences: https://pub.dev/packages/encrypt_shared_preferences
