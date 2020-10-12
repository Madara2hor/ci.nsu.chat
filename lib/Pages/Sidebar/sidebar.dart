import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/Helpers/app_colors.dart';
import 'package:ci.nsu.chat/Helpers/custom_menu_clipper.dart';
import 'package:ci.nsu.chat/Pages/Sidebar/menu_item.dart';
import 'package:ci.nsu.chat/Services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSideBarOpenedStreamController;
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSideBarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSideBarOpenedStreamController.stream;
    isSideBarOpenedSink = isSideBarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSideBarOpenedStreamController.close();
    isSideBarOpenedSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 70 : screenWidth - 40,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.secondColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _userProfileBuilder(user),
                    _menuBottomBuilder(),
                  ],
                ),
              )),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xff312058),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _menuBottomBuilder() {
    return Column(
      children: [
        Divider(
          height: 0,
          thickness: 0.5,
          color: Colors.white.withOpacity(0.5),
          indent: 5,
          endIndent: 5,
        ),
        MenuItem(
          icon: Icons.exit_to_app,
          title: 'Выход',
          onTap: () async {
            await context.read<AuthenticationService>().signOutUser();
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _userProfileBuilder(User user) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        CachedNetworkImage(
          imageUrl: user.photoURL,
          imageBuilder: (context, imageProvider) => Container(
            child: CircleAvatar(
              backgroundImage: imageProvider,
              radius: 45.0,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          user.displayName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.thirdColor,
            fontSize: 16,
          ),
        ),
        Divider(
          height: 20,
          thickness: 0.5,
          color: Colors.white.withOpacity(0.5),
          indent: 5,
          endIndent: 5,
        ),
      ],
    );
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnmationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnmationCompleted) {
      isSideBarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }
}
