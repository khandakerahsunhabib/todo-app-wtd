import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EmptyList extends StatelessWidget {
  EmptyList({Key? key}) : super(key: key);
  static const routeName='/empty_list';

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      body: Container(
        width: 100,
        height: 100,
        color: Colors.red,
        child: Text('Your List is Empty'),
      ),
    ));
  }
}
