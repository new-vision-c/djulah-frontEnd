import 'package:get/get.dart';

import '../../../../presentation/client/verification_identity/controllers/verification_identity.controller.dart';

class ClientVerificationIdentityControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationIdentityController>(
      () => VerificationIdentityController(),
    );
  }
}
