import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // getMessages();
  }

  sendMessage(String messageText) async {
    String currentUser = _authenticationService.currentUser.displayName;
    MessageModel message = MessageModel(messageText, currentUser);
    await _databaseService.sendMessage(_chatItem.chatId, message);
  }

  // getMessages() async {
  //   setState(ViewState.Busy);

  //   QuerySnapshot messagesSnapshot =
  //       await _databaseService.getMessages(_chatItemModel.chatId);
  //   if (messagesSnapshot.docs.length > _messages.length) {
  //     _messages = [];
  //     for (int i = 0; i < messagesSnapshot.docs.length; i++) {
  //       String message = messagesSnapshot.docs[i].data()['messsage'];
  //       String sendBy = messagesSnapshot.docs[i].data()['send_by'];
  //       _messages.add(MessageModel(message, sendBy));
  //     }
  //   }

  //   setState(ViewState.Idle);
  // }
}
