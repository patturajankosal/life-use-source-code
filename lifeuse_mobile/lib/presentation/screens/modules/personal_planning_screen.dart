import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
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
  bool isCompleted;

  _BucketListItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
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
  final List<_LifeGoalItem> _goals = const [
    _LifeGoalItem(
      id: 'g_1',
      title: 'Build 6-Month Emergency Cash Reserve',
      horizon: '2026 Goal',
      progress: 0.85,
      metric: '₹4.25L / ₹5.00L',
    ),
    _LifeGoalItem(
      id: 'g_2',
      title: 'Run First Half Marathon (21 km)',
      horizon: 'Q4 2026',
      progress: 0.65,
      metric: '14 km Longest Run',
    ),
    _LifeGoalItem(
      id: 'g_3',
      title: 'Deploy Production Multi-Platform App (LifeUse)',
      horizon: 'Core Milestone',
      progress: 0.95,
      metric: 'Phase 2 Architecture Ready',
    ),
  ];

  final List<_BucketListItem> _bucketList = [
    _BucketListItem(id: 'b_1', title: 'Trek the Annapurna Circuit in Himalayas', isCompleted: false),
    _BucketListItem(id: 'b_2', title: 'Scuba dive in Andaman coral reefs', isCompleted: true),
    _BucketListItem(id: 'b_3', title: 'Own a sustainable solar-powered modern home', isCompleted: false),
    _BucketListItem(id: 'b_4', title: 'Mentor 50 young engineering graduates', isCompleted: true),
  ];

  void _showAddGoalDialog() {
    final titleCtrl = TextEditingController();
    final horizCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Create Life Goal', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g. Master Machine Learning',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: horizCtrl,
              decoration: InputDecoration(
                labelText: 'Target Horizon',
                hintText: 'e.g. 2027 Milestone',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14B8A6),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
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
    const accentColor = Color(0xFF14B8A6);

    final completedBucket = _bucketList.where((b) => b.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Personal Planning',
          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 20),
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
                          color: accentColor.withValues(alpha: isDark ? 0.2 : 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(LucideIcons.compass, color: accentColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yearly Vision & Milestones',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '3 high-priority life goals actively in progress.',
                                style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const LifeUseBadge(text: 'ON TRACK', variant: LifeUseBadgeVariant.active),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Active Goals List
                  Text(
                    'Annual Milestones & Progress',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 12),

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
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    g.horizon,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              g.metric,
                              style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: g.progress,
                                minHeight: 8,
                                backgroundColor: borderColor,
                                valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
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
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      LifeUseBadge(
                        text: '$completedBucket/${_bucketList.length} ACHIEVED',
                        variant: LifeUseBadgeVariant.active,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bucketList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final item = _bucketList[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isCompleted,
                              activeColor: accentColor,
                              onChanged: (val) {
                                setState(() => item.isCompleted = val ?? false);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: item.isCompleted ? textSecondary : textPrimary,
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
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
