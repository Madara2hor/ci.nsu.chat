import 'package:ci.nsu.chat/core/viewmodels/chat_list_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/views/base_view.dart';
import 'package:ci.nsu.chat/ui/widgets/animated_search_bar.dart';
import 'package:ci.nsu.chat/ui/widgets/chat_list_tile.dart';
import 'package:ci.nsu.chat/ui/widgets/no_data_message.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatListModel>(
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomPadding: false,
          floatingActionButton: AnimatedSearchBar(
              searchController: _searchController,
              onTap: () => model.refreshChatList(),
              onSubmitted: () => model.searchChatRoom(_searchController.text)),
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
                          'Сообщения',
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
                child: _buildChatList(model),
              ),
            ],
          )),
    );
  }

  Widget _buildChatList(ChatListModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: StreamBuilder(
          stream: model.chatRoomsStream(),
          builder: (context, snapshot) {
            model.parseChatRoomsSnapshot(snapshot.data);
            if (snapshot.data != null) {
              return model.chatList.length != 0
                  ? ListView.builder(
                      itemCount: model.chatList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: AppColors.mainColor,
                          shadowColor: AppColors.textColor,
                          child: ChatListTile(
                              chatItem: model.chatList[index],
                              onTap: () => Navigator.pushNamed(
                                  context, RouteName.chatRoomRoute,
                                  arguments: model.chatList[index])),
                        );
                      })
                  : model.isRoomsExist()
                      ? NoDataMessageWidget(
                          model.state, 'Пользователь не найден')
                      : NoDataMessageWidget(model.state,
                          'Кажется, ты ещё ни с кем не общался...');
            } else {
              return NoDataMessageWidget(
                  model.state, 'Кажется, ты ещё ни с кем не общался...');
            }
          },
        ));
  }
}
