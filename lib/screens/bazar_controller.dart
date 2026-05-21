import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtd/model/bazar_item.dart';

class BazarController extends GetxController {
  var bazarList = <BazarItem>[].obs;
  late Box<BazarItem> bazarBox;

  @override
  void onInit() {
    super.onInit();
    _openBox();
  }

  Future<void> _openBox() async {
    bazarBox = await Hive.openBox<BazarItem>('bazarItems');
    bazarList.assignAll(bazarBox.values.toList().cast<BazarItem>());
  }

  void addBazarItem(String itemName, double estimatedPrice, double purchasePrice) {
    final newItem = BazarItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: itemName,
      estimatedPrice: estimatedPrice,
      purchasePrice: purchasePrice,
      createdAt: DateTime.now(),
    );
    bazarBox.add(newItem);
    bazarList.add(newItem);
  }

  void deleteBazarItem(String id) {
    try {
      final item = bazarBox.values.firstWhere((item) => item.id == id);
      item.delete();
      bazarList.removeWhere((item) => item.id == id);
    } catch (e) {
      debugPrint('Error deleting bazar item: $e');
    }
  }

  void updateBazarItem(String id, String itemName, double estimatedPrice, double purchasePrice) {
    try {
      final item = bazarBox.values.firstWhere((item) => item.id == id);
      item.itemName = itemName;
      item.estimatedPrice = estimatedPrice;
      item.purchasePrice = purchasePrice;
      item.save();
      bazarList.refresh();
    } catch (e) {
      debugPrint('Error updating bazar item: $e');
    }
  }
}
