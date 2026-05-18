import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/model/todo.dart';
import 'package:wtd/screens/home_controller.dart';
import 'package:wtd/widgets/drawer_tile.dart';

final HomeController controller = Get.put(HomeController());

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
            controller.doRoute(context, '/home');
          },
        ),
        const Divider(
          height: 1,
        ),
        DrawerTile(
          leading: Icons.person_2_outlined,
          title: 'About Developer',
          ontap: () {
            controller.doRoute(context, '/about_us');
          },
        ),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.star_border_outlined,
            title: 'Rate Us',
            ontap: () {
              controller.rateApp();
            }),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            ontap: () {
              controller.doRoute(context, '/privacy_policy');
            }),
        const Divider(
          height: 1,
        ),
        DrawerTile(
            leading: Icons.share_sharp,
            title: 'Share App',
            ontap: () async {
              await SharePlus.instance.share(
                ShareParams(
                  text: 'https://play.google.com/store/apps/details?id=com.codecraft.whattodo',
                  subject: 'any subject if you have',
                ),
              );
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
    width: double.infinity,
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
        border: Border.all(
            width: 1, style: BorderStyle.solid, color: Colors.blue.shade200),
        color: tdBGColor,
        borderRadius: BorderRadius.circular(20)),
    child: TextField(
      onChanged: (value) {
        controller.searchToDoItem();
      },
      controller: controller.searchToDoItemController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
    ),
  );
}

Widget headingAndTotalTaskCount(BuildContext context) {
  const listTitle = 'My Task List';
  const totalTaskTitle = 'Total task added ';

  return Column(
    children: [
      Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 36,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(listTitle,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MYRIADPRO')),
        ),
      ),
      Container(
        height: 30,
        width: double.infinity,
        alignment: Alignment.center,
        child: Obx(
          () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(totalTaskTitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.black38)),
                Container(
                  alignment: Alignment.center,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    controller.todoList.length.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ]),
        ),
      )
    ],
  );
}

void _showEditDialog(BuildContext context, ToDo item, int actualIndex, HomeController controller) {
  final editController = TextEditingController(text: item.todoText);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Task', style: TextStyle(color: Colors.blue)),
      content: TextField(
        controller: editController,
        decoration: InputDecoration(
          hintText: 'Enter task text',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            if (editController.text.trim().isNotEmpty) {
              controller.updateToDoItemByIndex(
                actualIndex,
                ToDo(
                  id: item.id,
                  todoText: editController.text.trim(),
                  isDone: item.isDone,
                  createdAt: item.createdAt,
                ),
              );
              Navigator.pop(context);
              toast('Task Updated', Colors.green, Colors.white);
            } else {
              toast('Task text cannot be empty', Colors.red, Colors.white);
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.green)),
        ),
      ],
    ),
  );
}

void _showDeleteConfirmationDialog(BuildContext context, int actualIndex, HomeController controller) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 10),
          Text('Delete Task'),
        ],
      ),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No', style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          onPressed: () {
            controller.deleteDataByIndex(actualIndex);
            Navigator.pop(context);
            toast('Task Deleted', Colors.red, Colors.white);
          },
          child: const Text('Yes', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

Widget todoList(Function setState) {
  final HomeController controller = Get.put(HomeController());
  return ListView.builder(
            itemCount: controller.foundToDo.length,
            itemBuilder: (context, index) {
              final ToDo item = controller.foundToDo[index];
              final actualIndex = controller.todoList.indexWhere((element) => element.id == item.id);
              if (actualIndex == -1) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      onTap: () {
                        setState(() {
                          if (item.isDone == false || item.isDone == null) {
                            item.isDone = true;
                            controller.updateToDoItemByIndex(
                                actualIndex,
                                ToDo(
                                    id: item.id,
                                    todoText: item.todoText,
                                    isDone: true,
                                    createdAt: item.createdAt));
                          } else {
                            item.isDone = false;
                            controller.updateToDoItemByIndex(
                                actualIndex,
                                ToDo(
                                    id: item.id,
                                    todoText: item.todoText,
                                    isDone: false,
                                    createdAt: item.createdAt));
                          }
                        });
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      tileColor: Colors.white30,
                      leading: item.isDone == true
                          ? const Icon(
                              Icons.check_box,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.blue,
                            ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.blue,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(context, item, actualIndex, controller);
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(context, actualIndex, controller);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        item.todoText.toString(),
                        style: TextStyle(
                            fontSize: 17,
                            decoration: item.isDone == true
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      subtitle: item.createdAt != null
                          ? Text(
                              item.createdAt!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            )
                          : null,
                    )
                  ],
                ),
              );
            },
          );
}

AppBar appBar() {
  return AppBar(
    backgroundColor: tdBGColor,
    foregroundColor: Colors.blue,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              toast('Settings feature coming soon', Colors.grey, Colors.white);
            },
            icon: const Icon(Icons.settings))
      ],
    ),
  );
}

void toast(String msg, Color color, Color txtColor) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: txtColor,
    fontSize: 16.0,
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
              hintText: "Enter your task here",
              hintStyle: TextStyle(
                color: tdGrey,
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
                backgroundColor: Colors.blue,
                minimumSize: const Size(60, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10),
            onPressed: () {
              if (controller.todoController.text.isEmpty) {
                toast("Please add task", Colors.green, Colors.white);
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
