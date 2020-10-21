import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/chat_room_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class ChatRoomView extends StatefulWidget {
  ChatRoomView({Key key}) : super(key: key);

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseView<ChatRoomModel>(builder: (context, model, child) {
      model.chatItem = ModalRoute.of(context).settings.arguments;
      print(model.chatItem.messages[0].message);
      return Scaffold(
          resizeToAvoidBottomPadding: true,
          floatingActionButton: _messageSenderWidget(() => {
                if (_messageController.text != "")
                  {
                    model.sendMessage(_messageController.text),
                    _messageController.text = ""
                  }
              }),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin:
                          EdgeInsets.only(left: 12.0, top: 40.0, right: 12.0),
                      child: Image(
                          color: AppColors.textColor,
                          height: 24,
                          width: 24,
                          image: AssetImage('assets/icons/back.png')),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Container(
                      height: 30,
                      margin: EdgeInsets.only(top: 40.0, right: 12.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        model.chatItem.chattedUser.displayName,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
              _buildChatList(model),
            ],
          ));
    });
  }

  Widget _buildChatList(ChatRoomModel model) {
    return Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 0),
        height: MediaQuery.of(context).size.height - 142,
        child: model.chatItem.messages.length != 0
            ? ListView.builder(
                itemCount: model.chatItem.messages.length,
                itemBuilder: (context, index) {
                  return Text(model.chatItem.messages[index].message,
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 22));
                })
            : Center(
                child: Text(
                  'Сообщений нет',
                  style: TextStyle(color: AppColors.textColor, fontSize: 22),
                ),
              ));
  }

  Widget _messageSenderWidget(Function _onTap) {
    Function onTap = _onTap;
    Function onSubmitted;
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppColors.secondColor,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 16),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(color: AppColors.textColor),
                  onSubmitted: null,
                  decoration: InputDecoration(
                      hintText: 'Сообщение...',
                      hintStyle:
                          TextStyle(color: AppColors.textColor, fontSize: 14),
                      border: InputBorder.none),
                )),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image(
                        color: AppColors.textColor,
                        height: 24,
                        width: 24,
                        image: AssetImage('assets/icons/chat.png')),
                  ),
                  onTap: () {
                    onTap();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
