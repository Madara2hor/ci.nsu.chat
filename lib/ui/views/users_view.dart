import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/users_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/dialog_helper.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/widgets/animated_search_bar.dart';
import 'package:ci.nsu.chat/ui/widgets/models/dialog_content.dart';
import 'package:ci.nsu.chat/ui/widgets/no_data_message.dart';
import 'package:ci.nsu.chat/ui/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<UsersModel>(
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomPadding: true,
          floatingActionButton: AnimatedSearchBar(
              searchController: _searchController,
              onTap: () => model.refreshUsers(),
              onSubmitted: () => model.searchUser(_searchController.text)),
          body: Column(
            children: [
              Container(
                color: AppColors.secondColor,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(top: 35.0, right: 12.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Пользователи',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: _buildUsersList(model),
              ),
            ],
          )),
    );
  }

  Widget _buildUsersList(UsersModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: StreamBuilder(
          stream: model.usersStream(),
          builder: (context, snapshot) {
            model.parseUsersSnapshot(snapshot.data);
            if (snapshot.data != null) {
              return model.users.length != 0
                  ? ListView.builder(
                      itemCount: model.users.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: AppColors.mainColor,
                          shadowColor: AppColors.textColor,
                          child: UserListTile(
                            user: model.users[index],
                            onTap: () {
                              model
                                  .goToChat(model.users[index])
                                  .then((chatItem) => {
                                        if (chatItem == null)
                                          {_showWarningDialog()}
                                        else
                                          {
                                            Navigator.pushNamed(context,
                                                RouteName.chatRoomRoute,
                                                arguments: chatItem)
                                          }
                                      });
                            },
                          ),
                        );
                      })
                  : NoDataMessageWidget(model.state, 'Пользователь не найден');
            } else {
              return NoDataMessageWidget(
                  model.state, 'Этим приложением ещё никто не пользовался...');
            }
          },
        ));
  }

  void _showWarningDialog() {
    DialogHelper.warning(
        context,
        DialogContent(
          text: 'Здесь ещё нельзя создавать чат с самим собой.',
          title: 'Очень жаль...',
        ));
  }
}
