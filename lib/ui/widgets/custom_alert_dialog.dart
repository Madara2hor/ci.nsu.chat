import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

import 'models/dialog_content.dart';
import 'models/dialog_style.dart';

class CustomAlertDialog extends StatelessWidget {
  final DialogStyle style;
  final DialogContent content;
  const CustomAlertDialog({this.style, this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
      height: 230,
      decoration: BoxDecoration(
        color: style.mainColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                style.image,
                height: 50,
                width: 50,
                color: AppColors.textColor,
              ),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                color: style.headerColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            content.title,
            style: TextStyle(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Text(
              content.text,
              style: TextStyle(color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: AppColors.textColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Спасибо'),
            textColor: style.headerColor,
          ),
        ],
      ));
}
