import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/components/CounterDown.dart';
import 'package:get/get.dart';

class VerificationIdentityController extends GetxController {

  var arguments=Get.arguments;
  RxString email ="".obs;
  RxBool canResend = false.obs;
  RxBool isPinComplete = false.obs;
  final String timerTag = 'verification_timer_${DateTime.now().millisecondsSinceEpoch}';
  
  @override
  void onInit() {
    if (arguments != null && arguments is Map) {
      if (arguments.containsKey('email')) {
        email.value = arguments['email'] ?? null;
      }
      super.onInit();
    }
  }

  Future<void> goToSuccessPage() async{
    AppConfig.isLoadingApp.value=true;
    await Future.delayed(Duration(seconds: 2));
    if(Get.previousRoute==RouteNames.clientForgetPassword){
      Get.toNamed(RouteNames.clientUpdatePassword);
    }
    else{
      Get.toNamed(RouteNames.sharedSuccessPage);
    }
    AppConfig.isLoadingApp.value=false;
  }

  void onTimerComplete() {
    canResend.value = true;
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    
    canResend.value = false;
    
    try {
      final timerController = Get.find<CountdownTimerController>(tag: timerTag);
      timerController.restart();
    } catch (e) {
      print('Erreur lors du restart du timer: $e');
    }
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
