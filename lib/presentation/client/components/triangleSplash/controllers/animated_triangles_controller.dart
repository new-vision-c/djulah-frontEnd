import 'package:get/get.dart';

class TriangleController extends GetxController {
  // Booléen pour lancer l'animation
  var hideTriangles = false.obs;

  void toggle() => hideTriangles.value = !hideTriangles.value;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
