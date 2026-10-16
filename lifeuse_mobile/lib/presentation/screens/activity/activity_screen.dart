import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class DailyTaskItem {
  final String id;
  String title;
  String category;
  String time;
  String priority; // Low, Medium, High, Urgent
  bool isCompleted;

  DailyTaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.priority,
    this.isCompleted = false,
  });
}

/// Responsive Daily Tasks & Activity Screen for LifeUse.
/// Provides interactive task checklists, completion metrics, and category filters.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedFilter = 'ALL'; // ALL, PENDING, COMPLETED

  final List<DailyTaskItem> _tasks = [
    DailyTaskItem(
      id: 'task_1',
      title: 'Morning financial check-in & review spending',
      category: 'Finance',
      time: '08:30 AM',
      priority: 'High',
      isCompleted: true,
    ),
    DailyTaskItem(
      id: 'task_2',
      title: 'Take daily hydration & multivitamin supplements',
      category: 'Health',
      time: '09:00 AM',
      priority: 'Normal',
      isCompleted: true,
    ),
    DailyTaskItem(
      id: 'task_3',
      title: 'Review home electricity & utility bill before due date',
      category: 'Bills',
      time: '11:30 AM',
      priority: 'Urgent',
      isCompleted: false,
    ),
    DailyTaskItem(
      id: 'task_4',
      title: 'Flutter UI architecture sprint & responsive testing',
      category: 'Learning',
      time: '02:00 PM',
      priority: 'High',
      isCompleted: false,
    ),
    DailyTaskItem(
      id: 'task_5',
      title: 'Evening 30-minute cardio & stretch workout',
      category: 'Health',
      time: '06:00 PM',
      priority: 'Normal',
      isCompleted: false,
    ),
    DailyTaskItem(
      id: 'task_6',
      title: 'Weekly budget reconciliation in Money Manager',
      category: 'Finance',
      time: '08:30 PM',
      priority: 'Normal',
      isCompleted: false,
    ),
  ];

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  double get _completionRatio =>
      _tasks.isEmpty ? 0.0 : _completedCount / _tasks.length;

  void _toggleTask(DailyTaskItem task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    String category = 'General';
    String priority = 'Normal';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final surfaceColor = AppColors.surfaceOf(ctx);
        final borderColor = AppColors.borderOf(ctx);
        final textPrimary = AppColors.textPrimaryOf(ctx);

        return StatefulBuilder(
          builder: (dialogCtx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(dialogCtx).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Daily Task',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: titleController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'What needs to be done today?',
                          hintStyle: GoogleFonts.inter(fontSize: 14),
                          filled: true,
                          fillColor: AppColors.backgroundOf(dialogCtx),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter a task description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: category,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                filled: true,
                                fillColor: AppColors.backgroundOf(dialogCtx),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Finance', child: Text('Finance')),
                                DropdownMenuItem(
                                    value: 'Health', child: Text('Health')),
                                DropdownMenuItem(
                                    value: 'Bills', child: Text('Bills')),
                                DropdownMenuItem(
                                    value: 'Learning', child: Text('Learning')),
                                DropdownMenuItem(
                                    value: 'General', child: Text('General')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setSheetState(() => category = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: priority,
                              decoration: InputDecoration(
                                labelText: 'Priority',
                                filled: true,
                                fillColor: AppColors.backgroundOf(dialogCtx),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Normal', child: Text('Normal')),
                                DropdownMenuItem(
                                    value: 'High', child: Text('High')),
                                DropdownMenuItem(
                                    value: 'Urgent', child: Text('Urgent')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setSheetState(() => priority = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _tasks.insert(
                                0,
                                DailyTaskItem(
                                  id: 'task_${DateTime.now().millisecondsSinceEpoch}',
                                  title: titleController.text.trim(),
                                  category: category,
                                  time: 'Today',
                                  priority: priority,
                                  isCompleted: false,
                                ),
                              );
                            });
                            Navigator.pop(dialogCtx);
                          }
                        },
                        child: Text(
                          'Save Task',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'high':
        return const Color(0xFFF59E0B);
      case 'normal':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredTasks = _tasks.where((t) {
      if (_selectedFilter == 'PENDING') return !t.isCompleted;
      if (_selectedFilter == 'COMPLETED') return t.isCompleted;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Daily Activity',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: LifeUseBadge(
                text: '$_completedCount OF ${_tasks.length} COMPLETED',
                variant: _completedCount == _tasks.length && _tasks.isNotEmpty
                    ? LifeUseBadgeVariant.active
                    : LifeUseBadgeVariant.pending,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded, size: 20),
        label: Text(
          'Add Task',
          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        onPressed: () => _showAddTaskDialog(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Progress Banner Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 14,
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
                            Text(
                              'Today\'s Goal Progress',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              '${(_completionRatio * 100).toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _completionRatio,
                            minHeight: 8,
                            backgroundColor:
                                borderColor.withValues(alpha: 0.5),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_tasks.length - _completedCount} remaining daily tasks to stay on track today.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Filter Pills
                  Row(
                    children: [
                      _buildFilterChip('ALL', 'All (${_tasks.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PENDING',
                          'Pending (${_tasks.length - _completedCount})'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'COMPLETED', 'Completed ($_completedCount)'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Task List or Empty State
                  if (filteredTasks.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 48,
                            color: AppColors.success.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Tasks Here!',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You have no tasks matching this filter. Tap "+ Add Task" to schedule a new one.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
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
                      itemCount: filteredTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final task = filteredTasks[i];
                        final priorityColor = _getPriorityColor(task.priority);

                        return Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: task.isCompleted
                                  ? borderColor.withValues(alpha: 0.5)
                                  : borderColor,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _toggleTask(task),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Checkbox icon
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: task.isCompleted
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: task.isCompleted
                                            ? AppColors.primary
                                            : borderColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: task.isCompleted
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),

                                  // Task description & metadata
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: task.isCompleted
                                                ? textSecondary
                                                : textPrimary,
                                            decoration: task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              task.category,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500,
                                                color: textSecondary,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text('•',
                                                style: GoogleFonts.inter(
                                                    color: textSecondary,
                                                    fontSize: 11)),
                                            const SizedBox(width: 6),
                                            Text(
                                              task.time,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                color: textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Priority indicator chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          priorityColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      task.priority.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: priorityColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected ? Colors.white : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}
