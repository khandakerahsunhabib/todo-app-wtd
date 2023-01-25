import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/screens/home_controller.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final HomeController _controller=Get.put(HomeController());

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
        )
      ),
    );
    _controller.loadToDoItemListData();
  }
  _upperPart() {
    return Column(
      children:[
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/wtd-logo.png')
                )
            ),
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('What to do', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            ),),
          ),
        )
      ],
    );
  }
  _lowerPart() {
    return Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top:20, bottom: 5),
          child: Center(
            child: Text('Simple ToDo App', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),),
          ),
        ),
        Center(
          child: Text('To Make Your Task Simple', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          ),),
        ),
      ],
    );
  }
}
