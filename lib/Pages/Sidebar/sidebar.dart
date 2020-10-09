import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
    final User user = context.watch<User>();
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSdeBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSdeBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSdeBarOpenedAsync.data ? 0 : screenWidth - 40,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.indigo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Color(0xFF1BB5FD),
                            fontSize: 16,
                          ),
                        ),
                        Divider(
                          height: 40,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.5),
                          indent: 32,
                          endIndent: 32,
                        ),
                      ],
                    ),
                    MenuItem(
                      icon: Icons.exit_to_app,
                      title: 'Выход',
                      onTap: () async {
                        // onIconPressed();
                        await context
                            .read<AuthenticationService>()
                            .signOutUser();
                      },
                    )
                  ],
                ),
              )),
              Align(
                alignment: Alignment(0, -1),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.indigo,
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

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
