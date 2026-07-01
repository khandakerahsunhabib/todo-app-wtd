import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:wtd/model/expense_item.dart';

class ReportGenerator {
  /// Helper to build cell contents for the PDF table
  static pw.Widget _buildCell(
    String text, {
    bool isHeader = false,
    bool isBold = false,
    PdfColor? textColor,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader || isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: textColor ?? (isHeader ? PdfColors.indigo900 : PdfColors.grey900),
        ),
      ),
    );
  }

  /// Generates a PDF report for the selected transactions and date range.
  static Future<Uint8List> generatePDFReport({
    required List<ExpenseItem> items,
    required DateTime startDate,
    required DateTime endDate,
    required String scope,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    final chunks = _chunkItems(items);

    for (int pageIdx = 0; pageIdx < chunks.length; pageIdx++) {
      final pageItems = chunks[pageIdx];
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header (on every page)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'What To Do',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.indigo900,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Financial Statement & Report',
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Date Range:',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1, color: PdfColors.grey300, height: 16),

                // Summary Card (Only on Page 1)
                if (pageIdx == 0) ...[
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.indigo50,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Net Balance',
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColors.grey800,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'BDT ${netBalance.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  color: netBalance >= 0 ? PdfColors.green700 : PdfColors.red700),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Container(height: 0.5, color: PdfColors.grey300),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  'Total Income',
                                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'BDT ${totalIncome.toStringAsFixed(2)}',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green700,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  'Total Expense',
                                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'BDT ${totalExpense.toStringAsFixed(2)}',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.red700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16),
                ],

                pw.Text(
                  'Transactions (${scope == "All" ? "Income & Expenses" : scope}) - Page ${pageIdx + 1}',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 8),

                // Table
                pageItems.isEmpty
                    ? pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.symmetric(vertical: 24),
                        child: pw.Text(
                          'No transactions found.',
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
                        ),
                      )
                    : pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                        columnWidths: const {
                          0: pw.FlexColumnWidth(2.5), // Date
                          1: pw.FlexColumnWidth(3.5), // Title
                          2: pw.FlexColumnWidth(2.0), // Category
                          3: pw.FlexColumnWidth(1.5), // Type
                          4: pw.FlexColumnWidth(2.5), // Amount
                        },
                        children: [
                          // Header Row
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(color: PdfColors.indigo100),
                            children: [
                              _buildCell('Date', isHeader: true),
                              _buildCell('Title', isHeader: true),
                              _buildCell('Category', isHeader: true),
                              _buildCell('Type', isHeader: true),
                              _buildCell('Amount', isHeader: true),
                            ],
                          ),
                          // Data Rows
                          ...pageItems.map((item) {
                            return pw.TableRow(
                              children: [
                                _buildCell('${dateFormat.format(item.createdAt)}\n${timeFormat.format(item.createdAt)}'),
                                _buildCell(item.title),
                                _buildCell(item.category),
                                _buildCell(
                                  item.isIncome ? 'Income' : 'Expense',
                                  textColor: item.isIncome ? PdfColors.green700 : PdfColors.red700,
                                ),
                                _buildCell(
                                  'BDT ${item.amount.toStringAsFixed(2)}',
                                  textColor: item.isIncome ? PdfColors.green700 : PdfColors.red700,
                                  isBold: true,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                
                pw.Spacer(),
                // Footer
                pw.Divider(thickness: 0.5, color: PdfColors.grey300, height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Generated on ${dateFormat.format(DateTime.now())} at ${timeFormat.format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
                    ),
                    pw.Text(
                      'Page ${pageIdx + 1} of ${chunks.length}',
                      style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
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

  /// Saves the report locally to a temporary folder and shares it
  static Future<void> shareReport({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(bytes);

    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      subject: 'Financial Report',
    );
  }

  /// Saves the report locally to the user's documents/downloads directory
  static Future<String> saveReportToDocuments({
    required Uint8List bytes,
    required String filename,
  }) async {
    Directory? directory;
    if (Platform.isAndroid) {
      // Save directly to the public Download directory on Android to make it visible
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = Directory('/sdcard/Download');
      }
    } else if (Platform.isIOS) {
      // App documents directory, made visible via Info.plist keys
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isMacOS) {
      // User's Downloads directory
      directory = await getDownloadsDirectory();
    }

    directory ??= await getApplicationDocumentsDirectory();

    File file;
    if (Platform.isAndroid) {
      if (await directory.exists()) {
        file = File('${directory.path}/$filename');
      } else {
        directory = await getApplicationDocumentsDirectory();
        final reportsDir = Directory('${directory.path}/WTD_Reports');
        if (!await reportsDir.exists()) {
          await reportsDir.create(recursive: true);
        }
        file = File('${reportsDir.path}/$filename');
      }
    } else {
      final reportsDir = Directory('${directory.path}/WTD_Reports');
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }
      file = File('${reportsDir.path}/$filename');
    }

    await file.writeAsBytes(bytes);
    return file.path;
  }
}
