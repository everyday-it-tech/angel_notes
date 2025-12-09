import 'dart:math';
import 'package:flutter/material.dart';

class SparkleParticle extends StatefulWidget {
  final Offset startPosition;

  const SparkleParticle({
    super.key,
    required this.startPosition,
  });

  // 👑 Expose a getter so HomeScreen can safely remove finished particles
  bool get shouldRemove => _shouldRemove;
  static bool _shouldRemove = false;

  @override
  State<SparkleParticle> createState() => _SparkleParticleState();
}

class _SparkleParticleState extends State<SparkleParticle>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _rise;
  late Animation<double> _scale;

  final Random _random = Random();

  double driftX = 0;
  double size = 0;

  @override
  void initState() {
    super.initState();

    // small random drift left or right
    driftX = (_random.nextDouble() - 0.5) * 30;

    // random sparkle size
    size = 10 + _random.nextDouble() * 10;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 1.0, end: 0.0));

    _rise = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: -50.0));

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 1.0, end: 0.0));

    // When animation finishes → flag for removal
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SparkleParticle._shouldRemove = true;
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          left: widget.startPosition.dx + driftX,
          top: widget.startPosition.dy + _rise.value,
          child: Opacity(
            opacity: _fade.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: size,
              ),
            ),
          ),
        );
      },
    );
  }
}
