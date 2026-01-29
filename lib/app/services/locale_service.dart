import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../datas/local_storage/app_storage.dart';

class LocaleService {
  static const supportedLocales = AppStorage.supportedLocales;
  static const fallbackLocale = AppStorage.fallbackLocale;

  late final AppStorage _storage;
  late Locale _currentLocale;

  Locale get currentLocale => _currentLocale;

  static Future<LocaleService> init() async {
    final service = LocaleService();
    service._storage = Get.find<AppStorage>();
    service._currentLocale = service._storage.locale;
    return service;
  }

  String get languageHeaderValue => _currentLocale.languageCode;

  Future<void> setLocale(Locale locale) async {
    await _storage.saveLocale(locale);
    _currentLocale = _storage.locale;
    Get.updateLocale(_currentLocale);
  }
}
