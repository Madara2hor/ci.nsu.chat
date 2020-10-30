import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../locator.dart';

class ChatRoomModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  ChatListItemModel _chatItem;
  //List<ChatListItemModel> _messages = [];

  set chatItem(value) => _chatItem = value;
  get chatItem => _chatItem;
  //get messages => _messages;

  ChatRoomModel() {
    if (_chatItem == null) {}
  }

  sendMessage(String messageText) async {
    String currentUser = _authenticationService.currentUser.displayName;

    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String stringDateTime = dateFormat.format(dateTime);

    MessageModel message =
        MessageModel(messageText, currentUser, stringDateTime);

    await _databaseService.sendMessage(_chatItem.chatId, message);
  }

  getMessages() async {
    QuerySnapshot messagesSnapshot =
        await _databaseService.getMessages(_chatItem.chatId);
    if (messagesSnapshot.docs.length > _chatItem.messages.length) {
      _chatItem.messages = [];
      for (int i = 0; i < messagesSnapshot.docs.length; i++) {
        String message = messagesSnapshot.docs[i].data()['messsage'];
        String sendBy = messagesSnapshot.docs[i].data()['send_by'];
        String dateTime = messagesSnapshot.docs[i].data()['date_time'];
        _chatItem.messages.add(MessageModel(message, sendBy, dateTime));
      }
    }

    setState(ViewState.Idle);
  }
}
