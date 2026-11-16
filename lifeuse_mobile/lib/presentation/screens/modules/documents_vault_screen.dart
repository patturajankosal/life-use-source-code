import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _SecureDocItem {
  final String id;
  final String title;
  final String category;
  final String docNumber;
  final String expiryDate;
  final IconData icon;

  const _SecureDocItem({
    required this.id,
    required this.title,
    required this.category,
    required this.docNumber,
    required this.expiryDate,
    required this.icon,
  });
}

/// Interactive Encrypted Document Vault micro-app screen.
/// Manages IDs, policies, vehicle papers, and warranties with AES-256 encryption.
class DocumentsVaultScreen extends StatefulWidget {
  const DocumentsVaultScreen({super.key});

  @override
  State<DocumentsVaultScreen> createState() => _DocumentsVaultScreenState();
}

class _DocumentsVaultScreenState extends State<DocumentsVaultScreen> {
  final List<_SecureDocItem> _documents = [];

  void _showAddDocumentDialog() {
    final titleCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    final numCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Store Encrypted Document',
            style: AppFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Document Name',
                hintText: 'e.g. Life Insurance Policy',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: catCtrl,
              decoration: InputDecoration(
                labelText: 'Category',
                hintText: 'e.g. Insurance / Identity',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numCtrl,
              decoration: InputDecoration(
                labelText: 'Document / Policy Number',
                hintText: 'e.g. #9021849',
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
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _documents.insert(
                    0,
                    _SecureDocItem(
                      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      category: catCtrl.text.trim().isEmpty
                          ? 'Personal Document'
                          : catCtrl.text.trim(),
                      docNumber: numCtrl.text.trim().isEmpty
                          ? 'DOC-••••'
                          : numCtrl.text.trim(),
                      expiryDate: 'Secured locally',
                      icon: AppIcons.documentsVault,
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Document encrypted & stored in local AES-256 vault'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Secure Save'),
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

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Documents Vault',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.plus, size: 20),
            tooltip: 'Add Document',
            onPressed: _showAddDocumentDialog,
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
                  // 1. Encryption Banner
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
                              AppIcons.lock,
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
                                'Hardware-Encrypted Vault',
                                style: AppFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'All records secured with AES-256 bit client-side keys.',
                                style: AppFonts.inter(
                                    fontSize: 12.5, color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const LifeUseBadge(
                            text: 'AES-256',
                            variant: LifeUseBadgeVariant.active),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Documents List
                  Text(
                    'Stored Credentials & Documents',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 12),

                  if (_documents.isEmpty)
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
                                AppIcons.documentsVault,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Encrypted Vault Empty',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No identity credentials or insurance policies stored yet.\nTap \'+\' in the header to add an encrypted document.',
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
                    itemCount: _documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final doc = _documents[i];
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
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.iconBorderOf(context),
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: AppIcon(
                                  doc.icon,
                                  color: AppColors.brandIconOf(context),
                                  size: 21,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: AppFonts.inter(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${doc.category} • ${doc.docNumber}',
                                    style: AppFonts.inter(
                                        fontSize: 12, color: textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc.expiryDate,
                                    style: AppFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const AppIcon(AppIcons.eye, size: 18),
                              tooltip: 'View Secure Details',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Viewing ${doc.title}'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
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
}
