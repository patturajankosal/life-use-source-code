import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _LifeGoalItem {
  final String id;
  final String title;
  final String horizon;
  final double progress;
  final String metric;

  const _LifeGoalItem({
    required this.id,
    required this.title,
    required this.horizon,
    required this.progress,
    required this.metric,
  });
}

class _BucketListItem {
  final String id;
  final String title;
  bool isCompleted = false;

  _BucketListItem({
    required this.id,
    required this.title,
  });
}

/// Interactive Personal Planning micro-app screen.
/// Tracks multi-year vision, annual milestones, and bucket list adventures.
class PersonalPlanningScreen extends StatefulWidget {
  const PersonalPlanningScreen({super.key});

  @override
  State<PersonalPlanningScreen> createState() => _PersonalPlanningScreenState();
}

class _PersonalPlanningScreenState extends State<PersonalPlanningScreen> {
  final List<_LifeGoalItem> _goals = [];
  final List<_BucketListItem> _bucketList = [];

  void _showAddGoalDialog() {
    final titleCtrl = TextEditingController();
    final horizCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Create Life Goal',
            style: AppFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g. Master Machine Learning',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: horizCtrl,
              decoration: InputDecoration(
                labelText: 'Target Horizon',
                hintText: 'e.g. 2027 Milestone',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14B8A6),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _goals.add(
                    _LifeGoalItem(
                      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      horizon: horizCtrl.text.trim().isEmpty
                          ? '2026 Milestone'
                          : horizCtrl.text.trim(),
                      progress: 0.0,
                      metric: 'Target Set',
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New Life Goal added to vision board'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    const primaryColor = AppColors.primary;

    final completedBucket = _bucketList.where((b) => b.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Personal Planning',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.plus, size: 20),
            tooltip: 'Add Goal',
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Vision Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.20 : 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.iconBackgroundOf(context),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.iconBorderOf(context),
                            ),
                          ),
                          child: Center(
                            child: AppIcon(
                              AppIcons.personalPlanning,
                              color: AppColors.brandIconOf(context),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yearly Vision & Milestones',
                                style: AppFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_goals.length} high-priority life goals actively in progress.',
                                style: AppFonts.inter(
                                    fontSize: 12.5, color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                        LifeUseBadge(
                            text: _goals.isNotEmpty ? 'ON TRACK' : 'PLANNING',
                            variant: LifeUseBadgeVariant.active),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Active Goals List
                  Text(
                    'Annual Milestones & Progress',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 12),

                  if (_goals.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 36),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.iconBackgroundOf(context),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.iconBorderOf(context),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: AppIcon(
                                AppIcons.personalPlanning,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Goals Created Yet',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Set long-term targets, milestones, and habit horizons to visualize your vision.\nTap \'+\' in the header to create a goal.',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _goals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final g = _goals[i];
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    g.title,
                                    style: AppFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    g.horizon,
                                    style: AppFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              g.metric,
                              style: AppFonts.inter(
                                  fontSize: 12.5, color: textSecondary),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: g.progress,
                                minHeight: 8,
                                backgroundColor: borderColor,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    primaryColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 3. Bucket List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Life Bucket List',
                        style: AppFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary),
                      ),
                      LifeUseBadge(
                        text: '$completedBucket/${_bucketList.length} ACHIEVED',
                        variant: LifeUseBadgeVariant.active,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (_bucketList.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 36),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.iconBackgroundOf(context),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.iconBorderOf(context),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: AppIcon(
                                AppIcons.personalPlanning,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bucket List Empty',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Add dream experiences, adventures, and lifetime aspirations.',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bucketList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final item = _bucketList[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isCompleted,
                              activeColor: primaryColor,
                              onChanged: (val) {
                                setState(() => item.isCompleted = val ?? false);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                style: AppFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: item.isCompleted
                                      ? textSecondary
                                      : textPrimary,
                                  decoration: item.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 250.ms),
        ),
      ),
    );
  }
}
