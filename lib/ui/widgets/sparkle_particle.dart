import "dart:math";
import "package:flutter/material.dart";

class SparkleParticle extends StatefulWidget {
  final Offset startPosition;
  final VoidCallback onDone;

  const SparkleParticle({
    super.key,
    required this.startPosition,
    required this.onDone,
  });

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
  late double driftX;
  late double size;

  @override
  void initState() {
    super.initState();

    driftX = (_random.nextDouble() - 0.5) * 30;
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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDone();
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
                Icons.auto_awesome,
                size: size,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ),
        );
      },
    );
  }
}
