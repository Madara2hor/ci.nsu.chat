import 'package:ci.nsu.chat/ui/views/chat_rooms_view.dart';
import 'package:ci.nsu.chat/ui/views/sidebar/sidebar_view.dart';
import 'package:flutter/material.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ChatRoomsView(),
          SideBarView(),
        ],
      ),
    );
  }
}
