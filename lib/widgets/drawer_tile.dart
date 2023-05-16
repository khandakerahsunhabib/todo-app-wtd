import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class DrawerTile extends StatelessWidget {
  final IconData? leading;
  final String? title;
  final Callback? ontap;

  const DrawerTile(
      {super.key,
      required this.leading,
      required this.title,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leading,
        size: 28,
      ),
      style: ListTileStyle.drawer,
      title: Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
      ),
      onTap: ontap,
      horizontalTitleGap: 0,
      iconColor: Colors.blue,
      minLeadingWidth: 50,
    );
  }
}
