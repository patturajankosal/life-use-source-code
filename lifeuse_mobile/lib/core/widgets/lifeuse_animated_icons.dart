import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// The 4 unique 3D animation modes for the LifeUse Brand Icon.
enum LifeUseIconAnimMode {
  hyperVortex,      // Mode 0: Swirling Cosmic Spiral Flow with Flowing Star Sparks & Vortex Flux
  orbital3D,        // Mode 1: 3D Keplerian Celestial Orbit with Radiant Comet Star Tails & Z-Depth
  quantumPulse,     // Mode 2: Bioluminescent Expanding Energy Shockwaves & Heartbeat Glow
  holographicSheen, // Mode 3: 3D Prismatic Metallic Light Sweep & Specular Beam
}

/// Ultra-Realistic 3D Cinematic LifeUse Brand Icon.
/// Features:
/// - Pure fluid 'LU' ribbon monogram (Zero text)
/// - Concentric Circular 3D Glass Medallion with polished metallic rim
/// - Idle anti-gravity levitation, breathing glow, and rich depth active AT ALL TIMES
/// - Interactive 3D perspective tilt & extra bloom on hover / pointer interaction
/// - 4 unique switchable animation modes with spring tap response
/// - 100% pure Flutter rendering (fully cross-platform & future-deployment safe)
class LifeUse3DIcon extends StatefulWidget {
  final double size;
  final LifeUseIconAnimMode mode;
  final VoidCallback? onTap;

  const LifeUse3DIcon({
    super.key,
    this.size = 84,
    this.mode = LifeUseIconAnimMode.hyperVortex,
    this.onTap,
  });

  @override
  State<LifeUse3DIcon> createState() => _LifeUse3DIconState();
}

