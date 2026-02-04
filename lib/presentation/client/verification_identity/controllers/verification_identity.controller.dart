import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/datas/local_storage/app_storage.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/components/CounterDown.dart';
import 'package:get/get.dart';
import '../../../../domain/enums/auth_status.dart';
import '../../../../infrastructure/services/auth_service.dart';
import '../../../../infrastructure/shared/app_enums.dart';
import '../../../../infrastructure/ui/app_flushbar.dart';

class VerificationIdentityController extends GetxController {

  final authService = AuthService();
  final storage = Get.find<AppStorage>();
  var arguments=Get.arguments;
  RxString email ="".obs;
  RxString otp = "".obs;
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
    if (otp.value.length != 6) {
      final ctx = Get.context;
      if (ctx != null) {
        AppFlushBar.show(
          ctx,
          message: 'verification.enter_6_digits'.tr,
          type: MessageType.warning,
        );
      }
      return;
    }

    AppConfig.isLoadingApp.value = true;

    try {
      final result = await authService.verifyOtp(
        email: email.value.trim(),
        otp: otp.value,
      );

      final ctx = Get.context;
      if (ctx == null) return;

      switch (result.status) {
        case VerifyOtpStatus.SUCCESS:
          // Sauvegarder le token JWT si présent
          if (result.entity?.accessToken != null && result.entity!.accessToken!.isNotEmpty) {
            await storage.saveToken(result.entity!.accessToken!);
          }
          
          AppFlushBar.show(
            ctx,
            message: 'verification.success'.tr,
            type: MessageType.success,
          );
          
          if (Get.previousRoute == RouteNames.clientForgetPassword) {
            Get.toNamed(RouteNames.clientUpdatePassword);
          } else {
            Get.toNamed(RouteNames.sharedSuccessPage);
          }
          break;

        case VerifyOtpStatus.INVALID_OTP:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.invalid_code'.tr,
            type: MessageType.error,
          );
          break;

        case VerifyOtpStatus.EXPIRED_OTP:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.expired_code'.tr,
            type: MessageType.warning,
          );
          break;

        case VerifyOtpStatus.USER_NOT_FOUND:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.user_not_found'.tr,
            type: MessageType.error,
          );
          break;

        case VerifyOtpStatus.ALREADY_VERIFIED:
          AppFlushBar.show(
            ctx,
            message: 'verification.already_verified'.tr,
            type: MessageType.info,
          );
          Get.toNamed(RouteNames.sharedSuccessPage);
          break;

        case VerifyOtpStatus.ERROR:
        case VerifyOtpStatus.NETWORK_ERROR:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.error'.tr,
            type: MessageType.error,
          );
          break;
      }
    } catch (e) {
      print('Erreur inattendue lors de la vérification OTP: $e');
      final ctx = Get.context;
      if (ctx != null) {
        AppFlushBar.show(
          ctx,
          message: 'common.error_occurred'.tr,
          type: MessageType.error,
        );
      }
    } finally {
      AppConfig.isLoadingApp.value = false;
    }
  }

  void onTimerComplete() {
    canResend.value = true;
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    
    canResend.value = false;

    try {
      AppConfig.isLoadingApp.value=true;
      final result = await authService.resendOtp(email: email.value.trim());
      AppConfig.isLoadingApp.value=false;

      final ctx = Get.context;
      if (ctx == null) return;

      switch (result.status) {
        case ResendOtpStatus.SUCCESS:
          AppFlushBar.show(
            ctx,
            message: 'verification.code_resent'.tr,
            type: MessageType.success,
          );
          try {
            final timerController = Get.find<CountdownTimerController>(tag: timerTag);
            timerController.restart();
          } catch (e) {
            print('Erreur lors du restart du timer: $e');
          }
          break;

        case ResendOtpStatus.USER_NOT_FOUND:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.user_not_found'.tr,
            type: MessageType.error,
          );
          canResend.value = true;
          break;

        case ResendOtpStatus.ALREADY_VERIFIED:
          AppFlushBar.show(
            ctx,
            message: 'verification.already_verified'.tr,
            type: MessageType.info,
          );
          break;

        case ResendOtpStatus.TOO_MANY_REQUESTS:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.too_many_requests'.tr,
            type: MessageType.warning,
          );
          canResend.value = true;
          break;

        case ResendOtpStatus.ERROR:
        case ResendOtpStatus.NETWORK_ERROR:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'verification.resend_error'.tr,
            type: MessageType.error,
          );
          canResend.value = true;
          break;
      }
    } catch (e) {
      print('Erreur inattendue lors du resend OTP: $e');
      final ctx = Get.context;
      if (ctx != null) {
        AppFlushBar.show(
          ctx,
          message: 'common.error_occurred'.tr,
          type: MessageType.error,
        );
      }
      canResend.value = true;
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
