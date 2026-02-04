import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/services/locale_service.dart';
import '../../../../infrastructure/shared/app_enums.dart';
import '../../../../infrastructure/ui/app_flushbar.dart';

class LangueController extends GetxController {
  RxString selected = "".obs;
  
  late final LocaleService _localeService;

  @override
  void onInit() {
    super.onInit();
    _localeService = Get.find<LocaleService>();
    // Initialiser avec la langue actuelle
    _initCurrentLanguage();
  }

  void _initCurrentLanguage() {
    final currentLocale = _localeService.currentLocale;
    if (currentLocale.languageCode == 'fr') {
      selected.value = "Fr";
    } else {
      selected.value = "En";
    }
  }

  Future<void> changeLanguage(String value) async {
    if (selected.value == value) return;
    
    selected.value = value;
    
    final newLocale = value == "Fr" 
        ? const Locale('fr', 'FR') 
        : const Locale('en', 'US');
    
    await _localeService.setLocale(newLocale);
    
    final context = Get.context;
    if (context != null) {
      AppFlushBar.show(
        context,
        message: 'language.changed_success'.tr,
        type: MessageType.success,
      );
    }
  }
}
