import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_floating_navigation.dart';
import '../../navigation/main_navigation_shell.dart';
import '../../state/auth_provider.dart';
import '../../state/money_provider.dart';
import '../../state/notification_provider.dart';
import 'models/dashboard_module_item.dart';
import 'widgets/bento_life_overview.dart';
import 'widgets/daily_life_overview.dart';
import 'widgets/dashboard_surface.dart';
import 'widgets/hero_zone.dart';
import 'widgets/pending_alerts_banner.dart';
import 'widgets/quick_actions_panel.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/search_results_view.dart';

/// LifeUse Home Dashboard.
///
/// Layout, top to bottom:
///   1. Full-bleed hero (status bar, header, search, swipeable banners)
///   2. Direct Controls panel overlapping the hero's lower edge
///   3. Pending Alerts & Reminders (only when something needs attention)
///   4. Recent Activity (real transactions, honest empty state)
///   5. Daily Life Overview (real provider data only)
///   6. Floating bottom navigation (provided by MainNavigationShell)
///
/// All data and navigation are unchanged: Provider state, API-backed
/// MoneyProvider, auth guards and MainNavigationShell routing are reused.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const double _overlap = 0;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0);

  String _query = '';
  bool _hideBalances = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    if ((offset - _scrollOffset.value).abs() > 0.5) {
      _scrollOffset.value = offset;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final auth = context.read<AuthProvider>();
    final money = context.read<MoneyProvider>();
    final notif = context.read<NotificationProvider>();
    await Future.wait([
      if (auth.isAuthenticated) auth.refreshProfile(),
      money.loadDashboardData(silent: true),
      notif.loadNotifications(),
    ]);
  }

  void _openHomeManagement() {
    final modules = HardcodedModuleItem.hardcodedModules;
    final home = modules.where((m) => m.id == 'home_management');
    if (home.isEmpty) {
      MainNavigationShell.switchTab(context, 2);
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: home.first.screenBuilder));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final money = context.watch<MoneyProvider>();
    final hasUnread = context.select<NotificationProvider, bool>(
      (p) => p.hasUnread,
    );

    final user = auth.currentUser;
    final displayName = user != null
        ? (user.fullName.isNotEmpty ? user.fullName : '@${user.username}')
        : 'Guest Explorer';
    final dateStr = DateFormat('EEEE, MMM d').format(DateTime.now());

    final topInset = MediaQuery.paddingOf(context).top;
    final navHeight = LifeUseFloatingNavigation.heightFor(context);
    final searching = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: DashboardTokens.pageBackground(isDark),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppColors.primary,
          backgroundColor: DashboardTokens.surface(isDark),
          edgeOffset: topInset + 8,
          child: SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Full-bleed hero: header + search + banner carousel
                HeroZone(
                  displayName: displayName,
                  isAuthenticated: auth.isAuthenticated,
                  dateStr: dateStr,
                  totalBalance: money.financialProfile?.reportedBalance ??
                      (money.summary.totalIncome - money.summary.totalExpenses),
                  monthlyExpenses: money.summary.totalExpenses,
                  upcomingBillsCount: money.upcomingOccurrences.length +
                      money.plannedExpenses.length,
                  hideBalances: _hideBalances,
                  onToggleHide: () =>
                      setState(() => _hideBalances = !_hideBalances),
                  hasUnread: hasUnread,
                  onOpenProfile: () =>
                      MainNavigationShell.switchTab(context, 4),
                  onOpenAlerts: () => MainNavigationShell.switchTab(context, 3),
                  searchController: _searchController,
                  onSearchChanged: (value) =>
                      setState(() => _query = value.trim()),
                  scrollOffset: _scrollOffset,
                  onOpenModules: () =>
                      MainNavigationShell.switchTab(context, 2),
                  onOpenMoney: () =>
                      MainNavigationShell.openMoneyManager(context),
                  onOpenTasks: () => MainNavigationShell.switchTab(context, 1),
                  onOpenHome: _openHomeManagement,
                  bottomOverlap: _overlap,
                  onScrollDown: () {
                    _scrollController.animateTo(
                      360.0,
                      duration: const Duration(milliseconds: 550),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                ),

                // 2+. Everything below flows naturally right below the wave curve.
                Transform.translate(
                  offset: const Offset(0, -_overlap),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DashboardTokens.gutter,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: searching
                            ? _buildSearchResults(money)
                            : _buildSections(auth, money),
                      ),
                    ),
                  ),
                ),

                // Reserve room for the floating navigation (minus the
                // overlap that the translate above leaves behind).
                SizedBox(height: (navHeight + 12 - _overlap).clamp(0.0, 400.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSections(AuthProvider auth, MoneyProvider money) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = DashboardTokens.surface(isDark);
    final borderColor = DashboardTokens.hairline(isDark);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Direct Controls panel
        const QuickActionsPanel(),
        const SizedBox(height: 20),

        // 2. My Modules — Asymmetric Bento Life Matrix
        BentoLifeOverview(
          isDark: isDark,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 20),

        // 3. Pending Alerts & Reminders
        PendingAlertsBanner(
          isAuthenticated: auth.isAuthenticated,
          hideBalances: _hideBalances,
        ),

        // 4. Recent Activity
        RecentActivitySection(
          money: money,
          isAuthenticated: auth.isAuthenticated,
          hideBalances: _hideBalances,
        ),
        const SizedBox(height: 20),

        // 5. Daily Life Overview
        _RevealOnScroll(
          offset: _scrollOffset,
          child: DailyLifeOverview(
            isAuthenticated: auth.isAuthenticated,
            hideBalances: _hideBalances,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(MoneyProvider money) {
    final modules = SearchResultsView.matchModules(
      HardcodedModuleItem.hardcodedModules,
      _query,
    );
    final transactions =
        SearchResultsView.matchTransactions(money.transactions, _query);

    return Padding(
      // Clears the hero overlap so results never sit on the gradient.
      padding: const EdgeInsets.only(top: _overlap + 12),
      child: SearchResultsView(
        query: _query,
        modules: modules,
        transactions: transactions,
        hideBalances: _hideBalances,
      ),
    );
  }
}

/// Fades + slides a section up the first time it scrolls into view.
/// Plays once, uses a single short controller per section, and is skipped
/// entirely when the user prefers reduced motion.
class _RevealOnScroll extends StatefulWidget {
  final ValueListenable<double> offset;
  final Widget child;

  const _RevealOnScroll({required this.offset, required this.child});

  @override
  State<_RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<_RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(_curve);

  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    widget.offset.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_revealed || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.sizeOf(context).height;
    // Reveal slightly before the section's top edge reaches the viewport.
    if (top < screenHeight - 32) {
      _revealed = true;
      widget.offset.removeListener(_check);
      if (MediaQuery.disableAnimationsOf(context)) {
        _controller.value = 1;
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    widget.offset.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
