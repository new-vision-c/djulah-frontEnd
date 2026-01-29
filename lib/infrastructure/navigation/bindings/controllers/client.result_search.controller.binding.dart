import 'package:get/get.dart';

import '../../../../presentation/client/result_search/controllers/result_search.controller.dart';

class ClientResultSearchControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultSearchController>(
      () => ResultSearchController(),
    );
  }
}
