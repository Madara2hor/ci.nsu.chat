import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/chat_list_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/views/base_view.dart';
import 'package:ci.nsu.chat/ui/widgets/animated_search_bar.dart';
import 'package:ci.nsu.chat/ui/widgets/chat_list_tile.dart';
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
          body: _buildChatList(model)),
    );
  }

  Widget _buildChatList(ChatListModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 0),
        child: StreamBuilder(
          stream: model.chatRoomsStream(),
          builder: (context, snapshot) {
            model.parseChatRoomsSnapshot(snapshot.data);
            if (snapshot.data != null) {
              return model.chatList.length != 0
                  ? ListView.builder(
                      itemCount: model.chatList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ChatListTile(
                                chatItem: model.chatList[index],
                                onTap: () => Navigator.pushNamed(
                                    context, RouteName.chatRoomRoute,
                                    arguments: model.chatList[index])),
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
                  : _noDataMessageWidget(model.state, 'Пользователь не найден');
            } else {
              return _noDataMessageWidget(
                  model.state, 'Кажется, ты ещё ни с кем не общался...');
            }
          },
        ));
  }

  Widget _noDataMessageWidget(ViewState state, String message) {
    return state == ViewState.Busy
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textColor, fontSize: 22),
            ),
          );
  }
}
