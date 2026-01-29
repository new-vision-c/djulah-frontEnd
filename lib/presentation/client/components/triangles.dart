// Triangle gauche pleine hauteur
import 'package:flutter/cupertino.dart';

class LeftTriangleFullHeightClipper extends CustomClipper<Path> {
  final double baseWidth;
  LeftTriangleFullHeightClipper(this.baseWidth);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);              // Bas gauche
    path.lineTo(0, 0);                        // Haut gauche
    path.lineTo(baseWidth, size.height);      // Bas droit
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Triangle droit pleine hauteur
class RightTriangleFullHeightClipper extends CustomClipper<Path> {
  final double baseWidth;
  RightTriangleFullHeightClipper(this.baseWidth);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, size.height);          // Bas droit
    path.lineTo(size.width, 0);                    // Haut droit
    path.lineTo(size.width - baseWidth, size.height); // Bas gauche
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}