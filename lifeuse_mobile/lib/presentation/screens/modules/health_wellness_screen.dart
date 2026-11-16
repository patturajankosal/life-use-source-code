import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _WorkoutLog {
  final String id;
  final String activity;
  final String duration;
  final int calories;
  final IconData icon;
  bool isCompleted;

  _WorkoutLog({
    required this.id,
    required this.activity,
    required this.duration,
    required this.calories,
    required this.icon,
    this.isCompleted = false,
  });
}

/// Interactive Health & Wellness micro-app screen.
/// Tracks water intake, workout logs, sleep, and vitals.
class HealthWellnessScreen extends StatefulWidget {
  const HealthWellnessScreen({super.key});

  @override
  State<HealthWellnessScreen> createState() => _HealthWellnessScreenState();
}

class _HealthWellnessScreenState extends State<HealthWellnessScreen> {
  int _waterIntakeMl = 0;
  static const int _waterGoalMl = 3000;

  final List<_WorkoutLog> _workouts = [];

  void _addWater(int amount) {
    setState(() {
      _waterIntakeMl = (_waterIntakeMl + amount).clamp(0, 5000);
    });
  }

  void _showAddWorkoutDialog() {
    final nameCtrl = TextEditingController();
    final durCtrl = TextEditingController();
    final calCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Log Workout Session',
          style: AppFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Activity Name',
                hintText: 'e.g. Cycling / Swimming',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durCtrl,
              decoration: InputDecoration(
                labelText: 'Duration',
                hintText: 'e.g. 30 mins',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Estimated Calories',
                hintText: 'e.g. 250',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _workouts.add(
                    _WorkoutLog(
                      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                      activity: nameCtrl.text.trim(),
                      duration: durCtrl.text.trim().isEmpty
                          ? '20 mins'
                          : durCtrl.text.trim(),
                      calories: int.tryParse(calCtrl.text) ?? 150,
                      icon: AppIcons.healthWellness,
                      isCompleted: true,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Log Workout'),
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
    const accentColor = Color(0xFFF43F5E);

    final waterRatio = (_waterIntakeMl / _waterGoalMl).clamp(0.0, 1.0);
    final totalCalories = _workouts
        .where((w) => w.isCompleted)
        .fold(0, (sum, w) => sum + w.calories);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Health & Wellness',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.plus, size: 20),
            tooltip: 'Log Workout',
            onPressed: _showAddWorkoutDialog,
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
                  // 1. Water Intake Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue
                              .withValues(alpha: isDark ? 0.2 : 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.iconBackgroundOf(context),
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                      color: AppColors.iconBorderOf(context),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppIcon(
                                      AppIcons.water,
                                      color: AppColors.brandIconOf(context),
                                      size: 21,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Hydration',
                                      style: AppFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Target: 3,000 ml',
                                      style: AppFonts.inter(
                                          fontSize: 12, color: textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            LifeUseBadge(
                              text: '${(waterRatio * 100).toInt()}% REACHED',
                              variant: waterRatio >= 1.0
                                  ? LifeUseBadgeVariant.active
                                  : LifeUseBadgeVariant.pending,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: waterRatio,
                            minHeight: 12,
                            backgroundColor: borderColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_waterIntakeMl / $_waterGoalMl ml',
                              style: AppFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _addWater(250),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                  ),
                                  child: const Text('+250 ml'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _addWater(500),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                  ),
                                  child: const Text('+500 ml'),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.minusCircle,
                                      size: 20),
                                  onPressed: _waterIntakeMl > 0
                                      ? () => _addWater(-250)
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Vitals Quick Strip
                  Row(
                    children: [
                      Expanded(
                        child: _buildVitalTile(
                          context,
                          'Active Cal',
                          '$totalCalories kcal',
                          LucideIcons.flame,
                          AppColors.brandIconOf(context),
                          surfaceColor,
                          borderColor,
                          textPrimary,
                          textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVitalTile(
                          context,
                          'Restful Sleep',
                          '7h 45m',
                          LucideIcons.moon,
                          AppColors.brandIconOf(context),
                          surfaceColor,
                          borderColor,
                          textPrimary,
                          textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVitalTile(
                          context,
                          'Heart Rate',
                          '72 bpm',
                          LucideIcons.heartPulse,
                          AppColors.brandIconOf(context),
                          surfaceColor,
                          borderColor,
                          textPrimary,
                          textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Workouts Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Exercise Logs',
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        icon: const AppIcon(AppIcons.plus, size: 16),
                        label: const Text('Log Workout'),
                        onPressed: _showAddWorkoutDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (_workouts.isEmpty)
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
                                AppIcons.fitness,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Workouts Logged Today',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Keep track of your exercises and workouts here.\nTap \'Log Workout\' above to record your session.',
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
                    itemCount: _workouts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final w = _workouts[i];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.iconBackgroundOf(context),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: AppColors.iconBorderOf(context),
                                ),
                              ),
                              child: Center(
                                child: AppIcon(w.icon,
                                    color: AppColors.brandIconOf(context),
                                    size: 21),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.activity,
                                    style: AppFonts.inter(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                      decoration: w.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${w.duration} • ${w.calories} kcal burned',
                                    style: AppFonts.inter(
                                        fontSize: 12, color: textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: w.isCompleted,
                              activeColor: accentColor,
                              onChanged: (val) {
                                setState(() => w.isCompleted = val ?? false);
                              },
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

  Widget _buildVitalTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.iconBackgroundOf(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.iconBorderOf(context)),
            ),
            child: Center(
              child: AppIcon(icon, size: 17, color: iconColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppFonts.inter(fontSize: 11, color: textSecondary),
          ),
        ],
      ),
    );
  }
}
