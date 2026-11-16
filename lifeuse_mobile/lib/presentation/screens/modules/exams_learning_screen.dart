import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _CourseItem {
  final String id;
  final String title;
  final String platform;
  final double progress;
  final String targetExamDate;
  final int daysLeft;

  const _CourseItem({
    required this.id,
    required this.title,
    required this.platform,
    required this.progress,
    required this.targetExamDate,
    required this.daysLeft,
  });
}

class _Flashcard {
  final String question;
  final String answer;
  bool isFlipped = false;

  _Flashcard({
    required this.question,
    required this.answer,
  });
}

/// Interactive Exams & Learning micro-app screen.
/// Includes course trackers, exam countdowns, flashcards, and study timers.
class ExamsLearningScreen extends StatefulWidget {
  const ExamsLearningScreen({super.key});

  @override
  State<ExamsLearningScreen> createState() => _ExamsLearningScreenState();
}

class _ExamsLearningScreenState extends State<ExamsLearningScreen> {
  final List<_CourseItem> _courses = [];
  int _currentCardIdx = 0;
  final List<_Flashcard> _flashcards = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    const primaryColor = AppColors.primary;

    final card = _flashcards.isNotEmpty
        ? _flashcards[_currentCardIdx.clamp(0, _flashcards.length - 1)]
        : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Exams & Learning',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
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
                  // 1. Spaced Repetition Flashcard Interactive Card
                  if (card == null)
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
                                AppIcons.examsLearning,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Revision Flashcards',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Add quick question-and-answer revision cards for active spaced repetition.',
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
                    Container(
                    padding: const EdgeInsets.all(22),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AppIcon(AppIcons.examsLearning,
                                    color: AppColors.iconOf(context), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Daily Revision Flashcard',
                                  style: AppFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            LifeUseBadge(
                              text:
                                  '${_currentCardIdx + 1} / ${_flashcards.length}',
                              variant: LifeUseBadgeVariant.active,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Question / Answer Flip Container
                        InkWell(
                          onTap: () {
                            setState(() => card.isFlipped = !card.isFlipped);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: card.isFlipped
                                  ? (isDark
                                      ? const Color(0xFF262626)
                                      : const Color(0xFFF7F7F8))
                                  : (isDark
                                      ? const Color(0xFF1E1E1E)
                                      : const Color(0xFFFAFAFA)),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: card.isFlipped
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : borderColor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.isFlipped
                                      ? 'ANSWER'
                                      : 'QUESTION (Tap to flip)',
                                  style: AppFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: card.isFlipped
                                        ? primaryColor
                                        : textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card.isFlipped ? card.answer : card.question,
                                  style: AppFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.45,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Flashcard controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: const AppIcon(AppIcons.refresh, size: 14),
                              label: Text(card.isFlipped
                                  ? 'Show Question'
                                  : 'Reveal Answer'),
                              onPressed: () {
                                setState(
                                    () => card.isFlipped = !card.isFlipped);
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              icon: const AppIcon(AppIcons.arrowRight,
                                  size: 14, color: Colors.white),
                              label: const Text('Next Card'),
                              onPressed: () {
                                setState(() {
                                  card.isFlipped = false;
                                  _currentCardIdx = (_currentCardIdx + 1) %
                                      _flashcards.length;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Courses & Exam Countdowns
                  Text(
                    'Active Study Plans & Exam Countdowns',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 12),

                  if (_courses.isEmpty)
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
                                AppIcons.examsLearning,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Enrolled Courses or Exams',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Track certification targets, milestones, and syllabus completion here.',
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
                    itemCount: _courses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final c = _courses[i];
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
                                    c.title,
                                    style: AppFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${c.daysLeft}d LEFT',
                                    style: AppFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${c.platform} • Target: ${c.targetExamDate}',
                              style: AppFonts.inter(
                                  fontSize: 12, color: textSecondary),
                            ),
                            const SizedBox(height: 12),

                            // Progress Bar
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: c.progress,
                                      minHeight: 8,
                                      backgroundColor: borderColor,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${(c.progress * 100).toInt()}%',
                                  style: AppFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
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
