import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
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
  final List<_CourseItem> _courses = const [
    _CourseItem(
      id: 'c_1',
      title: 'AWS Certified Solutions Architect (SAA-C03)',
      platform: 'Cloud Certification',
      progress: 0.75,
      targetExamDate: 'Nov 04, 2026',
      daysLeft: 18,
    ),
    _CourseItem(
      id: 'c_2',
      title: 'Advanced Flutter Architecture & Clean Code',
      platform: 'Mobile Engineering',
      progress: 0.90,
      targetExamDate: 'Oct 28, 2026',
      daysLeft: 11,
    ),
    _CourseItem(
      id: 'c_3',
      title: 'Distributed System Design & High Scale',
      platform: 'Backend Systems',
      progress: 0.45,
      targetExamDate: 'Dec 15, 2026',
      daysLeft: 59,
    ),
  ];

  int _currentCardIdx = 0;
  final List<_Flashcard> _flashcards = [
    _Flashcard(
      question: 'What is the primary difference between SQS Standard and SQS FIFO?',
      answer: 'SQS FIFO guarantees exactly-once processing and strict first-in-first-out delivery ordering.',
    ),
    _Flashcard(
      question: 'In Flutter, what is the role of InheritedWidget?',
      answer: 'It enables efficient data propagation down the widget tree, allowing descendants to subscribe to changes without rebuilding intermediate widgets.',
    ),
    _Flashcard(
      question: 'Explain CAP Theorem in Distributed Databases.',
      answer: 'A distributed system can guarantee at most two out of Consistency, Availability, and Partition Tolerance.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    const accentColor = Color(0xFFEC4899);

    final card = _flashcards[_currentCardIdx];

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Exams & Learning',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
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
                  Container(
                    padding: const EdgeInsets.all(22),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.style_rounded, color: accentColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Daily Revision Flashcard',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            LifeUseBadge(
                              text: '${_currentCardIdx + 1} / ${_flashcards.length}',
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
                                  ? accentColor.withValues(alpha: isDark ? 0.15 : 0.08)
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03)),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: card.isFlipped
                                    ? accentColor.withValues(alpha: 0.3)
                                    : borderColor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.isFlipped ? 'ANSWER' : 'QUESTION (Tap to flip)',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: card.isFlipped ? accentColor : textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card.isFlipped ? card.answer : card.question,
                                  style: GoogleFonts.inter(
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
                              icon: const Icon(Icons.flip_rounded, size: 16),
                              label: Text(card.isFlipped ? 'Show Question' : 'Reveal Answer'),
                              onPressed: () {
                                setState(() => card.isFlipped = !card.isFlipped);
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                              label: const Text('Next Card'),
                              onPressed: () {
                                setState(() {
                                  card.isFlipped = false;
                                  _currentCardIdx = (_currentCardIdx + 1) % _flashcards.length;
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
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 12),

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
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${c.daysLeft}d LEFT',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${c.platform} • Target: ${c.targetExamDate}',
                              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
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
                                      valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${(c.progress * 100).toInt()}%',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
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
          ),
        ),
      ),
    );
  }
}
