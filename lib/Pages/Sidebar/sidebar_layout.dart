import 'package:ci.nsu.chat/Pages/Sidebar/sidebar.dart';
import 'package:ci.nsu.chat/Pages/home.dart';
import 'package:flutter/material.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomePage(),
          SideBar(),
        ],
      ),
    );
  }
}
