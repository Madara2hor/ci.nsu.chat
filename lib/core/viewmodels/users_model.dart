import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../locator.dart';

class UsersModel extends BaseModel {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  static List<DBUser> _filtredUsers = [];
  static List<DBUser> _users = [];

  List<DBUser> get users => _filtredUsers;

  UsersModel() {
    getUsers();
  }

  getUsers() async {
    setState(ViewState.Busy);

    QuerySnapshot querySnapshot = await _databaseService.getUsers();
    if (querySnapshot.docs.length > _users.length) {
      _users = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        _users.add(DBUser(
            querySnapshot.docs[i].data()['displayName'],
            querySnapshot.docs[i].data()['email'],
            querySnapshot.docs[i].data()['photoURL']));
      }
    }
    refreshUsers();
    setState(ViewState.Idle);
  }

  refreshUsers() {
    setState(ViewState.Busy);
    _filtredUsers = _users;
    setState(ViewState.Idle);
  }

  searchUser(String displayName) async {
    setState(ViewState.Busy);
    _filtredUsers = [];
    for (int i = 0; i < _users.length; i++) {
      if (_users[i]
              .displayName
              .toLowerCase()
              .contains(displayName.toLowerCase().trim()) ||
          _users[i]
              .email
              .replaceAll("@mer.ci.nsu.ru", "")
              .contains(displayName.toLowerCase().trim())) {
        _filtredUsers.add(_users[i]);
      }
    }

    setState(ViewState.Idle);
  }

  goToChat(DBUser withUser) async {
    User currentUser = _authenticationService.currentUser;
    ChatListItemModel chatItem;
    if (currentUser.displayName == withUser.displayName) {
      return null;
    }

    QuerySnapshot chattedUserSnapshot;
    var chatRoomSnapshot =
        await _databaseService.createChatRoom(withUser, currentUser);

    String user_1 = chatRoomSnapshot.data()['users'][0];
    String user_2 = chatRoomSnapshot.data()['users'][1];
    String chatRoomId = chatRoomSnapshot.data()['chatroom_id'];

    if (user_1 == currentUser.displayName ||
        user_2 == currentUser.displayName) {
      if (user_1 == currentUser.displayName) {
        chattedUserSnapshot = await _databaseService.getUser(user_2);
      } else {
        chattedUserSnapshot = await _databaseService.getUser(user_1);
      }

      DBUser chattedUser = DBUser(
          chattedUserSnapshot.docs[0].data()['displayName'],
          chattedUserSnapshot.docs[0].data()['email'],
          chattedUserSnapshot.docs[0].data()['photoURL']);

      QuerySnapshot messagesSnapshot =
          await _databaseService.getMessages(chatRoomId);

      List<MessageModel> messages = [];
      for (int i = 0; i < messagesSnapshot.docs.length; i++) {
        String message = messagesSnapshot.docs[i].data()['message'];
        String sendBy = messagesSnapshot.docs[i].data()['send_by'];
        String dateTime = messagesSnapshot.docs[i].data()['date_time'];
        messages.add(MessageModel(message, sendBy, dateTime));
      }

      chatItem = ChatListItemModel(chatRoomId, chattedUser, messages);
    }

    return chatItem;
  }
}
