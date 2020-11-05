import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class NoDataMessageWidget extends StatelessWidget {
  final String message;
  final ViewState modelState;
  const NoDataMessageWidget(this.modelState, this.message);

  @override
  Widget build(BuildContext context) {
    return modelState == ViewState.Busy
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textColor, fontSize: 22),
            ),
          );
  }
}
