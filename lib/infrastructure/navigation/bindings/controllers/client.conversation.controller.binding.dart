import 'package:get/get.dart';

import '../../../../presentation/client/conversation/controllers/conversation.controller.dart';

class ClientConversationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(
      () => ConversationController(),
    );
  }
}
