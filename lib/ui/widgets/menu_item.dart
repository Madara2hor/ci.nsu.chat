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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Image(
                color: AppColors.thirdColor,
                height: 24,
                width: 24,
                image: AssetImage('assets/icons/$imageName')),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: AppColors.textColor),
            )
          ],
        ),
      ),
    );
  }
}
