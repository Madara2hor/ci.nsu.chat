import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

extension BubbleStyles on BubbleStyle {
  static final BubbleStyle styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: AppColors.somebodyMessageColor,
    elevation: 5,
    margin: BubbleEdges.only(top: 8.0, right: 50.0),
    alignment: Alignment.topLeft,
  );

  static final BubbleStyle styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: AppColors.myMessageColor,
    elevation: 5,
    margin: BubbleEdges.only(top: 8.0, left: 50.0),
    alignment: Alignment.topRight,
  );
}
