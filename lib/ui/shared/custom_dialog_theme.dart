import 'package:ci.nsu.chat/ui/widgets/models/dialog_style.dart';
import 'package:flutter/material.dart';

class CustomDialogTheme {
  static DialogStyle warning =
      DialogStyle(image: 'assets/icons/warning.png', mainColor: Colors.orange);

  static DialogStyle resetPassword = DialogStyle(
      image: 'assets/icons/password.png', mainColor: Colors.indigoAccent);
}
