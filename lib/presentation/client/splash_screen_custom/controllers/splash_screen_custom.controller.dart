import 'dart:async';

import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SplashScreenCustomController extends GetxController {
  final RxDouble logoScale = 0.0.obs;
  final RxBool logoAtBottomCenter = false.obs;
  final RxDouble othersOpacity = 0.0.obs;

  Timer? _scaleTimer;
  Timer? _phase2Timer;
  bool _started = false;

  static const Duration _scaleDelay = Duration(milliseconds: 100);
  static const Duration _scaleDuration = Duration(milliseconds: 300);
  static const Duration _positionOpacityDelay = Duration(milliseconds: 600);
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
    _phase2Timer?.cancel();
    super.onClose();
  }

  void goToHomePage() {
    Get.offAllNamed(RouteNames.clientDashboard);
  }
  
  void goToInscriptionPage() {
    Get.toNamed(RouteNames.clientInscription);
  }
  
  void goToConnectPage() {
    Get.toNamed(RouteNames.clientLogin);
  }

  void startEntrance() {
    if (_started) return;
    _started = true;

    logoAtBottomCenter.value = false;
    logoScale.value = 0.0;
    othersOpacity.value = 0.0;

    _scaleTimer = Timer(_scaleDelay, () {
      logoScale.value = 1.0;
    });

    _phase2Timer = Timer(_scaleDelay + _scaleDuration + _positionOpacityDelay, () {
      logoAtBottomCenter.value = true;
      othersOpacity.value = 1.0;
    });
  }
  

}
