# Intégration des Endpoints d'Authentification

## ✅ Endpoints Implémentés

Tous les endpoints d'authentification client du backend sont maintenant intégrés dans le frontend Flutter.

### 📁 Structure des fichiers créés

```
lib/
├── domain/
│   ├── entities/auth/
│   │   ├── user_data.dart ✅ (Classe commune réutilisée)
│   │   ├── register_step1_entity.dart ✅
│   │   ├── verify_otp_entity.dart ✅
│   │   ├── login_entity.dart ✅
│   │   ├── resend_otp_entity.dart ✅
│   │   ├── complete_registration_entity.dart ✅
│   │   ├── forgot_password_entity.dart ✅
│   │   ├── reset_password_entity.dart ✅
│   │   └── me_entity.dart ✅
│   ├── enums/
│   │   ├── register_status.dart ✅
│   │   └── auth_status.dart ✅
│   └── repositories/
│       └── auth_repository.dart ✅ (mis à jour)
└── infrastructure/
    └── services/
        └── auth_service.dart ✅ (mis à jour)
```

### 🎯 Points clés de l'architecture

1. **UserData commune** : Une seule classe `UserData` est définie dans `user_data.dart` et réutilisée par toutes les entités auth (verify-otp, login, me). Cela évite la duplication de code et assure la cohérence.

2. **Types de retour explicites** : Toutes les méthodes du repository utilisent des tuples nommés avec types explicites pour éviter les erreurs de type :
   ```dart
   Future<({LoginEntity? entity, LoginStatus status})> login(...)
   Future<({String? message, ApiStatus status})> logout(...)
   ```

3. **Gestion des erreurs robuste** : Chaque méthode gère les cas d'erreur spécifiques (401, 403, 404, etc.) et retourne des statuts appropriés.

---

## 🔐 1. Inscription (Register)

### Étape 1 : Email et mot de passe
```dart
final authService = AuthService();

final result = await authService.registerStep1(
  email: 'user@example.com',
  fullname: 'Jean Dupont',
  password: 'SecurePass123!',
);

if (result.registerStatus == RegisterStatus.SUCCESS) {
  print('Inscription réussie, email: ${result.entity?.email}');
  // Rediriger vers la page de vérification OTP
}
```

### Étape 2 : Vérification OTP
```dart
final result = await authService.verifyOtp(
  email: 'user@example.com',
  otp: '123456',
);

if (result.status == VerifyOtpStatus.SUCCESS) {
  // Sauvegarder les tokens
  final accessToken = result.entity?.accessToken;
  final refreshToken = result.entity?.refreshToken;
  final user = result.entity?.user;
  
  print('OTP vérifié, utilisateur: ${user?.fullname}');
  // Rediriger vers la page principale
}
```

### Renvoyer l'OTP
```dart
final result = await authService.resendOtp(
  email: 'user@example.com',
);

if (result.status == ApiStatus.SUCCESS) {
  print('OTP renvoyé avec succès');
  // Afficher un message de confirmation
}
```

### Étape 3 : Compléter l'inscription (optionnel)
```dart
final result = await authService.completeRegistration(
  email: 'user@example.com',
  phoneNumber: '+33612345678',
  address: '123 Rue de la Paix',
  city: 'Paris',
  country: 'France',
);

if (result.status == ApiStatus.SUCCESS) {
  print('Profil complété');
}
```

---

## 🔑 2. Connexion (Login)

```dart
final result = await authService.login(
  email: 'user@example.com',
  password: 'SecurePass123!',
);

switch (result.status) {
  case LoginStatus.SUCCESS:
    // Sauvegarder les tokens
    final accessToken = result.entity?.accessToken;
    final refreshToken = result.entity?.refreshToken;
    final user = result.entity?.user;
    
    // Sauvegarder dans le storage
    await storage.saveToken(accessToken);
    await storage.saveRefreshToken(refreshToken);
    
    // Rediriger vers la page principale
    break;
    
  case LoginStatus.INVALID_CREDENTIALS:
    // Afficher "Email ou mot de passe incorrect"
    break;
    
  case LoginStatus.ACCOUNT_LOCKED:
    // Afficher "Compte bloqué, contactez le support"
    break;
    
  case LoginStatus.NOT_VERIFIED:
    // Rediriger vers la page de vérification
    break;
    
  case LoginStatus.ERROR:
    // Afficher une erreur générique
    break;
}
```

---

## 🚪 3. Déconnexion (Logout)

```dart
final result = await authService.logout();

if (result.status == ApiStatus.SUCCESS) {
  // Supprimer les tokens du storage
  await storage.removeToken();
  await storage.removeRefreshToken();
  
  // Rediriger vers la page de connexion
  Get.offAllNamed(RouteNames.clientLogin);
}
```

---

## 👤 4. Obtenir le profil utilisateur

