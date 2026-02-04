import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/datas/local_storage/app_storage.dart';
import 'package:djulah/domain/enums/register_status.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/services/auth_service.dart';
import 'package:djulah/infrastructure/services/google_sign_in_service.dart';
import 'package:djulah/infrastructure/shared/app_enums.dart';
import 'package:djulah/infrastructure/ui/app_flushbar.dart';
import 'package:djulah/presentation/components/password_field.widget.dart';
import 'package:djulah/presentation/client/components/social_auth_buttons.dart';
import 'package:djulah/domain/enums/auth_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InscriptionController extends GetxController with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isEmailValid = true.obs;
  RxString selectedValue = "".obs;
  TextEditingController nameController = TextEditingController();
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString password = ''.obs;
  final RxBool startAnimation = false.obs;
  final RxBool atBottom = false.obs;
  
  // Google Sign-In state
  final RxBool isGoogleLoading = false.obs;
  final Rx<SocialAuthProvider?> loadingProvider = Rx<SocialAuthProvider?>(null);
  
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final AuthService _authService = AuthService();

  bool _wasKeyboardVisible = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
  
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _checkKeyboardAndScroll();
  }
  
  void _checkKeyboardAndScroll() {
    final context = Get.context;
    if (context == null) return;
    
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInset > 0;
    
    // Si le clavier vient de s'ouvrir, scroller jusqu'à ce que le header soit collapsed
    if (isKeyboardVisible && !_wasKeyboardVisible) {
      _scrollToCollapsedHeader();
    }
    
    _wasKeyboardVisible = isKeyboardVisible;
  }
  
  void _scrollToCollapsedHeader() {
    if (!scrollController.hasClients) return;

    final collapsedOffset = 200.h - (kToolbarHeight + 20.h);

    if (scrollController.offset < collapsedOffset) {
      scrollController.animateTo(
        collapsedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
  
  @override
  void onReady() {
    super.onReady();
    startAnimation.value = true;
  }

  bool get isFormValid => GetUtils.isEmail(email.value) &&
      name.value.isNotEmpty &&
      PasswordField.validatePassword(password.value) == null;

  Future<void> goToVerificationEmail() async {
    AppConfig.isLoadingApp.value = true;

    try {
     final result = await AuthService().registerStep1(
        email: email.value,
        fullname: name.value,
        password: password.value,
      );

      AppConfig.isLoadingApp.value = false;

      if (result.registerStatus == RegisterStatus.SUCCESS && result.entity != null) {
        final entity = result.entity!;


        final context = Get.context;
        if (context != null) {
          AppFlushBar.show(
            context,
            message: entity.data?.message ?? entity.message,
            type: MessageType.success,
          );
        }

        Get.toNamed(
          RouteNames.clientVerificationIdentity,
          arguments: {
            "email": email.value,
          },
        );
      }

    } catch (e) {
      AppConfig.isLoadingApp.value = false;
      print("Erreur inattendue dans goToVerificationEmail: $e");
    }
  }

  Future<void> onGoogleSignIn() async {
    if (isGoogleLoading.value) return;
    
    isGoogleLoading.value = true;
    loadingProvider.value = SocialAuthProvider.google;

    try {
      final googleResult = await _googleSignInService.signIn();
      
      if (googleResult == null) {
        isGoogleLoading.value = false;
        loadingProvider.value = null;
        return;
      }

      final result = await _authService.googleAuth(
        googleAccessToken: googleResult.accessToken,
      );

      final ctx = Get.context;
      if (ctx == null) {
        isGoogleLoading.value = false;
        loadingProvider.value = null;
        return;
      }

      switch (result.status) {
        case GoogleAuthStatus.SUCCESS:
          if (result.entity != null) {
            // Sauvegarder le token si disponible
            if (result.entity!.accessToken != null) {
              final storage = Get.find<AppStorage>();
              await storage.saveToken(result.entity!.accessToken!);
            }

            AppFlushBar.show(
              ctx,
              message: 'auth.login_success'.trParams({'name': result.entity!.user?.fullname ?? googleResult.displayName ?? ''}),
              type: MessageType.success,
            );

            Get.offAllNamed(
              RouteNames.clientDashboard,
              arguments: {
                "email": result.entity!.user?.email ?? googleResult.email,
                "user": result.entity!.user,
              },
            );
          }
          break;

        case GoogleAuthStatus.NEW_USER_REQUIRES_OTP:
          if (result.entity != null) {
            if (result.entity!.accessToken != null) {
              final storage = Get.find<AppStorage>();
              await storage.saveToken(result.entity!.accessToken!);
            }

            AppFlushBar.show(
              ctx,
              message: result.entity!.message,
              type: MessageType.success,
            );

            Get.toNamed(
              RouteNames.clientVerificationIdentity,
              arguments: {
                "email": result.entity!.user?.email ?? googleResult.email,
                "isGoogleAuth": true,
              },
            );
          }
          break;

        case GoogleAuthStatus.CANCELLED:
          break;

        case GoogleAuthStatus.GOOGLE_ERROR:
          AppFlushBar.show(
            ctx,
            title: 'google.error_title'.tr,
            message: 'google.error_message'.tr,
            type: MessageType.error,
          );
          break;

        case GoogleAuthStatus.NETWORK_ERROR:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'common.network_error'.tr,
            type: MessageType.error,
          );
          break;

        case GoogleAuthStatus.ERROR:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'common.error_occurred'.tr,
            type: MessageType.error,
          );
          break;
      }
    } catch (e) {
      print('Erreur inattendue dans onGoogleSignIn: $e');
      final ctx = Get.context;
      if (ctx != null) {
        AppFlushBar.show(
          ctx,
          message: 'google.connection_error'.tr,
          type: MessageType.error,
        );
      }
    } finally {
      isGoogleLoading.value = false;
      loadingProvider.value = null;
    }
  }

  Future<void> onAppleSignIn() async {
    final ctx = Get.context;
    if (ctx != null) {
      AppFlushBar.show(
        ctx,
        message: 'apple.coming_soon'.tr,
        type: MessageType.info,
      );
    }
  }



  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
