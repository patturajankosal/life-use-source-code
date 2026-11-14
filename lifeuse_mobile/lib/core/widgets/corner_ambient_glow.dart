import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ultra-modern, creative ambient corner animation near the dark/light toggle button.
/// Features a futuristic dual-orbit celestial gyroscope with counter-rotating rings,
/// orbiting plasma nodes, and a bioluminescent cosmic nebula shimmer.
class CornerAmbientGlow extends StatefulWidget {
  final double size;
  final bool isTopRight;

  const CornerAmbientGlow({
    super.key,
    this.size = 220,
    this.isTopRight = true,
  });

  @override
  State<CornerAmbientGlow> createState() => _CornerAmbientGlowState();
}

class _CornerAmbientGlowState extends State<CornerAmbientGlow>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.isTopRight ? -widget.size * 0.32 : null,
      bottom: !widget.isTopRight ? -widget.size * 0.32 : null,
      right: widget.isTopRight ? -widget.size * 0.32 : null,
      left: !widget.isTopRight ? -widget.size * 0.32 : null,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController]),
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _CornerCosmicBeaconPainter(
                rotation: _rotationController.value,
                pulse: _pulseController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CornerCosmicBeaconPainter extends CustomPainter {
  final double rotation;
  final double pulse;

  _CornerCosmicBeaconPainter({
    required this.rotation,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.42;

    // 1. Soft Nebular Core Bloom
    final nebulaPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18 + 0.10 * pulse)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 28.0 + 8.0 * pulse);
    canvas.drawCircle(center, baseRadius * 0.85, nebulaPaint);

    final cyanNebula = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.14 + 0.08 * pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22.0);
    canvas.drawCircle(
      center + Offset(15 * math.cos(rotation * 2 * math.pi), 15 * math.sin(rotation * 2 * math.pi)),
      baseRadius * 0.55,
      cyanNebula,
    );

    // 2. Primary Tilted Orbital Ring (Clockwise)
    final angle1 = rotation * 2 * math.pi;
    final r1X = baseRadius * (0.92 + 0.05 * pulse);
    final r1Y = baseRadius * 0.42;
    const tilt1 = 0.52; // ~30 degrees

    final ring1Paint = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.32 + 0.15 * pulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt1);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r1X * 2, height: r1Y * 2),
      ring1Paint,
    );

    // Orbiting celestial node along Ring 1
    final p1X = r1X * math.cos(angle1);
    final p1Y = r1Y * math.sin(angle1);
    final node1Glow = Paint()
      ..color = AppColors.neonCyan.withValues(alpha: 0.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
    canvas.drawCircle(Offset(p1X, p1Y), 4.0, node1Glow);
    final node1Core = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(p1X, p1Y), 1.8, node1Core);
    canvas.restore();

    // 3. Counter-Rotating Intersecting Orbital Ring (Counter-Clockwise)
    final angle2 = -rotation * 2 * math.pi * 0.75;
    final r2X = baseRadius * (0.75 + 0.04 * pulse);
    final r2Y = baseRadius * 0.55;
    const tilt2 = -0.65; // ~-37 degrees

    final ring2Paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.28 + 0.12 * pulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt2);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r2X * 2, height: r2Y * 2),
      ring2Paint,
    );

    // Orbiting amber star along Ring 2
    final p2X = r2X * math.cos(angle2);
    final p2Y = r2Y * math.sin(angle2);
    final node2Glow = Paint()
      ..color = AppColors.amberGold.withValues(alpha: 0.60)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5);
    canvas.drawCircle(Offset(p2X, p2Y), 3.5, node2Glow);
    final node2Core = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(p2X, p2Y), 1.6, node2Core);
    canvas.restore();

    // 4. Center Geodesic Starlight Node
    final centerPulseRadius = 2.4 + 1.2 * pulse;
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.50 + 0.30 * pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawCircle(center, centerPulseRadius, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _CornerCosmicBeaconPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.pulse != pulse;
}
