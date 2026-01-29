import 'package:get/get.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  final openedTabs = <int>{0}.obs;
  void onChangIndex(int index) {
    currentIndex.value = index;
    if (!openedTabs.contains(index)) {
      openedTabs.add(index);
    }
  }

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
}
