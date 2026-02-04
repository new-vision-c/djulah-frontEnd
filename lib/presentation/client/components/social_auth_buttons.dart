import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/buttons/primary_button.widget.dart';

enum SocialAuthProvider {
  google,
  apple,
}

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;
  final SocialAuthProvider? loadingProvider;

  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.isLoading = false,
    this.loadingProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialButton(
          provider: SocialAuthProvider.google,
          onPressed: onGooglePressed,
          isLoading: isLoading && loadingProvider == SocialAuthProvider.google,
          isDisabled: isLoading && loadingProvider != SocialAuthProvider.google,
        ),
        SizedBox(height: 20.r),
        _SocialButton(
          provider: SocialAuthProvider.apple,
          onPressed: onApplePressed,
          isLoading: isLoading && loadingProvider == SocialAuthProvider.apple,
          isDisabled: isLoading && loadingProvider != SocialAuthProvider.apple,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final SocialAuthProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  const _SocialButton({
    required this.provider,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  String get _text {
    switch (provider) {
      case SocialAuthProvider.google:
        return 'auth.continueWithGoogle'.tr;
      case SocialAuthProvider.apple:
        return 'auth.continueWithApple'.tr;
    }
  }

  String get _iconPath {
    switch (provider) {
      case SocialAuthProvider.google:
        return 'assets/images/client/Logos_google.png';
      case SocialAuthProvider.apple:
        return 'assets/images/client/Logos_apple.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: _text,
      backgroundColor: ClientTheme.inputBackgroundColor,
      textColor: isDisabled ? ClientTheme.textDisabledColor : Colors.black,
      fontWeight: FontWeight.w500,
      cheminIcon: _iconPath,
      isEnabled: !isDisabled,
      isLoading: isLoading,
      onPressed: isDisabled ? null : onPressed,
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'auth.continueWithGoogle'.tr,
      backgroundColor: ClientTheme.inputBackgroundColor,
      textColor: Colors.black,
      fontWeight: FontWeight.w500,
      cheminIcon: 'assets/images/client/Logos_google.png',
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}

class AppleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'auth.continueWithApple'.tr,
      backgroundColor: ClientTheme.inputBackgroundColor,
      textColor: Colors.black,
      fontWeight: FontWeight.w500,
      cheminIcon: 'assets/images/client/Logos_apple.png',
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
