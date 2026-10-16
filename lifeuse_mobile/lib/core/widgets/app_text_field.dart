import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Clean modern form field with LifeUse design tokens:
/// - Inter typography for label and input
/// - Precise label color (#4D4D4D in Light, #E6E6E6 in Dark) matching user spec
/// - 1px solid #E6E6E6 border with subtle 0 1px 2px box shadow
/// - Touch-to-peek password visibility
/// File: lib/core/widgets/app_text_field.dart
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = AppColors.textSecondaryOf(context);

    // LifeUse Tokens
    final surfaceColor = isDark ? AppColors.darkBase50 : AppColors.base0;
    final borderColor = isDark ? AppColors.darkBase100 : AppColors.base100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Field Label (Inter, SemiBold 600, #4D4D4D / #E6E6E6) ---
        Text(
          widget.label,
          style: AppTypography.inputLabel(context),
        ),
        const SizedBox(height: 7),

        // --- 2. Input Box with LifeUse Shadow & Border ---
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x14808080), // 10% shadow per Figma token
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            style: AppTypography.inputValue(context),
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              hintText: widget.hint,
              hintStyle: AppTypography.inputHint(context),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 20, color: textSecondary)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.error, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.error, width: 1.6),
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) {
                        setState(() {
                          _obscureText = false;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _obscureText = true;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _obscureText = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _obscureText
                              ? textSecondary
                              : AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
