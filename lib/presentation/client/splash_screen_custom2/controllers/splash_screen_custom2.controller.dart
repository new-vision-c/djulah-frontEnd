import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../infrastructure/navigation/route_names.dart';

class SplashScreenCustom2Controller extends GetxController {
  final RxDouble logoScale = 0.0.obs;
  bool _started = false;
  Timer? _scaleTimer;


  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
       startEntrance();
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _scaleTimer?.cancel();
    super.onClose();
  }
  
  Future<void> startEntrance() async {
    if (_started) return;
    _started = true;
    logoScale.value = 0.0;
    
    _scaleTimer = await Timer(Duration(milliseconds: 100), () {
      logoScale.value = 1.0;

    });
    await Future.delayed(Duration(milliseconds: 500));
    Get.offAllNamed(RouteNames.clientDashboard);


  }
}
