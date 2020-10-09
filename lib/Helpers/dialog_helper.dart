import 'package:ci.nsu.chat/Helpers/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static resetPassword(context, DialogContent content) => showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
            content: content,
            style: DialogThemes.resetPassword,
          ));
  static warning(context, DialogContent content) => showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
            content: content,
            style: DialogThemes.warning,
          ));
}

class DialogContent {
  final String title;
  final String text;

  DialogContent({@required this.title, @required this.text});
}

class DialogStyle {
  final String image;
  final Color mainColor;

  DialogStyle({@required this.image, @required this.mainColor});
}

class DialogThemes {
  static DialogStyle warning =
      DialogStyle(image: 'assets/icons/warning.png', mainColor: Colors.orange);
  static DialogStyle resetPassword = DialogStyle(
      image: 'assets/icons/password.png', mainColor: Colors.indigoAccent);
}
