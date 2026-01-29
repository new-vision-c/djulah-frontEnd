import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/client_theme.dart';

class CountdownTimer extends StatelessWidget {
  final int minutes;
  final int seconds;
  final Function(String)? onTick;
  final VoidCallback? onComplete;
  final String? tag;

  CountdownTimer({
    Key? key,
    required this.minutes,
    this.seconds = 0,
    this.onTick,
    this.onComplete,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = tag ?? '${minutes}_${seconds}_${DateTime.now().millisecondsSinceEpoch}';
    final controller = Get.put(
      CountdownTimerController(
        totalSeconds: (minutes * 60) + seconds,
        onTick: onTick,
        onComplete: onComplete,
      ),
      tag: controllerTag,
    );

    return Obx(() => Text(
      controller.formattedTime.value,
      style: TextStyle(
        fontSize: 12.sp,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.36.r,
        height: 16.sp / 12.sp,
        color: controller.isCompleted.value 
            ? ClientTheme.errorColor 
            : ClientTheme.primaryColor,
      ),
    ));
  }
}

class CountdownTimerController extends GetxController {
  final int totalSeconds;
  final Function(String)? onTick;
  final VoidCallback? onComplete;

  final RxString formattedTime = '00:00'.obs;
  final RxInt remainingSeconds = 0.obs;
  final RxBool isCompleted = false.obs;
  Timer? _timer;

  CountdownTimerController({
    required this.totalSeconds,
    this.onTick,
    this.onComplete,
  });

  @override
  void onInit() {
    super.onInit();
    _start();
  }

  void _start() {
    remainingSeconds.value = totalSeconds;
    isCompleted.value = false;
    _updateFormattedTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        _updateFormattedTime();
        onTick?.call(formattedTime.value);
      } else {
        timer.cancel();
        isCompleted.value = true;
        onComplete?.call();
      }
    });
  }

  void restart() {
    _timer?.cancel();
    _start();
  }

  void _updateFormattedTime() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    formattedTime.value = "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}