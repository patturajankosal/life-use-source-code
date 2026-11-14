import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable Enterprise Surface Card for LifeUse.
/// File: lib/core/widgets/app_card.dart
///
/// Encapsulates the Figma editorial card geometry:
/// - Adaptive light/dark surface background
/// - Subtle contrast beveled border
/// - Smooth ambient drop shadow
/// - Configurable padding and border radius
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BoxConstraints? constraints;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 36, 28, 12),
    this.borderRadius = 24.0,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    Widget cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
            blurRadius: 36,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (constraints != null) {
      cardWidget = ConstrainedBox(
        constraints: constraints!,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