```dart
final result = await authService.getMe();

if (result.status == ApiStatus.SUCCESS) {
  final user = result.entity?.user;
  print('Utilisateur: ${user?.fullname}');
  print('Email: ${user?.email}');
  print('Vérifié: ${user?.isVerified}');
}
```

---

## 🔄 5. Réinitialisation de mot de passe

### Étape 1 : Demander la réinitialisation
```dart
final result = await authService.forgotPassword(
  email: 'user@example.com',
);

switch (result.status) {
  case ForgotPasswordStatus.SUCCESS:
    print('Email de réinitialisation envoyé');
    // Afficher un message de confirmation
    break;
    
  case ForgotPasswordStatus.EMAIL_NOT_FOUND:
    print('Email non trouvé');
    break;
    
  case ForgotPasswordStatus.ERROR:
    print('Erreur lors de l\'envoi');
    break;
}
```

### Étape 2 : Vérifier le token (optionnel)
```dart
final result = await authService.verifyResetToken(
  token: 'token_from_email',
);

if (result.isValid) {
  print('Token valide, afficher le formulaire de réinitialisation');
} else {
  print('Token invalide ou expiré');
}
```

### Étape 3 : Réinitialiser le mot de passe
```dart
final result = await authService.resetPassword(
  token: 'token_from_email',
  newPassword: 'NewSecurePass123!',
);

switch (result.status) {
  case ResetPasswordStatus.SUCCESS:
    print('Mot de passe réinitialisé');
    // Rediriger vers la page de connexion
    break;
    
  case ResetPasswordStatus.INVALID_TOKEN:
    print('Token invalide');
    break;
    
  case ResetPasswordStatus.TOKEN_EXPIRED:
    print('Token expiré, demandez un nouveau lien');
    break;
    
  case ResetPasswordStatus.ERROR:
    print('Erreur lors de la réinitialisation');
    break;
}
```

---

## 📋 Exemple d'utilisation dans un Controller

```dart
class LoginController extends GetxController {
  final authService = AuthService();
  final storage = Get.find<AppStorage>();
  
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      AppFlushBar.show(
        Get.context!,
        message: 'Veuillez remplir tous les champs',
        type: MessageType.error,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await authService.login(
        email: email.value,
        password: password.value,
      );

      switch (result.status) {
        case LoginStatus.SUCCESS:
          // Sauvegarder les tokens
          await storage.saveToken(result.entity!.accessToken);
          await storage.saveRefreshToken(result.entity!.refreshToken);
          
          AppFlushBar.show(
            Get.context!,
            message: 'Connexion réussie',
            type: MessageType.success,
          );
          
          // Rediriger
          Get.offAllNamed(RouteNames.clientHome);
          break;

        case LoginStatus.INVALID_CREDENTIALS:
          AppFlushBar.show(
            Get.context!,
            message: 'Email ou mot de passe incorrect',
            type: MessageType.error,
          );
          break;

        case LoginStatus.ACCOUNT_LOCKED:
          AppFlushBar.show(
            Get.context!,
            message: 'Compte bloqué',
            type: MessageType.error,
          );
          break;

        default:
          AppFlushBar.show(
            Get.context!,
            message: 'Erreur de connexion',
            type: MessageType.error,
          );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## 🎯 Statuts disponibles

### RegisterStatus
- `SUCCESS` - Inscription réussie
- `ERROR` - Erreur lors de l'inscription

### VerifyOtpStatus
- `SUCCESS` - OTP valide
- `ERROR` - Erreur
- `INVALID_OTP` - OTP incorrect
- `EXPIRED_OTP` - OTP expiré

### LoginStatus
- `SUCCESS` - Connexion réussie
- `ERROR` - Erreur générique
- `INVALID_CREDENTIALS` - Identifiants incorrects
- `ACCOUNT_LOCKED` - Compte bloqué
- `NOT_VERIFIED` - Compte non vérifié

### ForgotPasswordStatus
- `SUCCESS` - Email envoyé
- `ERROR` - Erreur
- `EMAIL_NOT_FOUND` - Email non trouvé

### ResetPasswordStatus
- `SUCCESS` - Mot de passe réinitialisé
- `ERROR` - Erreur
- `INVALID_TOKEN` - Token invalide
- `TOKEN_EXPIRED` - Token expiré

### ApiStatus (générique)
- `SUCCESS` - Succès
- `ERROR` - Erreur
- `NETWORK_ERROR` - Erreur réseau

---

## 🚀 Prochaines étapes

Pour intégrer d'autres endpoints (properties, conversations, etc.), suivez le même pattern :

1. **Créer les entités** dans `domain/entities/`
2. **Créer les enums** pour les statuts dans `domain/enums/`
3. **Ajouter les méthodes** dans `domain/repositories/`
4. **Exposer via un service** dans `infrastructure/services/`
5. **Utiliser dans les controllers** de présentation

Tous les endpoints d'authentification client sont maintenant prêts à être utilisés ! 🎉
