import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        drawer: _myDrawer(),
        body: Stack(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBox(),
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
                            )))
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _controller.todoController,
                      decoration: const InputDecoration(
                        hintText: 'Add your task here',
                        hintStyle: TextStyle(
                          color: tdBlue,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: const Size(60, 60),
                          elevation: 10),
                      onPressed: () {
                        if (_controller.todoController.text.isEmpty) {
                          Get.showSnackbar(
                            const GetSnackBar(
                              message: 'Please Add Your Task!',
                              icon: Icon(
                                Icons.announcement,
                                color: Colors.white,
                              ),
                              duration: Duration(seconds: 2),
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: tdBlack,
                              margin: EdgeInsets.all(20),
                              borderRadius: 10,
                            ),
                          );
                        } else {
                          _controller.addToDoItem();
                          Get.showSnackbar(
                            const GetSnackBar(
                              message: 'Task Added Successfully!',
                              snackPosition: SnackPosition.TOP,
                              duration: Duration(seconds: 2),
                              backgroundColor: tdBlack,
                              margin: EdgeInsets.all(20),
                              borderRadius: 10,
                              icon: Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) {
          _controller.searchToDoItem();
        },
        controller: _controller.searchToDoItemController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  bool enableDisable(bool? isDone) {
    bool? status = isDone!;
    //print('status: ${status}');
    return status;
  }

  _myDrawer() {
    const appName = "What To Do";
    return Drawer(
      backgroundColor: drawerBgColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      //color: Colors.blue,
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/wtd-logo.png'))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('About Developer'),
          ),
          const Divider(
            height: 1,
          ),
          const ListTile(
            leading: Icon(Icons.star_border_outlined),
            title: Text('Rate Us'),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit App'),
            onTap: () {
              exit(0);
            },
          )
        ],
      ),
    );
  }
}
