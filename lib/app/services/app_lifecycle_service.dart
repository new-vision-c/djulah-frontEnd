import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppLifecycleService extends GetxService with WidgetsBindingObserver {
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
}
