import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtd/widgets/app_widgets.dart';
import '../model/todo.dart';
import '../screens/home_controller.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _controller = Get.put(HomeController());
  bool _canPop = false;
  final appName = 'What To Do';
  final description = 'A todo app to make your task simple';
  ToDo? todo;

  @override
  Widget build(BuildContext context) {
    _controller.loadToDoItemListData();
    return WillPopScope(
      onWillPop: () async {
        if (_canPop) {
          return true;
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                      'Alert',
                      style: TextStyle(color: Colors.green, fontSize: 25),
                    ),
                    content: const Text(
                      'Are you sure want to exit?',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No',
                              style: TextStyle(
                                color: tdRed,
                              ))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _canPop = true;
                            });
                            //Navigator.of(context).pop();
                            exit(0);
                          },
                          child: const Text('Yes',
                              style: TextStyle(
                                color: Colors.green,
                              ))),
                    ],
                  ));
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: tdBGColor,
        appBar: AppBar(
          backgroundColor: tdBGColor,
          foregroundColor: tdGrey,
          elevation: 0,
        ),
        drawer: myDrawer(appName, description, context),
        body: Stack(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchField(_controller, 'search'),
                    headingWidget(),
                    totalTaskCount(),
                    todoList(setState),
                    addTaskField(_controller)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
