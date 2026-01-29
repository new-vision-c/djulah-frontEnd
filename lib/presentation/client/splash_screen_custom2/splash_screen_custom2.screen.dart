import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/splash_screen_custom2.controller.dart';

class SplashScreenCustom2Screen extends GetView<SplashScreenCustom2Controller> {
  const SplashScreenCustom2Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreenCustom2Screen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SplashScreenCustom2Screen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
