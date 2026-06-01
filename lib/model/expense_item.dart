import 'package:hive/hive.dart';

part 'expense_item.g.dart';

@HiveType(typeId: 1)
class ExpenseItem extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  bool isIncome;

  @HiveField(4)
  String category;

  @HiveField(5)
  DateTime createdAt;

  ExpenseItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.createdAt,
  });
}
