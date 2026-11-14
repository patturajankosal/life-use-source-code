import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Elevation levels matching shadcn card elevation tokens:
enum LifeUseCardElevation { none, xs, sm, md, lg }

/// Elevation-aware, interactive surface primitive for LifeUse application.
/// Matches React Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter.
/// File: lib/core/widgets/lifeuse_card.dart
class LifeUseCard extends StatefulWidget {
  final Widget child;
  final bool interactive;
  final LifeUseCardElevation elevation;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const LifeUseCard({
    super.key,
    required this.child,
    this.interactive = false,
    this.elevation = LifeUseCardElevation.xs,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  /// Structured helper constructor replicating CardHeader, Title, Description, Content, Footer
  factory LifeUseCard.structured({
    Key? key,
    required String title,
    String? description,
    Widget? headerTrailing,
    required Widget content,
    Widget? footer,
    bool interactive = false,
    LifeUseCardElevation elevation = LifeUseCardElevation.xs,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return LifeUseCard(
      key: key,
      interactive: interactive,
      elevation: elevation,
      onTap: onTap,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Title + Description + Trailing)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.005,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (headerTrailing != null) ...[
                const SizedBox(width: 12),
                headerTrailing,
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Content
          content,

          // Footer
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer,
          ],
        ],
      ),
    );
  }

  @override
  State<LifeUseCard> createState() => _LifeUseCardState();
}

class _LifeUseCardState extends State<LifeUseCard> {
  bool _isHoveredOrPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkBase0 : AppColors.base0);
    final bColor = widget.borderColor ??
        (isDark ? AppColors.darkBase100 : AppColors.base100);

    final finalRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final shadows = _getShadows(
      widget.elevation,
      isDark,
      _isHoveredOrPressed && widget.interactive,
    );

    return AnimatedScale(
      scale: _isHoveredOrPressed && widget.interactive ? 0.99 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: finalRadius,
          border: Border.all(color: bColor, width: 1.0),
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: finalRadius,
            onHighlightChanged: widget.interactive
                ? (highlighted) => setState(() => _isHoveredOrPressed = highlighted)
                : null,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  static List<BoxShadow>? _getShadows(
    LifeUseCardElevation elevation,
    bool isDark,
    bool isLifted,
  ) {
    if (isDark) return null;

    if (isLifted) {
      return const [
        BoxShadow(
          color: Color(0x1409121B),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ];
    }

    switch (elevation) {
      case LifeUseCardElevation.none:
        return null;
      case LifeUseCardElevation.xs:
        return const [
          BoxShadow(
            color: Color(0x0F09121B),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ];
      case LifeUseCardElevation.sm:
        return const [
          BoxShadow(
            color: Color(0x0D09121B),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x0A09121B),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ];
      case LifeUseCardElevation.md:
        return const [
          BoxShadow(
            color: Color(0x1409121B),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ];
      case LifeUseCardElevation.lg:
        return const [
          BoxShadow(
            color: Color(0x1A09121B),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ];
    }
  }
}
