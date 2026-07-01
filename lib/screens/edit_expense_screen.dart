import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wtd/model/expense_item.dart';
import 'package:wtd/controllers/expense_controller.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late final ExpenseItem _item;
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();
  final ExpenseController _expenseController = Get.find<ExpenseController>();

  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investments',
    'Gifts',
    'Other'
  ];

  final List<String> _expenseCategories = [
    'Food & Dining',
    'Rent & Housing',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Health',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _item = Get.arguments as ExpenseItem;
    _titleController = TextEditingController(text: _item.title);
    _amountController = TextEditingController(text: _item.amount.toString());
    _selectedCategory = _item.category;
    _selectedDate = _item.createdAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: _item.isIncome ? Colors.green : Colors.red,
                    surface: Theme.of(context).cardColor,
                  )
                : ColorScheme.light(
                    primary: _item.isIncome ? Colors.green : Colors.red,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = _item.isIncome ? Colors.green : Colors.red;
    final categories = _item.isIncome ? _incomeCategories : _expenseCategories;

    // Ensure _selectedCategory is valid for the list
    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _item.isIncome ? 'Edit Income' : 'Edit Expense',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  _item.isIncome ? 'Modify Income' : 'Modify Expense',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Change the transaction details below and click Save.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                // Title Field
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: _item.isIncome ? 'Income Source' : 'Expense Title',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700),
                    prefixIcon: Icon(_item.isIncome ? Icons.account_balance_wallet_rounded : Icons.shopping_bag_rounded, color: themeColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: themeColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Amount (৳)',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700),
                    prefixIcon: Icon(Icons.attach_money_rounded, color: themeColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: themeColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid number';
                    }
                    if (amount <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                  dropdownColor: Theme.of(context).cardColor,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700),
                    prefixIcon: Icon(Icons.category_rounded, color: themeColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: themeColor, width: 2),
                    ),
                  ),
                  items: categories.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Date Picker field
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, color: themeColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('MMMM dd, yyyy').format(_selectedDate),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_drop_down_rounded, color: isDark ? Colors.white60 : Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final amount = double.parse(_amountController.text.trim());
                            _expenseController.updateExpenseItem(
                              _item.id ?? '',
                              _titleController.text.trim(),
                              amount,
                              _item.isIncome,
                              _selectedCategory,
                            );
                            // Adjust date if not today (retain original time component of item)
                            final originalTime = _item.createdAt;
                            final finalDate = DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              originalTime.hour,
                              originalTime.minute,
                              originalTime.second,
                            );
                            _item.createdAt = finalDate;
                            _item.save();
                            _expenseController.expenseList.refresh();

                            Get.back();
                            Get.snackbar(
                              'Success',
                              _item.isIncome
                                  ? 'Income updated successfully!'
                                  : 'Expense updated successfully!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
