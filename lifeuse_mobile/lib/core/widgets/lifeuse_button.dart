import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Button visual variants matching shadcn / CVA specification:
enum LifeUseButtonVariant {
  defaultVariant,
  destructive,
  outline,
  secondary,
  ghost,
  link,
  tonal,
  success,
  warning,
}

/// Button size variants:
enum LifeUseButtonSize {
  sm,
  defaultSize,
  lg,
  xl,
  icon,
}

/// Highly dynamic, responsive, elevation-aware action button for LifeUse:
/// - Replicates shadcn CVA variants & sizes with interactive press scale (0.98x)
/// - Pure Inter typography
/// - Prefix/Suffix icons, loading state spinner, disabled states
/// File: lib/core/widgets/lifeuse_button.dart
class LifeUseButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPressed;
  final LifeUseButtonVariant variant;
  final LifeUseButtonSize size;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const LifeUseButton({
    super.key,
    this.title,
    required this.onPressed,
    this.variant = LifeUseButtonVariant.defaultVariant,
    this.size = LifeUseButtonSize.defaultSize,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius,
  });

  /// Quick constructors for frequent patterns
  const LifeUseButton.destructive({
    super.key,
    required String this.title,
    required this.onPressed,
    this.size = LifeUseButtonSize.defaultSize,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = LifeUseButtonVariant.destructive;

  const LifeUseButton.outline({
    super.key,
    required String this.title,
    required this.onPressed,
    this.size = LifeUseButtonSize.defaultSize,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius,
  }) : variant = LifeUseButtonVariant.outline;

  const LifeUseButton.icon({
    super.key,
    required Widget child,
    required this.onPressed,
    this.variant = LifeUseButtonVariant.defaultVariant,
    this.size = LifeUseButtonSize.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : title = null,
        prefixIcon = child,
        suffixIcon = null;

  @override
  State<LifeUseButton> createState() => _LifeUseButtonState();
}

class _LifeUseButtonState extends State<LifeUseButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final config = _getStyleConfig(widget.variant, isDark);
    final sizeMetrics = _getSizeMetrics(widget.size);

    final finalBorderRadius = widget.borderRadius ??
        BorderRadius.circular(sizeMetrics.borderRadius);

    return AnimatedScale(
      scale: _isPressed && isEnabled ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Container(
            width: widget.width,
            height: widget.height ?? sizeMetrics.height,
            constraints: widget.size == LifeUseButtonSize.icon
                ? BoxConstraints.tightFor(
                    width: widget.width ?? sizeMetrics.height,
                    height: widget.height ?? sizeMetrics.height,
                  )
                : null,
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: finalBorderRadius,
              border: config.borderColor != null
                  ? Border.all(color: config.borderColor!, width: 1.0)
                  : null,
              boxShadow: config.hasShadow && !isDark && isEnabled
                  ? [
                      const BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isEnabled ? widget.onPressed : null,
                borderRadius: finalBorderRadius,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.size == LifeUseButtonSize.icon
                        ? 0
                        : sizeMetrics.horizontalPadding,
                  ),
                  child: Row(
                    mainAxisSize: widget.width != null ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.isLoading) ...[
                        SizedBox(
                          width: sizeMetrics.iconSize,
                          height: sizeMetrics.iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(config.textColor),
                          ),
                        ),
                        if (widget.title != null) const SizedBox(width: 8),
                      ] else if (widget.prefixIcon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            size: sizeMetrics.iconSize,
                            color: config.textColor,
                          ),
                          child: widget.prefixIcon!,
                        ),
                        if (widget.title != null) const SizedBox(width: 8),
                      ],
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: GoogleFonts.inter(
                            fontSize: sizeMetrics.fontSize,
                            fontWeight: FontWeight.w600,
                            color: config.textColor,
                            decoration: widget.variant == LifeUseButtonVariant.link
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      if (widget.suffixIcon != null && !widget.isLoading) ...[
                        const SizedBox(width: 8),
                        IconTheme(
                          data: IconThemeData(
                            size: sizeMetrics.iconSize,
                            color: config.textColor,
                          ),
                          child: widget.suffixIcon!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static _ButtonConfig _getStyleConfig(LifeUseButtonVariant variant, bool isDark) {
    switch (variant) {
      case LifeUseButtonVariant.defaultVariant:
        return const _ButtonConfig(
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          hasShadow: true,
        );
      case LifeUseButtonVariant.destructive:
        return const _ButtonConfig(
          backgroundColor: AppColors.error,
          textColor: Colors.white,
          hasShadow: true,
        );
      case LifeUseButtonVariant.outline:
        return _ButtonConfig(
          backgroundColor: isDark ? AppColors.darkBase0 : AppColors.base0,
          borderColor: isDark ? AppColors.darkBase100 : AppColors.base100,
          textColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          hasShadow: true,
        );
      case LifeUseButtonVariant.secondary:
        return _ButtonConfig(
          backgroundColor: isDark ? AppColors.darkBase50 : const Color(0xFFF4F5F5),
          textColor: isDark ? AppColors.darkTextPrimary : const Color(0xFF282D2D),
          hasShadow: true,
        );
      case LifeUseButtonVariant.ghost:
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          hasShadow: false,
        );
      case LifeUseButtonVariant.link:
        return const _ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          hasShadow: false,
        );
      case LifeUseButtonVariant.tonal:
        return _ButtonConfig(
          backgroundColor: isDark ? const Color(0xFF0C3E20) : const Color(0xFFDCFCE7),
          textColor: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
          hasShadow: false,
        );
      case LifeUseButtonVariant.success:
        return const _ButtonConfig(
          backgroundColor: AppColors.success,
          textColor: Colors.white,
          hasShadow: true,
        );
      case LifeUseButtonVariant.warning:
        return const _ButtonConfig(
          backgroundColor: AppColors.warning,
          textColor: Colors.white,
          hasShadow: true,
        );
    }
  }

  static _ButtonSizeMetrics _getSizeMetrics(LifeUseButtonSize size) {
    switch (size) {
      case LifeUseButtonSize.sm:
        return const _ButtonSizeMetrics(
          height: 32,
          horizontalPadding: 12,
          fontSize: 12,
          iconSize: 14,
          borderRadius: 8,
        );
      case LifeUseButtonSize.defaultSize:
        return const _ButtonSizeMetrics(
          height: 40,
          horizontalPadding: 16,
          fontSize: 13.5,
          iconSize: 16,
          borderRadius: 10,
        );
      case LifeUseButtonSize.lg:
        return const _ButtonSizeMetrics(
          height: 46,
          horizontalPadding: 24,
          fontSize: 14.5,
          iconSize: 18,
          borderRadius: 12,
        );
      case LifeUseButtonSize.xl:
        return const _ButtonSizeMetrics(
          height: 52,
          horizontalPadding: 28,
          fontSize: 15.5,
          iconSize: 20,
          borderRadius: 14,
        );
      case LifeUseButtonSize.icon:
        return const _ButtonSizeMetrics(
          height: 40,
          horizontalPadding: 0,
          fontSize: 14,
          iconSize: 18,
          borderRadius: 10,
        );
    }
  }
}

class _ButtonConfig {
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final bool hasShadow;

  const _ButtonConfig({
    required this.backgroundColor,
    this.borderColor,
    required this.textColor,
    this.hasShadow = false,
  });
}

class _ButtonSizeMetrics {
  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  const _ButtonSizeMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}
