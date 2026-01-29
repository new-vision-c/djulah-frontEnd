# Guide d'Internationalisation - Djulah

## 📋 Vue d'ensemble

Ce projet utilise le système de localisation de **GetX** avec des fichiers JSON pour gérer les traductions en français et en anglais.

## 🗂️ Structure des fichiers

```
assets/locales/
├── fr.json  # Traductions françaises
└── en.json  # Traductions anglaises

lib/
├── generated/
│   └── locales.g.dart  # Gestionnaire de traductions (auto-généré)
└── app/services/
    └── locale_service.dart  # Service de gestion des locales
```

## 🎨 Centralisation des couleurs

Toutes les couleurs sont centralisées dans `lib/infrastructure/theme/client_theme.dart` :

```dart
// Couleurs principales
static const Color primaryColor = Color(0xFF1EABE2);
static const Color secondaryColor = Color(0xFFFFF800);
static const Color backgroundColor = Colors.white;
static const Color errorColor = Colors.red;

// Couleurs de texte
static const Color textPrimaryColor = Colors.black;
static const Color textSecondaryColor = Color(0xFF4B4B4B);
static const Color textTertiaryColor = Color(0xFF5E5E5E);
static const Color textDisabledColor = Color(0xFFA6A6A6);

// Couleurs d'input
static const Color inputBackgroundColor = Color(0xFFF3F3F3);
static const Color buttonDisabledColor = Color(0xFFF3F3F3);

// Couleurs du widget PinInput
static const Color pinInputBackground = Color(0xFFE8E8E8);
static const Color pinInputDotColor = Colors.black;
static const Color pinInputDotBorder = Colors.black;
```

### ✅ Utilisation dans le code

```dart
// ❌ Ne pas faire
Text('Bonjour', style: TextStyle(color: Color(0xFF4B4B4B)))

// ✅ Faire
Text('Bonjour', style: TextStyle(color: ClientTheme.textSecondaryColor))
```

## 🌍 Structure des traductions

Les traductions sont organisées par catégories dans `fr.json` et `en.json` :

### Catégories disponibles

- **common** : Textes communs (boutons, actions)
- **splash** : Écran de démarrage
- **auth** : Authentification et inscription
- **validation** : Messages de validation
- **verification** : Vérification d'identité

### Exemple de structure

```json
{
  "common": {
    "next": "Suivant",
    "send": "Envoyer",
    "resend": "Renvoyer"
  },
  "auth": {
    "welcome": "Bienvenue sur Djulah",
    "email": "Email",
    "password": "Mot de passe"
  }
}
```

## 💻 Utilisation dans le code

### 1. Traduction simple

```dart
// Afficher une traduction
Text('auth.welcome'.tr)  // "Bienvenue sur Djulah" (fr) / "Welcome to Djulah" (en)
```

### 2. Traduction avec paramètres

Pour les traductions dynamiques utilisant `{{count}}` ou autres variables :

```json
{
  "validation": {
    "passwordMinLength": "Le mot de passe doit contenir au moins {{count}} caractères"
  }
}
```

```dart
// Utiliser .trParams() pour passer des paramètres
Text(
  'validation.passwordMinLength'.trParams({
    'count': '8'
  })
)
```

### 3. Changer de langue

```dart
// Dans un controller ou widget
final localeService = Get.find<LocaleService>();

// Changer pour l'anglais
await localeService.setLocale(Locale('en', 'US'));

// Changer pour le français
await localeService.setLocale(Locale('fr', 'FR'));
```

## 📝 Ajouter de nouvelles traductions

### Étape 1 : Ajouter les clés dans les fichiers JSON

**fr.json :**
```json
{
  "mySection": {
    "myKey": "Mon texte en français"
  }
}
```

**en.json :**
```json
{
  "mySection": {
    "myKey": "My text in English"
  }
}
```

### Étape 2 : Utiliser dans le code

```dart
Text('mySection.myKey'.tr)
```

### Étape 3 : Hot reload

Pas besoin de recompiler ! Le hot reload suffira pour voir les nouvelles traductions.

## 🔧 Fonctionnement technique

Le système utilise `_flattenMap()` dans `locales.g.dart` pour aplatir automatiquement la structure JSON imbriquée :

```dart
{
  "auth": {
    "welcome": "Bienvenue"
  }
}
// Devient en interne
{
  "auth.welcome": "Bienvenue"
}
```

Cela permet d'utiliser la notation pointée : `'auth.welcome'.tr`

## 📱 Langues supportées

- 🇫🇷 **Français** (fr_FR) - Langue par défaut
- 🇬🇧 **Anglais** (en_US)

## ⚠️ Bonnes pratiques

1. **Toujours utiliser `.tr`** pour afficher du texte visible par l'utilisateur
2. **Organiser les clés par fonctionnalité** (auth, validation, etc.)
3. **Utiliser des noms de clés explicites** en anglais
4. **Tester dans les deux langues** avant de commit
5. **Utiliser `ClientTheme.xxx`** pour toutes les couleurs
6. **Ne jamais hardcoder** de couleurs avec `Color(0xFFxxxxxx)`

## 🎯 Clés de traduction actuelles

### Common
- `common.next` - Suivant / Next
- `common.send` - Envoyer / Send
- `common.resend` - Renvoyer / Resend
- `common.cancel` - Annuler / Cancel
- `common.confirm` - Confirmer / Confirm
- `common.continue` - Continuer / Continue
- `common.back` - Retour / Back

### Splash
- `splash.title`
- `splash.createAccount`
- `splash.signIn`
- `splash.continueWithoutAccount`

### Auth
- `auth.welcome`
- `auth.signupSubtitle`
- `auth.continueWithGoogle`
- `auth.continueWithApple`
- `auth.orContinueWithEmail`
- `auth.email`
- `auth.emailPlaceholder`
- `auth.username`
- `auth.usernamePlaceholder`
- `auth.password`
- `auth.passwordPlaceholder`
- `auth.alreadyHaveAccount`
- `auth.login`

### Validation
- `validation.emailRequired`
- `validation.emailInvalid`
- `validation.enterValidEmail`
- `validation.passwordMinLength` (avec paramètre `{{count}}`)

### Verification
- `verification.title`
- `verification.subtitle`
- `verification.subtitleSecure`
- `verification.codeLabel`
- `verification.resendIn`
- `verification.timerComplete`
- `verification.timerCompleteMessage`

---

**Dernière mise à jour :** 4 janvier 2026
