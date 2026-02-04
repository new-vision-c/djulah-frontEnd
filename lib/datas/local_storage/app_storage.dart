import 'dart:async';
import 'dart:ui' as ui;

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/widgets.dart';

class AppStorage {
  static const _tokenKey = 'user_token';
  static const _tokenExpiryKey = 'user_token_expiry';
  static const _refreshTokenKey = 'refresh_token';
  static const _sessionTokenKey = 'session_token';
  static const _sessionTokenExpiryKey = 'session_token_expiry';
  static const _localeKey = 'app_locale';

  static const supportedLocales = <Locale>[
    Locale('fr', 'FR'),
    Locale('en', 'US'),
  ];

  static const fallbackLocale = Locale('fr', 'FR');

  final EncryptedSharedPreferences _storage;

  String? _token;
  DateTime? _tokenExpiry;
  String? _refreshToken;
  String? _sessionToken;
  DateTime? _sessionTokenExpiry;
  Locale _locale = fallbackLocale;

  AppStorage._(this._storage);

  static Completer<AppStorage>? _completer;

  static Future<AppStorage> init() async {
    if (_completer == null) {
      final completer = Completer<AppStorage>();
      _completer = completer;

      final key = "xxxxxxxxxxxxXXXX";
      await EncryptedSharedPreferences.initialize(key);
      final sharedPref = EncryptedSharedPreferences.getInstance();

      final storage = AppStorage._(sharedPref);
      await storage._load();

      completer.complete(storage);
    }

    return _completer!.future;
  }

  Future<void> _load() async {
    _token = await _storage.getString(_tokenKey);
    _refreshToken = await _storage.getString(_refreshTokenKey);
    _sessionToken = await _storage.getString(_sessionTokenKey);
    
    // Charger l'expiration du token
    final tokenExpiryString = await _storage.getString(_tokenExpiryKey);
    if (tokenExpiryString != null) {
      _tokenExpiry = DateTime.tryParse(tokenExpiryString);
      
      // Vérifier si le token a expiré
      if (_tokenExpiry != null && DateTime.now().isAfter(_tokenExpiry!)) {
        // Supprimer le token expiré
        await removeToken();
        print('Token expiré supprimé automatiquement');
      }
    }
    
    // Charger l'expiration du sessionToken
    final sessionExpiryString = await _storage.getString(_sessionTokenExpiryKey);
    if (sessionExpiryString != null) {
      _sessionTokenExpiry = DateTime.tryParse(sessionExpiryString);
      
      // Vérifier si le sessionToken a expiré
      if (_sessionTokenExpiry != null && DateTime.now().isAfter(_sessionTokenExpiry!)) {
        // Supprimer le sessionToken expiré
        await removeSessionToken();
        print('SessionToken expiré supprimé automatiquement');
      }
    }

    final savedLocale = await _storage.getString(_localeKey);
    if (savedLocale != null && savedLocale.isNotEmpty) {
      final parsed = _parseLocale(savedLocale);
      if (parsed != null) {
        _locale = parsed;
        return;
      }
    }

    final device = ui.PlatformDispatcher.instance.locale;
    _locale = _closestSupported(device) ?? fallbackLocale;
  }

  String? get token {
    // Vérifier si le token a expiré
    if (_token != null && _tokenExpiry != null) {
      if (DateTime.now().isAfter(_tokenExpiry!)) {
        // Token expiré, le supprimer et retourner null
        removeToken();
        return null;
      }
    }
    return _token;
  }
  
  bool get isTokenValid {
    return _token != null && 
           _tokenExpiry != null && 
           DateTime.now().isBefore(_tokenExpiry!);
  }
  String? get refreshToken => _refreshToken;
  
  String? get sessionToken {
    if (_sessionToken != null && _sessionTokenExpiry != null) {
      if (DateTime.now().isAfter(_sessionTokenExpiry!)) {
        removeSessionToken();
        return null;
      }
    }
    return _sessionToken;
  }
  
  Locale get locale => _locale;

  String get languageHeaderValue => _locale.languageCode;

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.setString(_tokenKey, token);
    
    _tokenExpiry = DateTime.now().add(Duration(days: 7));
    await _storage.setString(_tokenExpiryKey, _tokenExpiry!.toIso8601String());
    print('Token sauvegardé avec expiration: $_tokenExpiry');
  }

  Future<void> removeToken() async {
    _token = null;
    _tokenExpiry = null;
    await _storage.remove(_tokenKey);
    await _storage.remove(_tokenExpiryKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _storage.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> removeRefreshToken() async {
    _refreshToken = null;
    await _storage.remove(_refreshTokenKey);
  }

  Future<void> saveSessionToken(String sessionToken) async {
    _sessionToken = sessionToken;
    await _storage.setString(_sessionTokenKey, sessionToken);
    
    _sessionTokenExpiry = DateTime.now().add(Duration(days: 7));
    await _storage.setString(_sessionTokenExpiryKey, _sessionTokenExpiry!.toIso8601String());
    print('SessionToken sauvegardé avec expiration: ${_sessionTokenExpiry}');
  }

  Future<void> removeSessionToken() async {
    _sessionToken = null;
    _sessionTokenExpiry = null;
    await _storage.remove(_sessionTokenKey);
    await _storage.remove(_sessionTokenExpiryKey);
  }

  Future<void> clearAuth() async {
    await removeToken();
    await removeRefreshToken();
    await removeSessionToken();
  }

  Future<void> saveLocale(Locale locale) async {
    final next = _closestSupported(locale) ?? fallbackLocale;
    _locale = next;

    await _storage.setString(
      _localeKey,
      next.countryCode == null ? next.languageCode : '${next.languageCode}_${next.countryCode}',
    );
  }

  Locale? _parseLocale(String value) {
    final parts = value.split(RegExp('[_-]'));
    if (parts.isEmpty) return null;

    final languageCode = parts[0].trim();
    if (languageCode.isEmpty) return null;

    final countryCode = parts.length > 1 ? parts[1].trim() : null;

    if (countryCode == null || countryCode.isEmpty) {
      return _closestSupported(Locale(languageCode));
    }

    return _closestSupported(Locale(languageCode, countryCode));
  }

  Locale? _closestSupported(Locale locale) {
    for (final l in supportedLocales) {
      if (l.languageCode == locale.languageCode && l.countryCode == locale.countryCode) {
        return l;
      }
    }

    for (final l in supportedLocales) {
      if (l.languageCode == locale.languageCode) {
        return l;
      }
    }

    return null;
  }
}
