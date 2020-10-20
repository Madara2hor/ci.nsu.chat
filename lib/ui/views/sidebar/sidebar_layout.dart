import 'package:ci.nsu.chat/core/viewmodels/sidebar_layout_model.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/views/chat_list_view.dart';
import 'package:ci.nsu.chat/ui/views/users_view.dart';
import 'package:ci.nsu.chat/ui/views/sidebar/sidebar_view.dart';
import 'package:flutter/material.dart';

import '../base_view.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<SideBarLayoutModel>(
        builder: (context, model, child) => Scaffold(
              body: Stack(
                children: [
                  getCurrentPage(model),
                  SideBarView(layoutModel: model),
                ],
              ),
            ));
  }

  Widget getCurrentPage(SideBarLayoutModel model) {
    switch (model.currentPage) {
      case RouteName.chatListRoute:
        return ChatListView();
      case RouteName.usersRoute:
        return UsersView();
      default:
        return Scaffold(
            body: Center(
          child: Text(
            'No route defined for ${model.currentPage}',
            style: TextStyle(
                color: Color(0xffd7d7d7),
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
    }
  }
}
