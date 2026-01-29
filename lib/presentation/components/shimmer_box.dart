import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerBox({
    Key? key,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 0,
    this.baseColor = const Color(0xFFEBEBF4),
    this.highlightColor = const Color(0xFFF4F4F4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    Key? key,
    required this.child,
    this.baseColor = const Color(0xFFEBEBF4),
    this.highlightColor = const Color(0xFFF4F4F4),
  }) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmerGradient = LinearGradient(
      colors: [
        widget.baseColor,
        widget.highlightColor,
        widget.baseColor,
      ],
      stops: const [0.3, 0.5, 0.7],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return shimmerGradient.createShader(
              Rect.fromLTWH(
                -bounds.width + (bounds.width * 2 * _controller.value),
                0,
                bounds.width * 2,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}