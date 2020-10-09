import 'package:flutter/material.dart';

import 'dialog_helper.dart';

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
      height: 300,
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
                height: 120,
                width: 120,
              ),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
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
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Text(
              content.text,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Спасибо'),
            textColor: style.mainColor,
          ),
        ],
      ));
}
