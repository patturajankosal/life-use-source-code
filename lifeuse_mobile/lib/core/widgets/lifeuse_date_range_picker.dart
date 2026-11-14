import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Preset date range options matching the specification:
enum LifeUseDatePreset {
  today,
  yesterday,
  last7Days,
  last30Days,
  thisMonth,
  lastMonth,
  custom,
}

/// Date range result container
class LifeUseDateRange {
  final DateTime start;
  final DateTime end;
  final LifeUseDatePreset? preset;

  const LifeUseDateRange({
    required this.start,
    required this.end,
    this.preset,
  });

  String get formattedRange {
    return '${_format(start)} → ${_format(end)}';
  }

  static String _format(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

/// Dynamic, responsive Date Range Picker for LifeUse application.
/// Replicates the dual-mode component:
/// 1. Preset Quick Select View (Today, Yesterday, Last 7 Days, This Month, Custom...)
/// 2. Interactive Calendar Matrix View with dual pill headers, Month/Year selectors,
///    purple gradient range highlights, and Apply/Clear actions.
/// File: lib/core/widgets/lifeuse_date_range_picker.dart
class LifeUseDateRangePicker extends StatefulWidget {
  final LifeUseDateRange? initialRange;
  final ValueChanged<LifeUseDateRange> onSelectRange;
  final VoidCallback? onClear;
  final VoidCallback? onRequestClose;

  const LifeUseDateRangePicker({
    super.key,
    this.initialRange,
    required this.onSelectRange,
    this.onClear,
    this.onRequestClose,
  });

  /// Static helper to show picker in a responsive modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    LifeUseDateRange? initialRange,
    required ValueChanged<LifeUseDateRange> onSelectRange,
    VoidCallback? onClear,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: LifeUseDateRangePicker(
              initialRange: initialRange,
              onSelectRange: (range) {
                onSelectRange(range);
                Navigator.of(ctx).pop();
              },
              onClear: () {
                onClear?.call();
                Navigator.of(ctx).pop();
              },
              onRequestClose: () => Navigator.of(ctx).pop(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<LifeUseDateRangePicker> createState() => _LifeUseDateRangePickerState();
}

class _LifeUseDateRangePickerState extends State<LifeUseDateRangePicker> {
  bool _isCustomMode = false;

  late DateTime _selectedStart;
  late DateTime _selectedEnd;
  DateTime? _tempSelectingStart;

  late DateTime _viewMonth;
  LifeUseDatePreset _activePreset = LifeUseDatePreset.today;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedStart = widget.initialRange?.start ?? now;
    _selectedEnd = widget.initialRange?.end ?? now;
    _viewMonth = DateTime(_selectedStart.year, _selectedStart.month, 1);
    _activePreset = widget.initialRange?.preset ?? LifeUseDatePreset.today;
  }

  void _handlePresetSelect(LifeUseDatePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (preset == LifeUseDatePreset.custom) {
      setState(() => _isCustomMode = true);
      return;
    }

    DateTime start = today;
    DateTime end = today;

    switch (preset) {
      case LifeUseDatePreset.today:
        start = today;
        end = today;
        break;
      case LifeUseDatePreset.yesterday:
        start = today.subtract(const Duration(days: 1));
        end = today.subtract(const Duration(days: 1));
        break;
      case LifeUseDatePreset.last7Days:
        start = today.subtract(const Duration(days: 6));
        end = today;
        break;
      case LifeUseDatePreset.last30Days:
        start = today.subtract(const Duration(days: 29));
        end = today;
        break;
      case LifeUseDatePreset.thisMonth:
        start = DateTime(today.year, today.month, 1);
        end = today;
        break;
      case LifeUseDatePreset.lastMonth:
        final lastMonth = DateTime(today.year, today.month - 1, 1);
        start = lastMonth;
        end = DateTime(today.year, today.month, 0);
        break;
      case LifeUseDatePreset.custom:
        break;
    }

    _activePreset = preset;
    widget.onSelectRange(LifeUseDateRange(start: start, end: end, preset: preset));
  }

  void _handleDayTap(DateTime day) {
    setState(() {
      if (_tempSelectingStart == null) {
        _tempSelectingStart = day;
        _selectedStart = day;
        _selectedEnd = day;
      } else {
        if (day.isBefore(_tempSelectingStart!)) {
          _selectedStart = day;
          _selectedEnd = _tempSelectingStart!;
        } else {
          _selectedStart = _tempSelectingStart!;
          _selectedEnd = day;
        }
        _tempSelectingStart = null;
      }
    });
  }

  void _applyCustom() {
    widget.onSelectRange(
      LifeUseDateRange(
        start: _selectedStart,
        end: _selectedEnd,
        preset: LifeUseDatePreset.custom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      width: _isCustomMode ? 340 : 200,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.all(_isCustomMode ? 16 : 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(_isCustomMode ? 24 : 20),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: _isCustomMode ? _buildCalendarView(isDark) : _buildPresetsView(isDark),
    );
  }

  // ── VIEW 1: PRESET LIST VIEW ──────────────────────────────────────────────
  Widget _buildPresetsView(bool isDark) {
    final presets = [
      {'label': 'Today', 'value': LifeUseDatePreset.today},
      {'label': 'Yesterday', 'value': LifeUseDatePreset.yesterday},
      {'label': 'Last 7 days', 'value': LifeUseDatePreset.last7Days},
      {'label': 'Last 30 days', 'value': LifeUseDatePreset.last30Days},
      {'label': 'This Month', 'value': LifeUseDatePreset.thisMonth},
      {'label': 'Last Month', 'value': LifeUseDatePreset.lastMonth},
      {'label': 'Custom...', 'value': LifeUseDatePreset.custom},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: presets.map((p) {
        final val = p['value'] as LifeUseDatePreset;
        final isSelected = _activePreset == val;

        return InkWell(
          onTap: () => _handlePresetSelect(val),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              p['label'] as String,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── VIEW 2: DUAL CALENDAR RANGE VIEW ──────────────────────────────────────
  Widget _buildCalendarView(bool isDark) {
    const weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Dual Date Pill Range Display
        Row(
          children: [
            Expanded(
              child: _buildDatePill(_selectedStart, isDark),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ),
            Expanded(
              child: _buildDatePill(_selectedEnd, isDark),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. Month & Year Navigation Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              onPressed: () {
                setState(() {
                  _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1);
                });
              },
            ),
            Text(
              '${_getMonthName(_viewMonth.month)} ${_viewMonth.year}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              onPressed: () {
                setState(() {
                  _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 3. Weekday Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((d) {
            return SizedBox(
              width: 38,
              child: Text(
                d,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),

        // 4. Days Matrix
        _buildDaysGrid(isDark),
        const SizedBox(height: 14),

        // 5. Actions Footer (Clear, Cancel, Apply)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.onClear != null)
              TextButton(
                onPressed: widget.onClear,
                child: Text(
                  'Clear',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              )
            else
              const SizedBox(),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _isCustomMode = false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    elevation: 0,
                  ),
                  onPressed: _applyCustom,
                  child: Text(
                    'Apply',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePill(DateTime date, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        LifeUseDateRange._format(date),
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildDaysGrid(bool isDark) {
    final firstDayOfMonth = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final totalCells = ((startWeekday + daysInMonth + 6) ~/ 7) * 7;

    return Wrap(
      children: List.generate(totalCells, (index) {
        final dayNumber = index - startWeekday + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox(width: 44, height: 36);
        }

        final cellDate = DateTime(_viewMonth.year, _viewMonth.month, dayNumber);
        final isStart = _isSameDay(cellDate, _selectedStart);
        final isEnd = _isSameDay(cellDate, _selectedEnd);
        final isInRange = cellDate.isAfter(_selectedStart) && cellDate.isBefore(_selectedEnd);

        Color? cellBg;
        if (isStart || isEnd) {
          cellBg = AppColors.primary;
        } else if (isInRange) {
          cellBg = isDark
              ? const Color(0xFF2E1065)
              : const Color(0xFFF3E8FF);
        }

        Color textColor;
        if (isStart || isEnd) {
          textColor = Colors.white;
        } else if (isInRange) {
          textColor = isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6B21A8);
        } else {
          textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
        }

        return GestureDetector(
          onTap: () => _handleDayTap(cellDate),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 44,
            height: 36,
            decoration: BoxDecoration(
              color: cellBg,
              borderRadius: isStart && isEnd
                  ? BorderRadius.circular(18)
                  : isStart
                      ? const BorderRadius.horizontal(left: Radius.circular(18))
                      : isEnd
                          ? const BorderRadius.horizontal(right: Radius.circular(18))
                          : null,
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: isStart || isEnd ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
