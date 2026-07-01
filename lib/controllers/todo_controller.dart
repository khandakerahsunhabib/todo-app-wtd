import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtd/model/todo.dart';

class ToDoController extends GetxController {
  var todoList = <ToDo>[].obs;
  late Box<ToDo> todoBox;
  final searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _openBox();
  }

  Future<void> _openBox() async {
    todoBox = await Hive.openBox<ToDo>('todos');
    todoList.assignAll(todoBox.values.toList().cast<ToDo>());
  }

  void addTodo(String title, String? description) {
    final newTodo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: title,
      description: description,
      createdAt: DateTime.now(),
    );
    todoBox.add(newTodo);
    todoList.add(newTodo);
  }

  void deleteTodo(String id) {
    try {
      final todo = todoBox.values.firstWhere((todo) => todo.id == id);
      todo.delete();
      todoList.removeWhere((todo) => todo.id == id);
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  void handleToDoChange(ToDo todo) {
    todo.isDone = !todo.isDone;
    todo.save(); // Save changes to Hive
    todoList.refresh(); // Notify GetX listeners
  }

  void updateTodo(String id, String title, String? description) {
    try {
      final todo = todoBox.values.firstWhere((todo) => todo.id == id);
      todo.todoText = title;
      todo.description = description;
      todo.save(); // Save changes to Hive
      todoList.refresh(); // Notify GetX listeners
    } catch (e) {
      debugPrint('Error updating todo: $e');
    }
  }
}
