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
  final version = 'App Version: 1.0.0';
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
        appBar: appBar(),
        drawer: myDrawer(appName, version, context),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                searchField(_controller, 'Search task here...'),
                const Padding(padding: EdgeInsets.only(top: 40)),
                headingAndTotalTaskCount(),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Obx(
                  () => Container(
                    child: controller.foundToDo.isEmpty
                        ? _emptyList()
                        : todoList(setState),
                  ),
                ),
                addTaskField(_controller)
              ],
            )),
      ),
    );
  }

  _emptyList() {
    return const Expanded(child: Center(child: Text('List is Empty')));
  }
}
