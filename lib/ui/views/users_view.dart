import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/users_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/dialog_helper.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/widgets/animated_search_bar.dart';
import 'package:ci.nsu.chat/ui/widgets/models/dialog_content.dart';
import 'package:ci.nsu.chat/ui/widgets/user_search_tile.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  TextEditingController _searchController = TextEditingController();
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<UsersModel>(
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomPadding: false,
          floatingActionButton: AnimatedSearchBar(
              searchController: _searchController,
              onTap: () => model.refreshUsers(),
              onSubmitted: () => model.searchUser(_searchController.text)),
          body: model.state == ViewState.Busy
              ? _circularProgressIndicator()
              : _buildSearchList(model)),
    );
  }

  Widget _circularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildSearchList(UsersModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 0),
        child: model.users.length != 0
            ? ListView.builder(
                itemCount: model.users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      UserSearchTile(
                        user: model.users[index],
                        onTap: () async {
                          var isChatCreated =
                              await model.goToChat(model.users[index]);
                          if (!isChatCreated) {
                            _showWarningDialog();
                          } else {
                            Navigator.pushNamed(
                                context, RouteName.chatRoomRoute);
                          }
                        },
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.5),
                        indent: 3,
                        endIndent: 3,
                      ),
                    ],
                  );
                })
            : Center(
                child: Text(
                  'Пользователь не найден',
                  style: TextStyle(
                      color: Color(0xffd7d7d7),
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ));
  }

  void _showWarningDialog() {
    DialogHelper.warning(
        context,
        DialogContent(
          text: 'Тут ещё нельзя создавать чат с сами собой.',
          title: 'Опаньки!',
        ));
  }
}
