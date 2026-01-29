import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselFadeController extends GetxController {
  final List<Widget> widgets;
  final Duration displayDuration;
  final Duration fadeDuration;
  
  CarouselFadeController({
    required this.widgets,
    this.displayDuration = const Duration(seconds: 3),
    this.fadeDuration = const Duration(milliseconds: 800),
  });

  final RxInt currentIndex = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startCarousel();
  }

  void _startCarousel() {
    if (widgets.length <= 1) return;
    
    _timer = Timer.periodic(displayDuration, (timer) {
      currentIndex.value = (currentIndex.value + 1) % widgets.length;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
