import 'package:flutter/material.dart';

/// The official LifeUse Brand Wordmark using the exact custom stencil typeface
/// with stylized 3-horizontal-line 'E' letterforms (transparent background, adaptive dark/light mode tint).
class LifeUseWordmark extends StatelessWidget {
  final double height;
  final Color? color;
  final bool isDark;

  const LifeUseWordmark({
    super.key,
    this.height = 22,
    this.color,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic adaptive color for dark vs light mode
    final effectiveColor = color ??
        (isDark ? Colors.white : const Color(0xFF0F172A));

    return Image.asset(
      'assets/images/lifeuse_wordmark.png',
      height: height,
      fit: BoxFit.contain,
      color: effectiveColor,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.high,
    );
  }
}
