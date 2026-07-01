import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wtd/controllers/expense_controller.dart';
import 'package:wtd/model/expense_item.dart';

class ExpenseTabView extends StatelessWidget {
  final ExpenseController expenseController;

  const ExpenseTabView({super.key, required this.expenseController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final query = expenseController.searchQuery.value.trim().toLowerCase();

      final incomeList = expenseController.expenseList
          .where((e) =>
              e.isIncome &&
              (query.isEmpty || e.title.toLowerCase().contains(query)))
          .toList();
      final expenseList = expenseController.expenseList
          .where((e) =>
              !e.isIncome &&
              (query.isEmpty || e.title.toLowerCase().contains(query)))
          .toList();

      return DefaultTabController(
        length: 2,
        child: Stack(
          children: [
            Column(
              children: [
                // Summary Header Card
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Net Balance',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '৳${expenseController.netBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.south_west_rounded,
                                      color: Colors.greenAccent, size: 16),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Total Income',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '৳${expenseController.totalIncome.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.white24,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.north_east_rounded,
                                      color: Colors.redAccent, size: 16),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Total Expense',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '৳${expenseController.totalExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
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
                // Sub-Tab Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black54 : Colors.grey.shade400,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          isDark ? Colors.white60 : Colors.grey.shade600,
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs: [
                        Tab(
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Income'),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${incomeList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          height: 38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Expense'),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade600,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${expenseList.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Search Field
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: expenseController.searchController,
                    onChanged: (value) => expenseController.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search by source...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                        size: 20,
                      ),
                      suffixIcon: Obx(() {
                        if (expenseController.searchQuery.value.isNotEmpty) {
                          return IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                              size: 18,
                            ),
                            onPressed: () {
                              expenseController.searchController.clear();
                              expenseController.searchQuery.value = '';
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      filled: true,
                      fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white30 : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white30 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                // TabBarView showing Income / Expense lists
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTransactionList(
                          context, expenseController, incomeList, true),
                      _buildTransactionList(
                          context, expenseController, expenseList, false),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () => _showAddTransactionBottomSheet(context),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTransactionList(
    BuildContext context,
    ExpenseController controller,
    List<ExpenseItem> items,
    bool isIncome,
  ) {
    if (items.isEmpty) {
      final isSearching = controller.searchQuery.value.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : (isIncome
                      ? Icons.account_balance_wallet_outlined
                      : Icons.shopping_bag_outlined),
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'No matching transactions found!'
                  : (isIncome
                      ? 'No income recorded yet!'
                      : 'No expenses recorded yet!'),
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 90),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0.5,
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isIncome
                      ? (isDark
                          ? Colors.green.withAlpha(38)
                          : Colors.green.shade50)
                      : (isDark
                          ? Colors.red.withAlpha(38)
                          : Colors.red.shade50),
                  child: Icon(
                    isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('MMM dd, yyyy').format(item.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isIncome ? "+" : "-"} ৳${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      Get.toNamed('/edit_expense_item', arguments: item);
                    } else if (value == 'delete') {
                      _showDeleteExpenseConfirmationDialog(
                          context, controller, item.id ?? '');
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20),
                          const SizedBox(width: 10),
                          const Text('Edit',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              color: Colors.red, size: 20),
                          SizedBox(width: 10),
                          Text('Delete',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red)),
                        ],
                      ),
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

  void _showAddTransactionBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) => SafeArea(
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
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDark
                      ? Colors.green.withAlpha(50)
                      : Colors.green.shade50,
                  child: Icon(Icons.south_west_rounded,
                      color: isDark ? Colors.green.shade300 : Colors.green),
                ),
                title: Text(
                  'Add Income',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87),
                ),
                subtitle: Text(
                  'Record money received (salary, business, gifts, etc.).',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 13),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed('/add_expense_item', arguments: true);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isDark ? Colors.red.withAlpha(50) : Colors.red.shade50,
                  child: Icon(Icons.north_east_rounded,
                      color: isDark ? Colors.red.shade300 : Colors.red),
                ),
                title: Text(
                  'Add Expense',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87),
                ),
                subtitle: Text(
                  'Record money spent (food, rent, bills, shopping, etc.).',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 13),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed('/add_expense_item', arguments: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteExpenseConfirmationDialog(
      BuildContext context, ExpenseController controller, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Delete Transaction?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 20,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to permanently delete this transaction? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.deleteExpenseItem(id);
                          Navigator.pop(context);
                          Get.snackbar(
                            'Deleted',
                            'Transaction deleted successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade400,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
}
