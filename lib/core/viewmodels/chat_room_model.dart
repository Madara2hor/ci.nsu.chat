import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../locator.dart';

class ChatRoomModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  ChatListItemModel _chatItem;

  set chatItem(value) => _chatItem = value;
  get chatItem => _chatItem;

  Stream<QuerySnapshot> messagesStream() {
    return _databaseService.getMessagesStream(chatItem.chatId);
  }

  parseMessagesSnapshot(QuerySnapshot messagesSnapshot) {
    if (messagesSnapshot.docs != null) {
      if (messagesSnapshot.docs.length > _chatItem.messages.length) {
        _chatItem.messages = [];
        for (int i = 0; i < messagesSnapshot.docs.length; i++) {
          String message = messagesSnapshot.docs[i].data()['message'];
          String sendBy = messagesSnapshot.docs[i].data()['send_by'];
          String dateTime = messagesSnapshot.docs[i].data()['date_time'];
          _chatItem.messages.add(MessageModel(message, sendBy, dateTime));
        }
      }
    }
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
}
