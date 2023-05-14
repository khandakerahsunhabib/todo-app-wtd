import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/screens/home_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key); 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final HomeController _controller = Get.put(HomeController());
  final appName = "ToDo App";

  @override
  void initState() {
    _controller.navigateToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _upperPart(),
              _lowerPart(),
            ],
          )),
    );
  }

  _upperPart() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/wtd-logo.png'))),
          ),
        ),
        Center(
          child: Text(
            appName,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black45, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _lowerPart() {
    return const Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Center(
            child: Text(
              'Simple ToDo App',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ),
        Center(
          child: Text(
            'To Make Your Task Simple',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
