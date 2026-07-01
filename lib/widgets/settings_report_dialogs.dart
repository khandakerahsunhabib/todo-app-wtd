import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/controllers/expense_controller.dart';
import 'package:wtd/model/expense_item.dart';
import 'package:wtd/utils/report_generator.dart';

class SettingsReportDialogs {
  static void showSettingsBottomSheet(BuildContext context) {
    final settingsBox = Hive.box('settings');
    final isDarkRx =
        (settingsBox.get('isDarkMode', defaultValue: false) as bool).obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Obx(() {
        final isDark = isDarkRx.value;
        final cardColor = isDark ? darkCardBg : lightCardBg;
        final primaryColor = isDark ? oceanAccent : oceanMedium;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subtitleColor = isDark ? darkSecondaryText : lightSecondaryText;

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? primaryColor.withValues(alpha: 0.15)
                            : Colors.amber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: isDark ? primaryColor : Colors.amber.shade700,
                      ),
                    ),
                    title: Text(
                      'Theme Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      isDark ? 'Dark Mode Active' : 'Light Mode Active',
                      style: TextStyle(color: subtitleColor, fontSize: 13),
                    ),
                    trailing: Switch(
                      value: isDark,
                      activeThumbColor: primaryColor,
                      activeTrackColor: primaryColor.withValues(alpha: 0.5),
                      onChanged: (value) {
                        isDarkRx.value = value;
                        settingsBox.put('isDarkMode', value);
                        Get.changeThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      showReportBottomSheet(context);
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.summarize_rounded,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      'Financial Report',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Generate PDF/JPG statements',
                      style: TextStyle(color: subtitleColor, fontSize: 13),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.white30 : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  static void showReportBottomSheet(BuildContext context) {
    final expenseController = Get.find<ExpenseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime endDate = DateTime.now();
    String scope = 'All'; // 'All', 'Income', 'Expense'
    String format = 'PDF'; // 'PDF', 'JPG'

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Generate Report',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date Range Picker selector
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(start: startDate, end: endDate),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                    primary: Theme.of(context).colorScheme.primary,
                                    onPrimary: Colors.white,
                                    surface: Theme.of(context).cardColor,
                                  ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked.start;
                          endDate = picked.end;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.date_range_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.edit_calendar_rounded,
                              size: 18, color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Scope selection
                  Text(
                    'Transaction Scope',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChipSelection(
                        label: 'All',
                        isSelected: scope == 'All',
                        onTap: () => setState(() => scope = 'All'),
                        context: context,
                      ),
                      const SizedBox(width: 10),
                      _buildChipSelection(
                        label: 'Income',
                        isSelected: scope == 'Income',
                        onTap: () => setState(() => scope = 'Income'),
                        context: context,
                      ),
                      const SizedBox(width: 10),
                      _buildChipSelection(
                        label: 'Expense',
                        isSelected: scope == 'Expense',
                        onTap: () => setState(() => scope = 'Expense'),
                        context: context,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Format selection
                  Text(
                    'Export Format',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChipSelection(
                        label: 'PDF Document',
                        isSelected: format == 'PDF',
                        onTap: () => setState(() => format = 'PDF'),
                        context: context,
                      ),
                      const SizedBox(width: 10),
                      _buildChipSelection(
                        label: 'JPG Image',
                        isSelected: format == 'JPG',
                        onTap: () => setState(() => format = 'JPG'),
                        context: context,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showReportPreviewDialog(
                          context: context,
                          expenseController: expenseController,
                          startDate: startDate,
                          endDate: endDate,
                          scope: scope,
                          format: format,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Generate Preview',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildChipSelection({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (isDark ? Colors.white10 : Colors.grey.shade300),
          width: 1,
        ),
      ),
    );
  }

  static void showReportPreviewDialog({
    required BuildContext context,
    required ExpenseController expenseController,
    required DateTime startDate,
    required DateTime endDate,
    required String scope,
    required String format,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredItems = expenseController.expenseList.where((item) {
      final isWithinDate = item.createdAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          item.createdAt.isBefore(endDate.add(const Duration(days: 1)));
      if (!isWithinDate) return false;
      if (scope == 'Income') return item.isIncome;
      if (scope == 'Expense') return !item.isIncome;
      return true;
    }).toList();

    final double totalIncome = filteredItems
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    final double totalExpense = filteredItems
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
    final double netBalance = totalIncome - totalExpense;

    // Split items into page chunks to match printed pages
    final chunks = _chunkItems(filteredItems);
    final boundaryKeys = List.generate(chunks.length, (_) => GlobalKey());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Theme.of(context).cardColor,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(chunks.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 4),
                                child: Text(
                                  'Page ${index + 1} of ${chunks.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ),
                              RepaintBoundary(
                                key: boundaryKeys[index],
                                child: _buildReportPreviewWidget(
                                  context: context,
                                  items: chunks[index],
                                  startDate: startDate,
                                  endDate: endDate,
                                  scope: scope,
                                  totalIncome: totalIncome,
                                  totalExpense: totalExpense,
                                  netBalance: netBalance,
                                  isDark: isDark,
                                  pageIndex: index,
                                  totalPages: chunks.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton(
                        onPressed: () async {
                          final pdfBytes = await ReportGenerator.generatePDFReport(
                            items: filteredItems,
                            startDate: startDate,
                            endDate: endDate,
                            scope: scope,
                            totalIncome: totalIncome,
                            totalExpense: totalExpense,
                            netBalance: netBalance,
                          );
                          final filename = 'WTD_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
                          await ReportGenerator.shareReport(
                            bytes: pdfBytes,
                            filename: filename,
                            mimeType: 'application/pdf',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_rounded,
                                size: 16, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 6),
                            const Text('PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.primary),
                      tooltip: 'Download PDF',
                      onPressed: () async {
                        final pdfBytes = await ReportGenerator.generatePDFReport(
                          items: filteredItems,
                          startDate: startDate,
                          endDate: endDate,
                          scope: scope,
                          totalIncome: totalIncome,
                          totalExpense: totalExpense,
                          netBalance: netBalance,
                        );
                        final filename = 'WTD_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
                        await ReportGenerator.saveReportToDocuments(
                          bytes: pdfBytes,
                          filename: filename,
                        );
                        Get.snackbar(
                          'Success',
                          Platform.isAndroid 
                            ? 'PDF saved to Downloads/'
                            : 'PDF saved to Documents/WTD_Reports/',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade600,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 4),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _captureAndShareJpgs(boundaryKeys);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_rounded, size: 16),
                            SizedBox(width: 6),
                            Text('JPG', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.primary),
                      tooltip: 'Download JPG',
                      onPressed: () async {
                        try {
                          int savedCount = 0;
                          for (int i = 0; i < chunks.length; i++) {
                            final pngBytes = await _captureJpgBytes(boundaryKeys[i]);
                            if (pngBytes != null) {
                              final filename = 'WTD_Report_Page_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.png';
                              await ReportGenerator.saveReportToDocuments(
                                bytes: pngBytes,
                                filename: filename,
                              );
                              savedCount++;
                            }
                          }
                          if (savedCount > 0) {
                            Get.snackbar(
                              'Success',
                              Platform.isAndroid 
                                ? '$savedCount images saved to Downloads/'
                                : '$savedCount images saved to Documents/WTD_Reports/',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade600,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 4),
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to download images: $e',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade400,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static List<List<ExpenseItem>> _chunkItems(List<ExpenseItem> items) {
    List<List<ExpenseItem>> chunks = [];
    if (items.isEmpty) {
      chunks.add([]);
      return chunks;
    }
    
    int index = 0;
    // Page 1 can fit 8 items
    int page1Count = 8;
    if (items.length <= page1Count) {
      chunks.add(items);
      return chunks;
    }
    chunks.add(items.sublist(0, page1Count));
    index = page1Count;
    
    // Page 2+ can fit 12 items
    int pageNCount = 12;
    while (index < items.length) {
      int nextIndex = index + pageNCount;
      if (nextIndex > items.length) {
        nextIndex = items.length;
      }
      chunks.add(items.sublist(index, nextIndex));
      index = nextIndex;
    }
    return chunks;
  }

  static Widget _buildReportPreviewWidget({
    required BuildContext context,
    required List<ExpenseItem> items,
    required DateTime startDate,
    required DateTime endDate,
    required String scope,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
    required bool isDark,
    required int pageIndex,
    required int totalPages,
  }) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What To Do',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Financial Report',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Date Range',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? Colors.white12 : Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),

          // Summary Card (Only on Page 1)
          if (pageIndex == 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net Balance',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '৳${netBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: netBalance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(height: 0.5, color: isDark ? Colors.white12 : Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total Income',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '৳${totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Total Expense',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '৳${totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text(
            'Transactions (${scope == 'All' ? 'Income & Expenses' : scope}) - Page ${pageIndex + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),

          // List
          items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No transactions found.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.category} • ${dateFormat.format(item.createdAt)}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.isIncome ? '+' : '-'}৳${item.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: item.isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white12 : Colors.grey.shade200, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated on ${dateFormat.format(DateTime.now())}',
                style: TextStyle(fontSize: 8, color: isDark ? Colors.white38 : Colors.grey.shade500),
              ),
              Text(
                'Page ${pageIndex + 1} of $totalPages',
                style: TextStyle(fontSize: 8, color: isDark ? Colors.white38 : Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> _captureAndShareJpgs(List<GlobalKey> boundaryKeys) async {
    try {
      List<XFile> xFiles = [];
      final tempDir = await getTemporaryDirectory();

      for (int i = 0; i < boundaryKeys.length; i++) {
        final boundaryKey = boundaryKeys[i];
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        await Future.delayed(const Duration(milliseconds: 100));
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) continue;
        final pngBytes = byteData.buffer.asUint8List();

        final filename = 'WTD_Report_Page_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${tempDir.path}/$filename');
        await file.writeAsBytes(pngBytes);
        xFiles.add(XFile(file.path, mimeType: 'image/png'));
      }

      if (xFiles.isNotEmpty) {
        // ignore: deprecated_member_use
        await Share.shareXFiles(
          xFiles,
          subject: 'Financial Report Images',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Could not generate image reports: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  static Future<Uint8List?> _captureJpgBytes(GlobalKey boundaryKey) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      await Future.delayed(const Duration(milliseconds: 100));
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing JPG bytes: $e');
      return null;
    }
  }
}
