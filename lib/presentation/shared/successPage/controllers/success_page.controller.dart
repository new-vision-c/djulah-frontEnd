import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccessPageController extends GetxController with GetSingleTickerProviderStateMixin  {

  dynamic arguments =Get.arguments;
  String description="Votre compte est prêt. Vous pouvez commencer votre recherche.";
   late final AnimationController lottieController;

  final count = 0.obs;
  @override
  void onInit() {
    lottieController = AnimationController(vsync: this);
    super.onInit();
    if (arguments != null && arguments is Map) {
      if (arguments.containsKey('description')) {
        description = arguments['description'] ?? null;
      }


    }
  }

  void playShort(LottieComposition composition) {
    lottieController
      ..duration = composition.duration
      ..animateTo(
        0.38,
        curve: Curves.easeOut,
      );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    lottieController.dispose();
    super.onClose();
  }

}
