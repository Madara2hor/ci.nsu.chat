import 'package:ci.nsu.chat/ui/widgets/models/dialog_style.dart';

import 'app_colors.dart';

class CustomDialogTheme {
  static DialogStyle warning = DialogStyle(
      image: 'assets/icons/dislike.png',
      headerColor: AppColors.secondColor,
      mainColor: AppColors.mainColor);

  static DialogStyle resetPassword = DialogStyle(
      image: 'assets/icons/padlock.png',
      headerColor: AppColors.secondColor,
      mainColor: AppColors.mainColor);
}
