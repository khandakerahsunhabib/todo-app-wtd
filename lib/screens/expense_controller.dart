import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtd/model/expense_item.dart';

class ExpenseController extends GetxController {
  var expenseList = <ExpenseItem>[].obs;
  late Box<ExpenseItem> expenseBox;

  @override
  void onInit() {
    super.onInit();
    _openBox();
  }

  Future<void> _openBox() async {
    expenseBox = await Hive.openBox<ExpenseItem>('expenseItems');
    expenseList.assignAll(expenseBox.values.toList().cast<ExpenseItem>());
  }

  void addExpenseItem(String title, double amount, bool isIncome, String category) {
    final newItem = ExpenseItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      isIncome: isIncome,
      category: category,
      createdAt: DateTime.now(),
    );
    expenseBox.add(newItem);
    expenseList.add(newItem);
  }

  void deleteExpenseItem(String id) {
    try {
      final item = expenseBox.values.firstWhere((item) => item.id == id);
      item.delete();
      expenseList.removeWhere((item) => item.id == id);
    } catch (e) {
      debugPrint('Error deleting expense item: $e');
    }
  }

  void updateExpenseItem(String id, String title, double amount, bool isIncome, String category) {
    try {
      final item = expenseBox.values.firstWhere((item) => item.id == id);
      item.title = title;
      item.amount = amount;
      item.isIncome = isIncome;
      item.category = category;
      item.save();
      expenseList.refresh();
    } catch (e) {
      debugPrint('Error updating expense item: $e');
    }
  }

  double get totalIncome => expenseList
      .where((item) => item.isIncome)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get totalExpense => expenseList
      .where((item) => !item.isIncome)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get netBalance => totalIncome - totalExpense;
}
