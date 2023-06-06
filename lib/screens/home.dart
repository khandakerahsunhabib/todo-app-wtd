import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
                    title: const Icon(
                      Icons.warning_rounded,
                      size: 50,
                      color: Colors.green,
                    ),
                    content: Text(
                      'Are you sure want to exit?',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: Colors.blue, fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.red, fontSize: 16))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _canPop = true;
                            });
                            exit(0);
                          },
                          child: Text('Yes',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Colors.green, fontSize: 16))),
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
                searchField(_controller, 'search your task here...'),
                const SizedBox(
                  height: 40,
                ),
                headingAndTotalTaskCount(context),
                const SizedBox(
                  height: 40,
                ),
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
    return Expanded(
        child:
            Center(child: Lottie.asset('assets/animations/no-data-new.json')));
  }
}
