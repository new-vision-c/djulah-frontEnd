import 'package:get/get.dart';

import '../../../../presentation/client/messages/controllers/messages.controller.dart';

class ClientMessagesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
  }
}
