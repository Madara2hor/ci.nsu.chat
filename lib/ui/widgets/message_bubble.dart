import 'package:bubble/bubble.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/bubble_styles.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isCurrentUserMessage;
  final String message;
  const MessageBubble({this.isCurrentUserMessage, this.message});

  @override
  Widget build(BuildContext context) {
    return isCurrentUserMessage
        ? Bubble(
            style: BubbleStyles.styleMe,
            child: Text(message != null ? message : "null",
                style: TextStyle(color: AppColors.textColor)),
          )
        : Bubble(
            style: BubbleStyles.styleSomebody,
            child: Text(
              message != null ? message : "null",
              style: TextStyle(color: AppColors.textColor),
            ),
          );
  }
}
