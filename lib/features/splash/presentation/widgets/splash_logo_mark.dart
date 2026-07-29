import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// The splash's brand mark: a vector-drawn ring (via [CustomPainter], no
/// image asset required) with a looping shimmer sweep and a single
/// orbiting accent dot.
///
/// Deliberately not the old static PNG/icon: a hand-painted vector shape
/// animates far more convincingly (shimmer, orbit) than a flat bitmap
/// ever could, and it scales to any screen density with zero asset work
/// — no `assets/images/splash_logo.png` dependency for the in-app splash.
class SplashLogoMark extends StatefulWidget {
  const SplashLogoMark({
    super.key,
    required this.ringColor,
    required this.accentColor,
    required this.size,
  });

  final Color ringColor;
  final Color accentColor;
  final double size;

  @override
  State<SplashLogoMark> createState() => _SplashLogoMarkState();
}

class _SplashLogoMarkState extends State<SplashLogoMark>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _orbitController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget mark = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final double t = _shimmerController.value;
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment(-1.6 + 3.2 * t, -1),
                    end: Alignment(-0.6 + 3.2 * t, 1),
                    colors: [
                      widget.ringColor,
                      Colors.white.withValues(alpha: 0.9),
                      widget.ringColor,
                    ],
                    stops: const [0.35, 0.5, 0.65],
                  ).createShader(rect);
                },
                child: child,
              );
            },
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _PortalRingPainter(color: widget.ringColor),
            ),
          ),
          AnimatedBuilder(
            animation: _orbitController,
            builder: (context, _) {
              final double angle = _orbitController.value * 2 * math.pi;
              final double radius = widget.size * 0.42;
              return Transform.translate(
                offset:
                    Offset(radius * math.cos(angle), radius * math.sin(angle)),
                child: Container(
                  width: widget.size * 0.06,
                  height: widget.size * 0.06,
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.6),
                        blurRadius: widget.size * 0.05,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    // One-time entrance: scale + fade with an overshoot-free ease. The
    // looping shimmer/orbit above is already running underneath, but it
    // only becomes visible as this settles — so the entrance always
    // reads as a clean, deliberate reveal rather than everything moving
    // at once.
    return mark.animate().fadeIn(duration: 500.ms, curve: Curves.easeOut).scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Draws two concentric arcs, offset from each other — an abstracted
/// "portal ring" silhouette, not a literal recreation of any existing
/// IP. Purely vector, so it never blurs or pixelates on any density.
class _PortalRingPainter extends CustomPainter {
  const _PortalRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double outerRadius = size.width / 2 - 4;
    final double innerRadius = outerRadius * 0.62;

    final Paint outerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;

    final Paint innerPaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      outerPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi * 0.25,
      math.pi * 1.5,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PortalRingPainter oldDelegate) =>
      oldDelegate.color != color;
}
