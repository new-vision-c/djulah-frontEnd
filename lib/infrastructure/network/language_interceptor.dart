import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../app/services/locale_service.dart';

class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final localeService = Get.find<LocaleService>();

    // Backend convention: Accept-Language: fr|en
    options.headers['Accept-Language'] = localeService.languageHeaderValue;

    handler.next(options);
  }
}
