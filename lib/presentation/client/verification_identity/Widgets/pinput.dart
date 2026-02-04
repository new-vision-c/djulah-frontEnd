import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/verification_identity/controllers/verification_identity.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PinController extends GetxController {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  final RxString pin = "".obs;
  final RxBool isFocused = false.obs;
  final int length = 6;

  @override
  void onInit() {
    super.onInit();

    textController.addListener(() {
      if (textController.text.length <= length) {
        pin.value = textController.text;
        
        // Check if pin is complete
        if (pin.value.length == length) {
          // Unfocus keyboard
          focusNode.unfocus();
          
          // Notify verification controller
          try {
            final verificationController = Get.find<VerificationIdentityController>();
            verificationController.isPinComplete.value = true;
            verificationController.otp.value = pin.value;
          } catch (e) {
            print('Controller not found: $e');
          }
        } else {
          // Reset button state if pin is not complete
          try {
            final verificationController = Get.find<VerificationIdentityController>();
            verificationController.isPinComplete.value = false;
            verificationController.otp.value = pin.value;
          } catch (e) {
            print('Controller not found: $e');
          }
        }
      } else {
        textController.text = pin.value;
      }
    });

    // Listen to focus changes
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });

    // Auto focus → opens the numpad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  // Method to reactivate the keyboard
  void reactivateKeyboard() {
    // Clear focus first, then refocus to ensure keyboard appears
    focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      focusNode.requestFocus();
    });
  }
  
  // Method to clear the pin
  void clearPin() {
    textController.clear();
    pin.value = '';
    reactivateKeyboard();
  }

  // Get the active index (the next box to fill)
  int get activeIndex {
    if (!isFocused.value) return -1;
    return pin.value.length < length ? pin.value.length : -1;
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

class PinInputWidget extends StatelessWidget {
  final PinController controller = Get.put(PinController());
  final Color? primaryColor;

  PinInputWidget({
    super.key,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = ClientTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        controller.reactivateKeyboard();
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// INVISIBLE INPUT (captures keyboard)
          Opacity(
            opacity: 0,
            child: TextField(
              controller: controller.textController,
              focusNode: controller.focusNode,
              keyboardType: TextInputType.number,
              maxLength: controller.length,
              showCursor: false,
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
            ),
          ),

          /// REACTIVE DISPLAY
          Obx(() {
            return Row(
              spacing: 4.r,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(controller.length, (index) {
                final isFilled = index < controller.pin.value.length;
                final isActive = controller.activeIndex == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56.r,
                  width: 56.r,
                  padding: EdgeInsets.all(22.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: ClientTheme.pinInputBackground,
                    border: isActive
                        ? Border.all(color: borderColor, width: 2.r)
                        : Border.all(color: Colors.transparent, width: 2.r),
                    // Shadow on the active box
                    boxShadow: isActive
                        ? [
                      BoxShadow(
                        color: borderColor.withOpacity(0.3),
                        blurRadius: 8.r,
                        spreadRadius: 1.r,
                      )
                    ]
                        : null,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: Border.all(color: ClientTheme.pinInputDotBorder),
                      shape: BoxShape.circle,
                      color: isFilled ? ClientTheme.pinInputDotColor : Colors.transparent,
                    ),
                  ),
                );
              }),
            );
          })
        ],
      ),
    );
  }
}