class _LifeUse3DIconState extends State<LifeUse3DIcon>
    with TickerProviderStateMixin {
  late final AnimationController _levitateController;
  late final AnimationController _animModeController;
  late final AnimationController _tapBounceController;
  late final AnimationController _hoverTransitionController;

  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  void initState() {
    super.initState();

    // 1. Idle Anti-Gravity Floating Levitation (Active at all times)
    _levitateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    // 2. Mode-Specific Continuous Motion
    _animModeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();

    // 3. Tactile Tap Feedback
    _tapBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );

    // 4. Smooth Hover Elevation & Glow Transition
    _hoverTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }

  @override
  void dispose() {
    _levitateController.dispose();
    _animModeController.dispose();
    _tapBounceController.dispose();
    _hoverTransitionController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _tapBounceController.reverse();
    if (mounted) {
      await _tapBounceController.forward();
    }
    widget.onTap?.call();
  }

  void _onPointerHover(PointerEvent event, Size canvasSize) {
    final centerX = canvasSize.width / 2;
    final centerY = canvasSize.height / 2;
    final normX = (event.localPosition.dx - centerX) / centerX;
    final normY = (event.localPosition.dy - centerY) / centerY;

    setState(() {
      _tiltX = normX.clamp(-1.0, 1.0) * 0.18; // ~10 deg max tilt
      _tiltY = normY.clamp(-1.0, 1.0) * 0.18;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ringSize = widget.size * 1.56;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        _hoverTransitionController.forward();
      },
      onExit: (_) {
        setState(() {
          _tiltX = 0.0;
          _tiltY = 0.0;
        });
        _hoverTransitionController.reverse();
      },
      onHover: (e) => _onPointerHover(e, Size(ringSize, ringSize)),
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _levitateController,
            _animModeController,
            _tapBounceController,
            _hoverTransitionController,
          ]),
          builder: (context, _) {
            final hoverFactor = _hoverTransitionController.value;

            // Idle levitation active AT ALL TIMES (±4.0px)
            final floatY = math.sin(_levitateController.value * math.pi * 2) * 4.0;
            // Additional lift on hover (-5.0px)
            final hoverLift = -5.0 * hoverFactor;

            // Idle breathing scale (1.0 -> 1.025), plus extra expansion on hover (1.07x)
            final idleBreathScale = 1.0 + (0.025 * _levitateController.value);
            final hoverScale = 1.0 + (0.05 * hoverFactor);
            final totalScale = _tapBounceController.value * idleBreathScale * hoverScale;

            // 3D Perspective Tilt Matrix
            final transformMatrix = Matrix4.identity()
              ..setEntry(3, 2, 0.0018) // Realistic depth perspective
              ..rotateX(-_tiltY * hoverFactor)
              ..rotateY(_tiltX * hoverFactor);

            return Transform.translate(
              offset: Offset(0, floatY + hoverLift),
              child: Transform(
                alignment: Alignment.center,
                transform: transformMatrix,
                child: Transform.scale(
                  scale: totalScale,
                  child: SizedBox(
                    width: ringSize,
                    height: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // --- Layer 1: Background FX (Behind tile) ---
                        _buildBackgroundFX(ringSize, hoverFactor),

                        // --- Layer 2: 3D Circular / Squircle Glass Medallion ---
                        _build3DGlassTile(hoverFactor),

                        // --- Layer 3: Foreground FX (In front of tile) ---
                        _buildForegroundFX(ringSize, hoverFactor),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the background effects based on active mode
  Widget _buildBackgroundFX(double canvasSize, double hoverFactor) {
    switch (widget.mode) {
      case LifeUseIconAnimMode.orbital3D:
        return CustomPaint(
          size: Size(canvasSize, canvasSize),
          painter: _Orbital3DPainter(
            progress: _animModeController.value,
            hoverFactor: hoverFactor,
            isForeground: false,
          ),
        );

      case LifeUseIconAnimMode.quantumPulse:
        return CustomPaint(
          size: Size(canvasSize, canvasSize),
          painter: _QuantumPulsePainter(
            progress: _animModeController.value,
            hoverFactor: hoverFactor,
          ),
        );

      case LifeUseIconAnimMode.hyperVortex:
        return CustomPaint(
          size: Size(canvasSize, canvasSize),
          painter: _HyperVortexPainter(
            progress: _animModeController.value,
            hoverFactor: hoverFactor,
          ),
        );

      case LifeUseIconAnimMode.holographicSheen:
        return Container(
          width: widget.size * 1.35,
          height: widget.size * 1.35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryGlow.withValues(alpha: 0.35 + 0.25 * hoverFactor),
                Colors.transparent,
              ],
            ),
          ),
        );
    }
  }

  /// Builds the core 3D Glass Medallion Tile (Lightweight frosted glass squircle with bold definition)
  Widget _build3DGlassTile(double hoverFactor) {
    final tileSize = widget.size;
    final borderRadius = BorderRadius.circular(tileSize * 0.28);

    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          // 1. Deep Ambient Occlusion Contact Shadow (always rich, expands on hover)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.60 + 0.15 * hoverFactor),
            blurRadius: 26.0 + 12.0 * hoverFactor,
            offset: Offset(0, 8.0 + 4.0 * hoverFactor),
          ),
          // 2. Primary Bioluminescent Corona Glow (active at all times, flares on hover)
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45 + 0.35 * hoverFactor),
            blurRadius: 26.0 + 16.0 * hoverFactor,
            spreadRadius: 2.0 + 3.0 * hoverFactor,
          ),
          // 3. Electric Cyan Floor Bounce Glow
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.30 + 0.25 * hoverFactor),
            blurRadius: 24.0 + 12.0 * hoverFactor,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lightweight Frosted Obsidian Beveled Glass Base (Translucent & Sleek)
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xB31F2538), // Translucent frosted top (lightweight)
                  Color(0xCC10131E), // Frosted smoked mid
                  Color(0xE607080D), // Subtle dark base
                ],
              ),
              border: Border.all(
                color: Color.lerp(
                  Colors.white.withValues(alpha: 0.32),
                  AppColors.neonCyan,
                  0.35 + 0.65 * hoverFactor,
                )!,
                width: 1.1, // Slim, refined lightweight chamfer rim
              ),
            ),
          ),

          // High-Res 3D Fluid LU Ribbon Image (Without any text, bold & centered)
          ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(
              AppIcons.brandIconAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF0A0C13),
                child: Center(
                  child: Text(
                    'LU',
                    style: TextStyle(
                      fontSize: tileSize * 0.44,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Mode 2: Dynamic Holographic Light Sweep Across Glass
          if (widget.mode == LifeUseIconAnimMode.holographicSheen)
            ClipRRect(
              borderRadius: borderRadius,
              child: _buildHolographicSweep(tileSize),
            ),

          // Dynamic Specular Glare Reflection Arc (reacts in 3D to cursor tilt)
          Positioned(
            top: 3 - (_tiltY * 8.0 * hoverFactor),
            left: 4 + (_tiltX * 8.0 * hoverFactor),
            right: tileSize * 0.32 - (_tiltX * 8.0 * hoverFactor),
            height: tileSize * 0.32,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(tileSize * 0.26),
                  bottomRight: const Radius.circular(40),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.36 + 0.30 * hoverFactor),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the foreground effects based on active mode
  Widget _buildForegroundFX(double canvasSize, double hoverFactor) {
    if (widget.mode == LifeUseIconAnimMode.orbital3D) {
      return CustomPaint(
        size: Size(canvasSize, canvasSize),
        painter: _Orbital3DPainter(
          progress: _animModeController.value,
          hoverFactor: hoverFactor,
          isForeground: true,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// Prismatic diagonal sheen sweep for Mode 2
  Widget _buildHolographicSweep(double tileSize) {
    final sweepProgress = _animModeController.value;
    final sweepX = (sweepProgress * 3.0 - 1.0) * tileSize;

    return Transform.translate(
      offset: Offset(sweepX, -sweepX * 0.5),
      child: Transform.rotate(
        angle: -math.pi / 4.2,
        child: Container(
          width: tileSize * 0.38,
          height: tileSize * 2.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.15),
                AppColors.neonCyan.withValues(alpha: 0.45),
                AppColors.primaryLight.withValues(alpha: 0.55),
                Colors.white.withValues(alpha: 0.35),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PAINTER 1: 3D Keplerian Celestial Orbit with Comet Plasma Tails & Z-Ordering
// =============================================================================
class _Orbital3DPainter extends CustomPainter {
  final double progress;
  final double hoverFactor;
  final bool isForeground;

  _Orbital3DPainter({
    required this.progress,
    required this.hoverFactor,
    required this.isForeground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rx = size.width * (0.46 + 0.03 * hoverFactor);
    final ry = size.height * (0.28 + 0.02 * hoverFactor);
    const tiltAngle = -0.32; // ~18 deg orbital tilt

    // Draw orbital ellipse track on background pass
    if (!isForeground) {
      final trackPaint = Paint()
        ..color = Color.lerp(
          AppColors.primary.withValues(alpha: 0.35),
          AppColors.neonCyan.withValues(alpha: 0.70),
          hoverFactor,
        )!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 + 0.8 * hoverFactor;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(tiltAngle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        trackPaint,
      );

      // Micro-stardust nodes along the track
      const trackStars = 6;
      for (int i = 0; i < trackStars; i++) {
        final tAngle = (i * (math.pi * 2 / trackStars)) + (progress * math.pi);
        final sx = rx * math.cos(tAngle);
        final sy = ry * math.sin(tAngle);
        final starFade = (math.sin(tAngle * 2 + progress * 6).abs() * 0.5 + 0.5) * 0.7;
        final starPaint = Paint()
          ..color = (i % 2 == 0 ? AppColors.neonCyan : AppColors.amberGold).withValues(alpha: starFade)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
        canvas.drawCircle(Offset(sx, sy), 1.6, starPaint);
      }

      canvas.restore();
    }

    // 2 Celestial Entities: Amber Gold & Neon Cyan
    _drawParticle(
      canvas: canvas,
      center: center,
      rx: rx,
      ry: ry,
      tilt: tiltAngle,
      phaseOffset: 0.0,
      primaryColor: AppColors.amberGold,
      coreColor: Colors.white,
    );

    _drawParticle(
      canvas: canvas,
      center: center,
      rx: rx,
      ry: ry,
      tilt: tiltAngle,
      phaseOffset: math.pi,
      primaryColor: AppColors.neonCyan,
      coreColor: Colors.white,
    );
  }

  void _drawParticle({
    required Canvas canvas,
    required Offset center,
    required double rx,
    required double ry,
    required double tilt,
    required double phaseOffset,
    required Color primaryColor,
    required Color coreColor,
  }) {
    final angle = (progress * 2 * math.pi + phaseOffset) % (2 * math.pi);
    // Keplerian speed modulation (moves faster when close)
    final zDepth = math.sin(angle); // > 0 in front of tile, < 0 behind tile

    // Skip drawing if pass doesn't match z-order
    if (isForeground && zDepth < 0) return;
    if (!isForeground && zDepth >= 0) return;

    // Fading comet plasma tail (14 to 18 trailing segments)
    final tailSegments = 14 + (4 * hoverFactor).toInt();
    final tailLengthAngle = 0.55 + 0.22 * hoverFactor;

    for (int i = tailSegments; i >= 1; i--) {
      final tailT = i / tailSegments;
      final tAngle = angle - (tailT * tailLengthAngle);
      final rawX = rx * math.cos(tAngle);
      final rawY = ry * math.sin(tAngle);

      final rotX = rawX * math.cos(tilt) - rawY * math.sin(tilt);
      final rotY = rawX * math.sin(tilt) + rawY * math.cos(tilt);
      final pt = center + Offset(rotX, rotY);

      final tailAlpha = (1.0 - tailT) * (zDepth >= 0 ? (0.95 + 0.05 * hoverFactor) : (0.55 + 0.20 * hoverFactor));
      final tailRadius = (1.0 - tailT * 0.65) * (zDepth >= 0 ? 5.4 : 3.2) * (1.0 + 0.25 * hoverFactor);

      final tailPaint = Paint()
        ..color = primaryColor.withValues(alpha: tailAlpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.5 + 1.0 * hoverFactor);

      canvas.drawCircle(pt, tailRadius, tailPaint);
    }

    // Particle Head Position
    final rawX = rx * math.cos(angle);
    final rawY = ry * math.sin(angle);
    final rotX = rawX * math.cos(tilt) - rawY * math.sin(tilt);
    final rotY = rawX * math.sin(tilt) + rawY * math.cos(tilt);
    final headPt = center + Offset(rotX, rotY);

    final brightness = zDepth >= 0 ? 1.0 : 0.55;
    final headRadius = (zDepth >= 0 ? 6.0 : 3.8) * (1.0 + 0.25 * hoverFactor);

    // Outer Glow Bloom
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: (0.80 + 0.20 * hoverFactor) * brightness)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, (zDepth >= 0 ? 12.0 : 6.0) * (1.0 + 0.4 * hoverFactor));
    canvas.drawCircle(headPt, headRadius * 2.6, glowPaint);

    // Color Body
    final bodyPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.98 * brightness);
    canvas.drawCircle(headPt, headRadius, bodyPaint);

    // Brilliant White Core
    final corePaint = Paint()
      ..color = coreColor.withValues(alpha: 1.0 * brightness);
    canvas.drawCircle(headPt, headRadius * 0.58, corePaint);

    // Starburst cross-flare sparkle (active at all times, flares larger on hover)
    final sparkleAlpha = (0.50 + 0.45 * hoverFactor) * brightness;
    final sparklePaint = Paint()
      ..color = Colors.white.withValues(alpha: sparkleAlpha)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    final spLength = headRadius * (1.4 + 0.8 * hoverFactor);
    canvas.drawLine(headPt - Offset(spLength, 0), headPt + Offset(spLength, 0), sparklePaint);
    canvas.drawLine(headPt - Offset(0, spLength), headPt + Offset(0, spLength), sparklePaint);
  }

  @override
  bool shouldRepaint(covariant _Orbital3DPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.hoverFactor != hoverFactor ||
      oldDelegate.isForeground != isForeground;
}

// =============================================================================
// PAINTER 2: Bioluminescent Expanding Energy Shockwaves (Mode 1)
// =============================================================================
class _QuantumPulsePainter extends CustomPainter {
  final double progress;
  final double hoverFactor;

  _QuantumPulsePainter({required this.progress, required this.hoverFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * (0.48 + 0.06 * hoverFactor);

    for (int ring = 0; ring < 3; ring++) {
      final ringProgress = (progress + (ring / 3.0)) % 1.0;
      final currentRadius = size.width * 0.28 + ringProgress * (maxRadius - size.width * 0.28);
      final fade = math.sin(ringProgress * math.pi);

      final ringColor = ring % 2 == 0 ? AppColors.neonCyan : AppColors.primary;

      final ringPaint = Paint()
        ..color = ringColor.withValues(alpha: (0.60 + 0.25 * hoverFactor) * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (2.4 + 1.0 * hoverFactor) * fade + 0.6
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.8 + 2.0 * hoverFactor);

      canvas.drawCircle(center, currentRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _QuantumPulsePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.hoverFactor != hoverFactor;
}

// =============================================================================
// PAINTER 0: Cosmic Galactic Spiral Flow with Flowing Stars (Mode 0 - SHOWS FIRST!)
// =============================================================================
class _HyperVortexPainter extends CustomPainter {
  final double progress;
  final double hoverFactor;

  _HyperVortexPainter({required this.progress, required this.hoverFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final numArms = hoverFactor > 0.4 ? 6 : 4;
    final baseAngle = progress * 2 * math.pi;

    // 1. Soft Coronal Background Halo
    final haloPaint = Paint()
      ..color = AppColors.primaryGlow.withValues(alpha: 0.35 + 0.20 * hoverFactor)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20.0 + 8.0 * hoverFactor);
    canvas.drawCircle(center, size.width * 0.32, haloPaint);

    // 2. Cosmic Galactic Spiral Streams (Flowing arms rotating continuously)
    for (int arm = 0; arm < numArms; arm++) {
      final armAngle = baseAngle + (arm * (math.pi * 2 / numArms));
      final color = arm % 2 == 0 ? AppColors.neonCyan : AppColors.amberGold;

      final path = Path();
      final points = <Offset>[];
      const steps = 28;

      for (int step = 0; step <= steps; step++) {
        final t = step / steps.toDouble();
        final r = size.width * 0.22 + t * (size.width * (0.26 + 0.08 * hoverFactor));
        final theta = armAngle + (t * math.pi * (1.30 + 0.35 * hoverFactor));
        final x = center.dx + r * math.cos(theta);
        final y = center.dy + r * math.sin(theta);
        final pt = Offset(x, y);
        points.add(pt);

        if (step == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      // Outer glow ribbon
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.50 + 0.25 * hoverFactor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.6 + 1.4 * hoverFactor
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.2 + 1.2 * hoverFactor);
      canvas.drawPath(path, glowPaint);

      // Core sharp ribbon
      final corePaint = Paint()
        ..color = color.withValues(alpha: 0.85 + 0.15 * hoverFactor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + 0.8 * hoverFactor
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, corePaint);

      // White-hot center highlight along mid-stream
      final highlightPath = Path();
      final startStep = (steps * 0.25).toInt();
      final endStep = (steps * 0.85).toInt();
      for (int i = startStep; i <= endStep; i++) {
        if (i == startStep) {
          highlightPath.moveTo(points[i].dx, points[i].dy);
        } else {
          highlightPath.lineTo(points[i].dx, points[i].dy);
        }
      }
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.65 + 0.25 * hoverFactor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 + 0.4 * hoverFactor
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(highlightPath, highlightPaint);

      // 3. Flowing Star Node travelling along the stream
      final starT = ((progress * 1.2) + (arm / numArms.toDouble())) % 1.0;
      final starIndex = (starT * (points.length - 1)).clamp(0, points.length - 1).toInt();
      final starPt = points[starIndex];
      final starScale = (0.7 + 0.3 * math.sin(starT * math.pi)) * (1.0 + 0.25 * hoverFactor);

      // Star Glow
      final starGlowPaint = Paint()
        ..color = color.withValues(alpha: 0.75 + 0.25 * hoverFactor)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0 + 2.0 * hoverFactor);
      canvas.drawCircle(starPt, 4.5 * starScale, starGlowPaint);

      // Star Body
      final starBodyPaint = Paint()..color = color.withValues(alpha: 0.95);
      canvas.drawCircle(starPt, 2.8 * starScale, starBodyPaint);

      // White-hot Core
      final starCorePaint = Paint()..color = Colors.white;
      canvas.drawCircle(starPt, 1.4 * starScale, starCorePaint);

      // Star Sparkle Flare
      final flarePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.80)
        ..strokeWidth = 1.1
        ..style = PaintingStyle.stroke;
      final flLen = 3.8 * starScale;
      canvas.drawLine(starPt - Offset(flLen, 0), starPt + Offset(flLen, 0), flarePaint);
      canvas.drawLine(starPt - Offset(0, flLen), starPt + Offset(0, flLen), flarePaint);
    }

    // 4. Subtle Drifting Stardust Embers
    const stardustCount = 8;
    for (int i = 0; i < stardustCount; i++) {
      final dustAngle = baseAngle * 0.8 + (i * (math.pi * 2 / stardustCount));
      final dustRadius = size.width * (0.34 + 0.12 * math.sin(i * 1.7));
      final dustX = center.dx + dustRadius * math.cos(dustAngle);
      final dustY = center.dy + dustRadius * math.sin(dustAngle);
      final dustFade = (math.sin((progress * 4.0 + i) * math.pi).abs() * 0.70 + 0.30) * (0.60 + 0.40 * hoverFactor);
      final dustColor = i % 2 == 0 ? AppColors.neonCyan : AppColors.amberGold;

      final dustPaint = Paint()
        ..color = dustColor.withValues(alpha: dustFade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8);
      canvas.drawCircle(Offset(dustX, dustY), 1.8, dustPaint);

      final dustCore = Paint()..color = Colors.white.withValues(alpha: dustFade * 0.9);
      canvas.drawCircle(Offset(dustX, dustY), 0.9, dustCore);
    }
  }

  @override
  bool shouldRepaint(covariant _HyperVortexPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.hoverFactor != hoverFactor;
}

// =============================================================================
// BACKWARD-COMPATIBLE WRAPPERS FOR DIRECT USE OR TESTS
// =============================================================================
class PulseGlowIcon extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const PulseGlowIcon({super.key, this.size = 84, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LifeUse3DIcon(
      size: size,
      mode: LifeUseIconAnimMode.quantumPulse,
      onTap: onTap,
    );
  }
}

class OrbitalMotionIcon extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const OrbitalMotionIcon({super.key, this.size = 84, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LifeUse3DIcon(
      size: size,
      mode: LifeUseIconAnimMode.orbital3D,
      onTap: onTap,
    );
  }
}

class MorphShimmerIcon extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const MorphShimmerIcon({super.key, this.size = 84, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LifeUse3DIcon(
      size: size,
      mode: LifeUseIconAnimMode.holographicSheen,
      onTap: onTap,
    );
  }
}

class HyperVortexIcon extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const HyperVortexIcon({super.key, this.size = 84, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LifeUse3DIcon(
      size: size,
      mode: LifeUseIconAnimMode.hyperVortex,
      onTap: onTap,
    );
  }
}
