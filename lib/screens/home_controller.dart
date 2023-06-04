import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../model/todo.dart';
import 'home.dart';

class HomeController extends GetxController {
  final todoController = TextEditingController();
  final searchToDoItemController = TextEditingController();
  var todoList = <ToDo>[].obs;
  var foundToDo = <ToDo>[].obs;
  String currentRoute = "/";

  void addToDoItem() async {
    var box = await Hive.openBox<ToDo>('todoBox');
    box.add(ToDo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      todoText: todoController.text,
    ));
    todoController.clear();
    getToDoItemList();
  }

  void getToDoItemList() async {
    var box = await Hive.openBox<ToDo>('todoBox');
    todoList.value = box.values.cast<ToDo>().toList();
    searchToDoItem();
  }

  void updateToDoItemByIndex(int index, ToDo todo) async {
    var box = await Hive.openBox<ToDo>('todoBox');
    await box.putAt(index, todo);
    getToDoItemList();
  }

  void deleteDataByIndex(int index) async {
    var box = await Hive.openBox<ToDo>('todoBox');
    await box.deleteAt(index);
    getToDoItemList();
  }

  void loadToDoItemListData() async {
    await Future.delayed(const Duration(seconds: 1));
    getToDoItemList();
  }

  void navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.toNamed(Home.routeName);
  }

  void searchToDoItem() {
    foundToDo.clear();
    var searchingValue = searchToDoItemController.text;
    if (searchingValue.isEmpty) {
      for (var element in todoList) {
        foundToDo.add(ToDo(id: element.id, todoText: element.todoText));
      }
    } else {
      for (var element in todoList) {
        if (element.todoText!
            .toLowerCase()
            .contains(searchingValue.toLowerCase())) {
          foundToDo.add(ToDo(id: element.id, todoText: element.todoText));
        } else {}
      }
    }
  }

  bool enableDisable(bool? isDone) {
    bool? status = isDone!;
    //print('status: ${status}');
    return status;
  }

  void doRoute(BuildContext context, String name) {
    if (currentRoute != name) {
      Navigator.pushReplacementNamed(context, name);
    } else {
      Navigator.pop(context);
      currentRoute = name;
    }
  }

  void rateApp() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.codecraft.whattodo';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
