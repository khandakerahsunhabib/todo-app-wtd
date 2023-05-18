import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/model/todo.dart';
import 'package:wtd/screens/home_controller.dart';
import 'package:wtd/widgets/drawer_tile.dart';

String currentRoute = "/";

void doRoute(BuildContext context, String name) {
  if (currentRoute != name) {
    Navigator.pushReplacementNamed(context, name);
  } else {
    Navigator.pop(context);
    currentRoute = name;
  }
}

Drawer myDrawer(String appName, String version, BuildContext context) {
  return Drawer(
    backgroundColor: drawerBgColor,
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [Colors.blue.shade200, Colors.grey.shade300])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 75,
                decoration: const BoxDecoration(
                    //color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/wtd-logo.png'))),
              ),
              Text(
                appName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  version,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          ),
        ),
        DrawerTile(
          leading: Icons.home,
          title: 'Home',
          ontap: () {
            doRoute(context, '/home');
          },
        ),
        const Divider(
          height: 1,
        ),
        DrawerTile(
          leading: Icons.person_2_outlined,
          title: 'About Developer',
          ontap: () {
            doRoute(context, '/about_us');
          },
        ),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.star_border_outlined,
            title: 'Rate Us',
            ontap: () {
              doRoute(context, 'rate_us');
            }),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            ontap: () {
              doRoute(context, 'privacy_policy');
            }),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.share_sharp,
            title: 'Share App',
            ontap: () async {
              await Share.share('Share this text',
                  subject: 'any subject if you have');
            }),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.exit_to_app,
            title: 'Close App',
            ontap: () {
              exit(0);
            })
      ],
    ),
  );
}

Widget searchField(HomeController controller, String hintText) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: TextField(
      onChanged: (value) {
        controller.searchToDoItem();
      },
      controller: controller.searchToDoItemController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: tdGrey)),
    ),
  );
}

Widget addTaskField(HomeController controller) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            controller: controller.todoController,
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
          margin: const EdgeInsets.only(bottom: 20, right: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size(60, 60),
                elevation: 10),
            onPressed: () {
              if (controller.todoController.text.isEmpty) {
                toast('Please add task', Colors.red, Colors.white);
              } else {
                controller.addToDoItem();
                toast('Task added', Colors.green, Colors.white);
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
  );
}

Widget headingWidget() {
  const listTitle = 'My Task List';
  return Container(
    alignment: Alignment.center,
    width: double.infinity,
    height: 40,
    margin: const EdgeInsets.only(top: 40),
    child: const Padding(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        listTitle,
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontFamily: 'MYRIADPRO'),
      ),
    ),
  );
}

Widget totalTaskCount() {
  final HomeController controller = Get.put(HomeController());
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    height: 40,
    width: double.infinity,
    alignment: Alignment.center,
    child: Obx(
      () => Text(
        'Total task added: ${controller.todoList.length.toString()}',
        style: const TextStyle(
            fontFamily: 'MYRIADPRO', fontSize: 16, color: Colors.blueGrey),
      ),
    ),
  );
}

Widget todoList(Function setState) {
  final HomeController controller = Get.put(HomeController());
  return Expanded(
      flex: 1,
      child: Obx(() => ListView.builder(
            itemCount: controller.foundToDo.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onTap: () {
                      setState(() {
                        if (controller.todoList[index].isDone == false) {
                          controller.todoList[index].isDone = true;
                          controller.updateToDoItemByIndex(
                              index,
                              ToDo(
                                  id: controller.todoList[index].id,
                                  todoText: controller.todoList[index].todoText,
                                  isDone: controller.enableDisable(
                                      controller.todoList[index].isDone)));
                          //print('Updated');
                        } else {
                          controller.todoList[index].isDone = false;
                          controller.updateToDoItemByIndex(
                              index,
                              ToDo(
                                  id: controller.todoList[index].id,
                                  todoText: controller.todoList[index].todoText,
                                  isDone: controller.enableDisable(
                                      controller.todoList[index].isDone)));
                        }
                      });
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    tileColor: Colors.white,
                    leading: controller.todoList[index].isDone!
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
                        vertical: 10,
                      ),
                      width: 38,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                        onPressed: () {
                          controller.deleteDataByIndex(index);
                          toast('Task Deleted', Colors.red, Colors.white);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),
                    title: Text(
                      controller.foundToDo[index].todoText.toString(),
                      style: TextStyle(
                          fontSize: 17,
                          decoration: controller.todoList[index].isDone!
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  )
                ],
              ),
            ),
          )));
}

AppBar appBar() {
  return AppBar(
    backgroundColor: tdBGColor,
    foregroundColor: Colors.grey,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      ],
    ),
  );
}

toast(String msg, Color color, Color txtColor) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: txtColor,
      fontSize: 16.0);
}
