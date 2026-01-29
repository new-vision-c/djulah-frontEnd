import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'carousel_fade.controller.dart';

class CarouselFadeWidget extends StatelessWidget {
  final List<Widget> children;
  final Duration displayDuration;
  final Duration fadeDuration;
  final double? width;
  final double? height;
  final bool showIndicator;

  const CarouselFadeWidget({
    super.key,
    required this.children,
    this.displayDuration = const Duration(seconds: 3),
    this.fadeDuration = const Duration(milliseconds: 800),
    this.width,
    this.height,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CarouselFadeController(
        widgets: children,
        displayDuration: displayDuration,
        fadeDuration: fadeDuration,
      ),
      tag: '${hashCode}',
    );

    return Container(
      width: width,
      height: height,
      color: Colors.black, // Fond solide pour éviter la transparence pendant le fade
      child: Stack(
        children: [
          Obx(
            () => AnimatedSwitcher(
              duration: fadeDuration,
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: SizedBox(
                height: height,
                width: width,
                key: ValueKey<int>(controller.currentIndex.value),
                child: children[controller.currentIndex.value],
              ),
            ),
          ),
          if (showIndicator)
            Positioned(
              bottom: 20.r,
              left: 0,
              right: 0,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(children.length, (index) {
                    bool isActive = controller.currentIndex.value == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.r),
                      width: isActive ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
