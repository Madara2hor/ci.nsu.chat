import 'dart:async';

import 'package:ci.nsu.chat/core/viewmodels/sidebar_layout_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/sidebar_model.dart';
import 'package:ci.nsu.chat/locator.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/Helpers/custom_menu_clipper.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/widgets/menu_item.dart';
import 'package:ci.nsu.chat/ui/widgets/user_description_tile.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../base_view.dart';

class SideBarView extends StatefulWidget {
  final SideBarLayoutModel layoutModel;

  const SideBarView({this.layoutModel});
  @override
  _SideBarViewState createState() => _SideBarViewState();
}

class _SideBarViewState extends State<SideBarView>
    with SingleTickerProviderStateMixin<SideBarView> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final List<MenuItem> menuItems = [
      MenuItem(
          imageName: 'chat.png',
          title: "Сообщения",
          onTap: () {
            widget.layoutModel.goTo(RouteName.chatListRoute);
          }),
      MenuItem(
          imageName: 'avatar.png',
          title: "Пользователи",
          onTap: () {
            widget.layoutModel.goTo(RouteName.usersRoute);
          }),
    ];

    return BaseView<SideBarModel>(
        builder: (context, model, child) => StreamBuilder<bool>(
              initialData: false,
              stream: isSideBarOpenedStream,
              builder: (context, isSideBarOpenedAsync) {
                return AnimatedPositioned(
                  duration: _animationDuration,
                  top: 0,
                  bottom: 0,
                  left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
                  right: isSideBarOpenedAsync.data ? 70 : screenWidth - 35,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: AppColors.secondColor,
                        child: Column(
                          children: [
                            UserDescriptionTile(user: model.currentUser),
                            Flexible(
                              flex: 2,
                              child: ListView.builder(
                                  itemCount: menuItems.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MenuItem(
                                        imageName: menuItems[index].imageName,
                                        title: menuItems[index].title,
                                        onTap: () {
                                          menuItems[index].onTap();
                                          onIconPressed();
                                        });
                                  }),
                            ),
                            _menuBottomBuilder(model),
                          ],
                        ),
                      )),
                      _sidebarOCButtonBuilder(),
                    ],
                  ),
                );
              },
            ));
  }

  //this widget create GestureDetector which open/close sidebar
  Widget _sidebarOCButtonBuilder() {
    return Align(
      alignment: Alignment(0, 0.95),
      child: GestureDetector(
        onTap: () {
          onIconPressed();
        },
        child: ClipPath(
          clipper: CustomMenuClipper(),
          child: Container(
            padding: const EdgeInsets.only(right: 2.0),
            width: 35,
            height: 110,
            color: Color(0xff312058),
            alignment: Alignment.center,
            child: AnimatedIcon(
              progress: _animationController.view,
              icon: AnimatedIcons.menu_close,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuBottomBuilder(SideBarModel model) {
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
          imageName: 'logout.png',
          title: 'Выход',
          onTap: () async {
            var isSignOut = await model.signOut();
            if (isSignOut) {
              onIconPressed();
              locator<SideBarLayoutModel>().goTo(RouteName.chatListRoute);
              Navigator.pushNamed(context, RouteName.signInRoute);
            } else {
              print("Logout error alert");
            }
          },
        ),
        SizedBox(
          height: 10,
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
