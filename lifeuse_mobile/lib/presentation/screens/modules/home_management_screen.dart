import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _SmartDeviceItem {
  final String id;
  final String name;
  final String room;
  final IconData icon;
  bool isOn;

  _SmartDeviceItem({
    required this.id,
    required this.name,
    required this.room,
    required this.icon,
    this.isOn = false,
  });
}

class _InventoryItem {
  final String id;
  final String name;
  final String location;
  int quantity;
  final int minQuantity;
  final String unit;

  _InventoryItem({
    required this.id,
    required this.name,
    required this.location,
    required this.quantity,
    required this.minQuantity,
    required this.unit,
  });

  bool get isLowStock => quantity <= minQuantity;
}

class _MaintenanceItem {
  final String id;
  final String appliance;
  final String task;
  final String dueDate;
  final String warrantyPeriod;
  bool isCompleted;

  _MaintenanceItem({
    required this.id,
    required this.appliance,
    required this.task,
    required this.dueDate,
    required this.warrantyPeriod,
    this.isCompleted = false,
  });
}

/// Interactive Home Management Micro-App.
/// Controls smart home appliances, household inventory, and equipment warranties.
class HomeManagementScreen extends StatefulWidget {
  const HomeManagementScreen({super.key});

  @override
  State<HomeManagementScreen> createState() => _HomeManagementScreenState();
}

