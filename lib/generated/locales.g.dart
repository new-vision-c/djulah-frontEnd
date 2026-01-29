import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const String frLocale = 'fr_FR';
  static const String enLocale = 'en_US';

  final Map<String, Map<String, String>> _keys;

  AppTranslations._(this._keys);

  static Future<AppTranslations> load() async {
    final fr = await _loadJsonMap('assets/locales/fr.json');
    final en = await _loadJsonMap('assets/locales/en.json');

    return AppTranslations._({
      frLocale: fr,
      enLocale: en,
    });
  }

  static Future<Map<String, String>> _loadJsonMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw StateError('Invalid locale file format: $assetPath');
    }

    return _flattenMap(decoded);
  }

  static Map<String, String> _flattenMap(Map<dynamic, dynamic> map, [String prefix = '']) {
    final out = <String, String>{};
    
    for (final entry in map.entries) {
      final key = entry.key?.toString();
      if (key == null) continue;
      
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';
      
      if (entry.value is Map) {
        out.addAll(_flattenMap(entry.value as Map, fullKey));
      } else {
        out[fullKey] = entry.value?.toString() ?? '';
      }
    }
    
    return out;
  }

  @override
  Map<String, Map<String, String>> get keys => _keys;
}
