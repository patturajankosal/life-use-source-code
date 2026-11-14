import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Item model for LifeUseSelect
class LifeUseSelectItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final String? subtitle;
  final bool disabled;

  const LifeUseSelectItem({
    required this.value,
    required this.label,
    this.icon,
    this.subtitle,
    this.disabled = false,
  });
}

/// Dynamic, responsive Select / Dropdown component for LifeUse application.
/// Replicates Radix Select (SelectTrigger, SelectContent, SelectItem) for mobile:
/// - 12px rounded trigger with 0 1px 2px subtle shadow
/// - 16px rounded modal picker with search and check indicator
/// - Inter typography: 13px font-medium
/// File: lib/core/widgets/lifeuse_select.dart
class LifeUseSelect<T> extends StatelessWidget {
  final String? label;
  final String placeholder;
  final T? selectedValue;
  final List<LifeUseSelectItem<T>> items;
  final ValueChanged<T> onSelected;
  final bool enabled;
  final String? Function(T?)? validator;

  const LifeUseSelect({
    super.key,
    this.label,
    this.placeholder = 'Select an option',
    required this.selectedValue,
    required this.items,
    required this.onSelected,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final triggerBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF333333) : const Color(0xFFE6E6E6);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    final selectedItem = items.cast<LifeUseSelectItem<T>?>().firstWhere(
          (item) => item?.value == selectedValue,
          orElse: () => null,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.inputLabelOf(context),
            ),
          ),
          const SizedBox(height: 7),
        ],

        // Trigger Box
        GestureDetector(
          onTap: enabled ? () => _showPicker(context) : null,
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: triggerBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1.0),
                boxShadow: isDark
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x10808080),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  if (selectedItem?.icon != null) ...[
                    selectedItem!.icon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      selectedItem != null ? selectedItem.label : placeholder,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selectedItem != null
                            ? textColor
                            : (isDark ? const Color(0xFFA3A3A3) : const Color(0xFF808080)),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isDark ? const Color(0xFFA3A3A3) : const Color(0xFF808080),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: isDark ? const Color(0xFF333333) : const Color(0xFFE6E6E6),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24000000),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 8),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Sheet Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label ?? placeholder,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                        color: isDark ? const Color(0xFFA3A3A3) : const Color(0xFF808080),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Items List
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = item.value == selectedValue;

                      return InkWell(
                        onTap: item.disabled
                            ? null
                            : () {
                                onSelected(item.value);
                                Navigator.pop(ctx);
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF262626) : const Color(0xFFF8F8F8))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
                                    width: 1.0,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                item.icon!,
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                        color: item.disabled
                                            ? Colors.grey
                                            : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                                      ),
                                    ),
                                    if (item.subtitle != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle!,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: isDark ? Colors.grey : const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
