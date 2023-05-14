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
  final _listTitle = 'My Task List';
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
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBox(),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.only(top: 40),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          _listTitle,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontFamily: 'MYRIADPRO'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      height: 40,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          'Total task added: ${_controller.todoList.length.toString()}',
                          style: const TextStyle(
                              fontFamily: 'MYRIADPRO',
                              fontSize: 16,
                              color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Obx(() => ListView.builder(
                              itemCount: _controller.foundToDo.length,
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onTap: () {
                                        setState(() {
                                          if (_controller
                                                  .todoList[index].isDone ==
                                              false) {
                                            _controller.todoList[index].isDone =
                                                true;
                                            _controller.updateToDoItemByIndex(
                                                index,
                                                ToDo(
                                                    id: _controller
                                                        .todoList[index].id,
                                                    todoText: _controller
                                                        .todoList[index]
                                                        .todoText,
                                                    isDone: enableDisable(
                                                        _controller
                                                            .todoList[index]
                                                            .isDone)));
                                            //print('Updated');
                                          } else {
                                            _controller.todoList[index].isDone =
                                                false;
                                            _controller.updateToDoItemByIndex(
                                                index,
                                                ToDo(
                                                    id: _controller
                                                        .todoList[index].id,
                                                    todoText: _controller
                                                        .todoList[index]
                                                        .todoText,
                                                    isDone: enableDisable(
                                                        _controller
                                                            .todoList[index]
                                                            .isDone)));
                                          }
                                        });
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 2),
                                      tileColor: Colors.white,
                                      leading:
                                          _controller.todoList[index].isDone!
                                              ? const Icon(
                                                  Icons.check_box,
                                                  color: tdBlue,
                                                )
                                              : const Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: tdBlue,
                                                ),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 11,
                                        ),
                                        width: 38,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade300,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: IconButton(
                                          onPressed: () {
                                            _controller
                                                .deleteDataByIndex(index);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        _controller.foundToDo[index].todoText
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            decoration: _controller
                                                    .todoList[index].isDone!
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))),
                    AddTaskField()
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool enableDisable(bool? isDone) {
    bool? status = isDone!;
    //print('status: ${status}');
    return status;
  }
}
