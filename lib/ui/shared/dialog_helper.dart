import 'package:ci.nsu.chat/ui/widgets/models/dialog_content.dart';
import 'package:ci.nsu.chat/ui/shared/custom_dialog_theme.dart';
import 'package:ci.nsu.chat/ui/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static resetPassword(context, DialogContent content) => showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
            content: content,
            style: CustomDialogTheme.resetPassword,
          ));

  static warning(context, DialogContent content) => showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
            content: content,
            style: CustomDialogTheme.warning,
          ));
}
