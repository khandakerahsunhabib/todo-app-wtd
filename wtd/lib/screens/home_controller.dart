import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../model/todo.dart';
import 'home.dart';

class HomeController extends GetxController{
  final todoController= TextEditingController();
  final searchToDoItemController= TextEditingController();
  var todoList=<ToDo>[].obs;
  var foundToDo=<ToDo>[].obs;

  void addToDoItem() async{
    var box = await Hive.openBox<ToDo>('todoBox');
    box.add(ToDo(id: DateTime.now().microsecondsSinceEpoch.toString(), todoText: todoController.text,));
    todoController.clear();
    getToDoItemList();
  }

  void getToDoItemList() async{
    var box =await  Hive.openBox<ToDo>('todoBox');
    todoList.value=box.values.cast<ToDo>().toList();
    searchToDoItem();
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
    await Future.delayed(const Duration(
          seconds:1
      ));
      getToDoItemList();
    }

  void navigateToHomeScreen() async{
    await Future.delayed(const Duration(
        seconds: 5
    ));
    Get.toNamed(Home.routeName);
  }

  void searchToDoItem(){
    foundToDo.clear();
    var searchingValue=searchToDoItemController.text;
    if(searchingValue.length==0){
       todoList.forEach((element) {
         foundToDo.add(ToDo(id: element.id, todoText: element.todoText));
       });
    }else{
      todoList.forEach((element) {
        if(element.todoText!.toLowerCase().contains(searchingValue.toLowerCase())){
           foundToDo.add(ToDo(id: element.id, todoText: element.todoText));
        }else{
        }
      });
    }
    }
  }