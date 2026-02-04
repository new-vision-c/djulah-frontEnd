# PasswordField Widget

Widget centralisé pour tous les champs de mot de passe de l'application.

## Caractéristiques

- ✅ Validation automatique de la longueur minimale (8 caractères par défaut)
- ✅ Validation de la complexité compatible avec le backend
- ✅ Vérifie qu'il y a au moins 2 types de caractères parmi :
  - Minuscules (a-z)
  - Majuscules (A-Z)
  - Chiffres (0-9)
  - Caractères spéciaux
- ✅ Toggle visibilité du mot de passe (icône œil)
- ✅ Style cohérent avec le thème de l'application
- ✅ Support des traductions (i18n)

## Utilisation de base

```dart
import 'package:djulah/presentation/components/password_field.widget.dart';

// Dans votre controller
class MyController extends GetxController {
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final password = ''.obs;
}

// Dans votre widget
PasswordField(
  controller: controller.passwordController,
  isPasswordVisible: controller.isPasswordVisible,
  passwordValue: controller.password,
  label: 'auth.password'.tr,
  hintText: 'auth.passwordPlaceholder'.tr,
)
```

## Exemple d'intégration dans Login

```dart
import 'package:djulah/presentation/components/password_field.widget.dart';

// Remplacer tout le bloc TextField de mot de passe par :
PasswordField(
  controller: controller.passwordController,
  isPasswordVisible: controller.isPasswordVisible,
  passwordValue: controller.password,
  label: 'auth.password'.tr,
  hintText: 'auth.passwordPlaceholder'.tr,
  onChanged: (password) {
    controller.password.value = password;
  },
)

// La validation du formulaire devient plus simple :
bool get isFormValid => 
  GetUtils.isEmail(email.value) &&
  PasswordField.validatePassword(password.value) == null;
```

## Options avancées

```dart
PasswordField(
  controller: controller.passwordController,
  isPasswordVisible: controller.isPasswordVisible,
  passwordValue: controller.password,
  label: 'auth.newPassword'.tr,
  
  // Désactiver l'affichage de la validation en temps réel
  showValidation: false,
  
  // Désactiver la vérification de complexité (seulement longueur)
  validateComplexity: false,
  
  // Callback personnalisé
  onChanged: (password) {
    // Votre logique
  },
)
```

## Validation manuelle

Vous pouvez utiliser la méthode statique `validatePassword` pour valider manuellement :

```dart
String? error = PasswordField.validatePassword(
  password,
  checkComplexity: true,
  minLength: 8,
);

if (error != null) {
  print('Erreur: $error');
}
```

## Messages d'erreur

Les messages sont définis dans `assets/locales/fr.json` :

- `validation.passwordMinLength` : "Le mot de passe doit contenir au moins @count caractères"
- `validation.passwordComplexity` : "Le mot de passe doit contenir au moins 2 types de caractères différents (minuscules, majuscules, chiffres, caractères spéciaux)"

## Migration depuis l'ancien code

### Avant
```dart
Obx(() {
  return TextField(
    controller: controller.passwordController,
    obscureText: !controller.isPasswordVisible.value,
    onChanged: (password) => controller.password.value = password,
    decoration: InputDecoration(
      errorText: controller.password.isEmpty
          ? null
          : controller.password.value.length < 8
          ? 'validation.passwordMinLength'.trParams({'count': '8'})
          : null,
      // ... beaucoup de code de style ...
    ),
  );
})
```

### Après
```dart
PasswordField(
  controller: controller.passwordController,
  isPasswordVisible: controller.isPasswordVisible,
  passwordValue: controller.password,
  label: 'auth.password'.tr,
)
```

## Validation Backend

Le widget est 100% compatible avec la validation du backend qui retourne :
```json
{
  "message": "Le mot de passe doit contenir au moins 2 types de caractères différents (minuscules, majuscules, chiffres, caractères spéciaux)",
  "path": ["password"],
  "type": "custom.passwordComplexity"
}
```
