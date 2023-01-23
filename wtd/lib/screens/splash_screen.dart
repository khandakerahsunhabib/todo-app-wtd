import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtd/screens/home_controller.dart';
class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final HomeController _controller=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Loading...'),
        ),
      ),
    );
    _controller.loadToDoItemListData();
  }
}
