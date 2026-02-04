import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../datas/local_storage/app_storage.dart';
import '../../../../domain/enums/auth_status.dart';
import '../../../../infrastructure/navigation/route_names.dart';
import '../../../../infrastructure/services/auth_service.dart';
import '../../../../infrastructure/services/google_sign_in_service.dart';
import '../../../../infrastructure/shared/app_enums.dart';
import '../../../../infrastructure/ui/app_flushbar.dart';
import '../../../components/password_field.widget.dart';
import '../../../client/components/social_auth_buttons.dart';

class LoginController extends GetxController with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();
  final authService = AuthService();
  final storage = Get.find<AppStorage>();
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isEmailValid = true.obs;
  RxString email = ''.obs;
  RxInt limitCharPassword = 8.obs;
  RxString password = ''.obs;
  final RxBool startAnimation = false.obs;
  
  // Google Sign-In state
  final RxBool isGoogleLoading = false.obs;
  final Rx<SocialAuthProvider?> loadingProvider = Rx<SocialAuthProvider?>(null);
  
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  
  // Pour le scroll automatique au clavier
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
  
  /// Vérifie si le clavier est visible et scroll automatiquement
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
  
  /// Scroll la vue jusqu'à ce que le AuthCollapsibleHeader soit en position collapsed
  void _scrollToCollapsedHeader() {
    if (!scrollController.hasClients) return;
    
    // Le header a: maxExtent = 200.h, minExtent = kToolbarHeight + 20.h
    // Pour le collapse complètement, on doit scroller de (maxExtent - minExtent)
    final collapsedOffset = 200.h - (kToolbarHeight + 20.h);
    
    // Ne scroller que si on n'est pas déjà assez bas
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




  bool get isFormValid => 
      GetUtils.isEmail(email.value) &&
      PasswordField.validatePassword(password.value) == null;

  Future<void> goToHome() async {
    if (!isFormValid) {
      final ctx = Get.context;
      if (ctx != null) {
        AppFlushBar.show(
          ctx,
          message: 'auth.fill_all_fields'.tr,
          type: MessageType.warning,
        );
      }
      return;
    }

    AppConfig.isLoadingApp.value = true;

    try {
      final result = await authService.login(
        email: email.value.trim(),
        password: password.value,
      );

      final ctx = Get.context;
      if (ctx == null) return;

      switch (result.status) {
        case LoginStatus.SUCCESS:
          if (result.entity != null) {
            // Sauvegarder le token JWT
            if (result.entity!.accessToken.isNotEmpty) {
              await storage.saveToken(result.entity!.accessToken);
            }
            
            AppFlushBar.show(
              ctx,
              message: 'auth.login_success'.trParams({'name': result.entity!.user.fullname}),
              type: MessageType.success,
            );
            Get.offAllNamed(
              RouteNames.clientDashboard,
              arguments: {
                "email": email.value,
                "user": result.entity!.user,
              },
            );
          }
          break;

        case LoginStatus.INVALID_CREDENTIALS:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'auth.invalid_credentials'.tr,
            type: MessageType.error,
          );
          break;

        case LoginStatus.ACCOUNT_LOCKED:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'auth.account_locked'.tr,
            type: MessageType.error,
          );
          break;

        case LoginStatus.NOT_VERIFIED:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'auth.account_not_verified'.tr,
            type: MessageType.warning,
          );
          break;

        case LoginStatus.ERROR:
        case LoginStatus.NETWORK_ERROR:
          AppFlushBar.show(
            ctx,
            title: 'common.error'.tr,
            message: 'auth.login_error'.tr,
            type: MessageType.error,
          );
          break;
      }
    } catch (e) {
      print('Erreur inattendue lors de la connexion: $e');
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
  
  Future<void> goToForgetPasswor() async {
    AppConfig.isLoadingApp.value = true;

    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(
      RouteNames.clientForgetPassword,
    );
    AppConfig.isLoadingApp.value = false;
  }

  /// Connexion via Google Sign-In
  Future<void> onGoogleSignIn() async {
    if (isGoogleLoading.value) return;
    
    isGoogleLoading.value = true;
    loadingProvider.value = SocialAuthProvider.google;

    try {
      // 1. Déclencher le popup Google
      final googleResult = await _googleSignInService.signIn();
      
      if (googleResult == null) {
        // L'utilisateur a annulé
        isGoogleLoading.value = false;
        loadingProvider.value = null;
        return;
      }

      // 2. Envoyer le token au backend
      final result = await authService.googleAuth(
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
          // Utilisateur existant connecté avec succès
          if (result.entity != null) {
            // Sauvegarder le token si disponible
            if (result.entity!.accessToken != null) {
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
          // Nouvel utilisateur, rediriger vers vérification OTP
          if (result.entity != null) {
            // Sauvegarder le token temporaire
            if (result.entity!.accessToken != null) {
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
          // L'utilisateur a annulé - rien à faire
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

  /// Connexion via Apple Sign-In (à implémenter plus tard)
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
    super.onClose();
  }
}
