import 'dart:async';
import 'dart:ui' as ui;

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/widgets.dart';

class AppStorage {
  static const _tokenKey = 'user_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _localeKey = 'app_locale';

  static const supportedLocales = <Locale>[
    Locale('fr', 'FR'),
    Locale('en', 'US'),
  ];

  static const fallbackLocale = Locale('fr', 'FR');

  final EncryptedSharedPreferences _storage;

  String? _token;
  String? _refreshToken;
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

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  Locale get locale => _locale;

  String get languageHeaderValue => _locale.languageCode;

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    _token = null;
    await _storage.remove(_tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _storage.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> removeRefreshToken() async {
    _refreshToken = null;
    await _storage.remove(_refreshTokenKey);
  }

  Future<void> clearAuth() async {
    await removeToken();
    await removeRefreshToken();
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
