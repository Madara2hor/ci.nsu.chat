import 'package:ci.nsu.chat/ui/shared/app_colors.dart';

import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String imageName;
  final String title;
  final Function onTap;

  const MenuItem(
      {@required this.imageName, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: AppColors.secondColor,
        child: Row(
          children: <Widget>[
            Image(
                color: AppColors.thirdColor,
                height: 22,
                width: 22,
                image: AssetImage('assets/icons/$imageName')),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            )
          ],
        ),
      ),
    );
  }
}
