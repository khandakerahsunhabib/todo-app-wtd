import 'package:hive/hive.dart';

part 'bazar_item.g.dart';

@HiveType(typeId: 1)
class BazarItem extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String itemName;

  @HiveField(2)
  double estimatedPrice;

  @HiveField(3)
  double purchasePrice;

  @HiveField(4)
  DateTime createdAt;

  BazarItem({
    required this.id,
    required this.itemName,
    required this.estimatedPrice,
    required this.purchasePrice,
    required this.createdAt,
  });
}
