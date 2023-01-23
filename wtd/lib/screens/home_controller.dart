import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../model/todo.dart';

class HomeController extends GetxController{
  final todoController= TextEditingController();
  var todoList=<ToDo>[].obs;
  var todoIsDone=false.obs;

  void addToDoItem() async{
    var box = await Hive.openBox<ToDo>('todoBox');
    box.add(ToDo(id: DateTime.now().microsecondsSinceEpoch.toString(), todoText: todoController.text,));
    todoController.clear();
    getToDoItemList();
  }

  void getToDoItemList() async{
    var box =await  Hive.openBox<ToDo>('todoBox');
    todoList.value=box.values.cast<ToDo>().toList();
  }

  void updateToDoItemByIndex(int index, ToDo todo) async{
    var box =await Hive.openBox<ToDo>('todoBox');
    await box.putAt(index, todo);
    getToDoItemList();
  }

  void deleteDataByIndex(int index)async{
    var box =await  Hive.openBox<ToDo>('todoBox');
    await box.deleteAt(index);
    getToDoItemList();
  }

  void loadToDoItemListData()async{
    await Future.delayed(Duration(
          seconds: 5
      ));
      getToDoItemList();
    }
  }
