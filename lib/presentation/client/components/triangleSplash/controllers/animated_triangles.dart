import 'package:djulah/presentation/client/components/triangles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'animated_triangles_controller.dart';

class AnimatedTriangles extends StatelessWidget {
  final TriangleController controller = Get.put(TriangleController());

  AnimatedTriangles({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final triangleWidth = width * 0.5;

    return Stack(
      children: [
        // Triangle gauche
        Obx(() => AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          left: controller.hideTriangles.value ? -triangleWidth : 0,
          top: 0,
          bottom: 0,
          child: ClipPath(
            clipper: LeftTriangleFullHeightClipper(triangleWidth),
            child: Container(
              width: triangleWidth,
              height: height,
              color: Colors.blue,
            ),
          ),
        )),

        // Triangle droit
        Obx(() => AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          right: controller.hideTriangles.value ? -triangleWidth : 0,
          top: 0,
          bottom: 0,
          child: ClipPath(
            clipper: RightTriangleFullHeightClipper(triangleWidth),
            child: Container(
              width: triangleWidth,
              height: height,
              color: Colors.blue,
            ),
          ),
        )),

        // Bouton pour tester l'animation
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: controller.toggle,
              child: const Text("Toggle Triangles"),
            ),
          ),
        ),
      ],
    );
  }
}


