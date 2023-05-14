import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/screens/home_controller.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  final appName = "What To Do";
  final description= "A todo app to make your task simple";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBgColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
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
                    description,
                    style: Theme.of(context).textTheme.labelMedium,
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

class SearchBox extends StatelessWidget {
  SearchBox({super.key});

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
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
}

class AddTaskField extends StatelessWidget {
    AddTaskField({super.key});
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
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
            margin: const EdgeInsets.only(bottom: 20, right: 10),
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
    );
  }
}