class _HomeManagementScreenState extends State<HomeManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_SmartDeviceItem> _devices = [
    _SmartDeviceItem(
      id: 'dev_1',
      name: 'Living Room AC',
      room: 'Living Room',
      icon: Icons.ac_unit_rounded,
      isOn: true,
    ),
    _SmartDeviceItem(
      id: 'dev_2',
      name: 'Smart Door Lock',
      room: 'Main Entrance',
      icon: Icons.lock_rounded,
      isOn: true,
    ),
    _SmartDeviceItem(
      id: 'dev_3',
      name: 'Balcony Warm Lights',
      room: 'Balcony',
      icon: Icons.lightbulb_rounded,
      isOn: false,
    ),
    _SmartDeviceItem(
      id: 'dev_4',
      name: 'Kitchen Water Purifier',
      room: 'Kitchen',
      icon: Icons.water_drop_rounded,
      isOn: true,
    ),
  ];

  final List<_InventoryItem> _inventory = [
    _InventoryItem(
      id: 'inv_1',
      name: 'Dishwasher Pods',
      location: 'Kitchen Cabinet',
      quantity: 4,
      minQuantity: 5,
      unit: 'pods',
    ),
    _InventoryItem(
      id: 'inv_2',
      name: 'LED Light Bulbs (9W)',
      location: 'Storage Box B',
      quantity: 6,
      minQuantity: 2,
      unit: 'bulbs',
    ),
    _InventoryItem(
      id: 'inv_3',
      name: 'Air Filter Replacements',
      location: 'Utility Closet',
      quantity: 1,
      minQuantity: 2,
      unit: 'filters',
    ),
    _InventoryItem(
      id: 'inv_4',
      name: 'AA Rechargeable Batteries',
      location: 'Drawer 1',
      quantity: 8,
      minQuantity: 4,
      unit: 'batteries',
    ),
  ];

  final List<_MaintenanceItem> _maintenance = [
    _MaintenanceItem(
      id: 'maint_1',
      appliance: 'Daikin Dual Inverter AC',
      task: 'Clean high-density air mesh & blower',
      dueDate: 'Due Oct 22 (in 6 days)',
      warrantyPeriod: 'Valid till Nov 2027',
      isCompleted: false,
    ),
    _MaintenanceItem(
      id: 'maint_2',
      appliance: 'Kent Grand RO Purifier',
      task: 'Replace sediment and carbon filter candle',
      dueDate: 'Due Nov 05',
      warrantyPeriod: 'Extended AMC Active',
      isCompleted: false,
    ),
    _MaintenanceItem(
      id: 'maint_3',
      appliance: 'Bosch Front Load Washer',
      task: 'Run drum descaling cycle at 90°C',
      dueDate: 'Completed yesterday',
      warrantyPeriod: 'Valid till Aug 2028',
      isCompleted: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddDeviceDialog() {
    final nameCtrl = TextEditingController();
    final roomCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Add Smart Device',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Device Name',
                hintText: 'e.g. Master Bedroom Fan',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roomCtrl,
              decoration: InputDecoration(
                labelText: 'Room / Area',
                hintText: 'e.g. Bedroom',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _devices.add(
                    _SmartDeviceItem(
                      id: 'dev_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      room: roomCtrl.text.trim().isEmpty ? 'General' : roomCtrl.text.trim(),
                      icon: Icons.devices_rounded,
                      isOn: false,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Device'),
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
    const accentColor = Color(0xFF0284C7);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Home Management',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Appliance / Device',
            onPressed: _showAddDeviceDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: accentColor,
          indicatorColor: accentColor,
          unselectedLabelColor: textSecondary,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Smart Devices'),
            Tab(text: 'Inventory'),
            Tab(text: 'Warranties'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDevicesTab(context, surfaceColor, borderColor, textPrimary, textSecondary, accentColor, isDark),
                _buildInventoryTab(context, surfaceColor, borderColor, textPrimary, textSecondary, isDark),
                _buildWarrantiesTab(context, surfaceColor, borderColor, textPrimary, textSecondary, accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesTab(
    BuildContext context,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    Color accentColor,
    bool isDark,
  ) {
    final onlineCount = _devices.where((d) => d.isOn).length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Summary Header Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.home_work_rounded, color: accentColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Home Ecosystem',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$onlineCount of ${_devices.length} appliances currently active',
                      style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const LifeUseBadge(text: 'ONLINE', variant: LifeUseBadgeVariant.active),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Device Switch Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 2 : 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 96,
              ),
              itemCount: _devices.length,
              itemBuilder: (ctx, i) {
                final dev = _devices[i];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: dev.isOn
                        ? accentColor.withValues(alpha: isDark ? 0.15 : 0.08)
                        : surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dev.isOn
                          ? accentColor.withValues(alpha: 0.4)
                          : borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: dev.isOn ? accentColor : borderColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          dev.icon,
                          size: 20,
                          color: dev.isOn ? Colors.white : textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dev.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dev.room,
                              style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: dev.isOn,
                        activeThumbColor: accentColor,
                        onChanged: (val) {
                          setState(() => dev.isOn = val);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildInventoryTab(
    BuildContext context,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _inventory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final item = _inventory[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isLowStock
                  ? AppColors.error.withValues(alpha: 0.4)
                  : borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.isLowStock
                      ? AppColors.error.withValues(alpha: 0.1)
                      : const Color(0xFF0284C7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                  size: 20,
                  color: item.isLowStock ? AppColors.error : const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.location,
                      style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: item.quantity > 0
                        ? () => setState(() => item.quantity--)
                        : null,
                  ),
                  Text(
                    '${item.quantity} ${item.unit}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: item.isLowStock ? AppColors.error : textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () => setState(() => item.quantity++),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWarrantiesTab(
    BuildContext context,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    Color accentColor,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: _maintenance.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final m = _maintenance[i];
        return Container(
          padding: const EdgeInsets.all(16),
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
                      m.appliance,
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                  ),
                  LifeUseBadge(
                    text: m.isCompleted ? 'COMPLETED' : 'SCHEDULED',
                    variant: m.isCompleted ? LifeUseBadgeVariant.active : LifeUseBadgeVariant.pending,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                m.task,
                style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    m.dueDate,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: accentColor),
                  ),
                  const Spacer(),
                  Icon(Icons.verified_user_outlined, size: 14, color: textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    m.warrantyPeriod,
                    style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
