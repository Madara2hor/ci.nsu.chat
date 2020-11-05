import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
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
    if (_filtredUsers.length == 0) {
      setState(ViewState.Busy);
    }
  }

  onStream() {
    if (state == ViewState.Busy) {
      setState(ViewState.Stream);
    }
  }

  Stream<QuerySnapshot> usersStream() {
    return _databaseService.getUsersStream();
  }

  parseUsersSnapshot(QuerySnapshot usersSnapshot) async {
    List<DBUser> _tempUsersList = [];
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      _tempUsersList.add(DBUser(
          usersSnapshot.docs[i].data()['displayName'],
          usersSnapshot.docs[i].data()['email'],
          usersSnapshot.docs[i].data()['photoURL']));
    }

    if (_users != _tempUsersList) {
      _users = _tempUsersList;
    }

    _filtredUsers = _users;
    onStream();
  }

  refreshUsers() {
    setState(ViewState.Busy);
    _filtredUsers = _users;
    setState(ViewState.Idle);
  }

  searchUser(String displayName) {
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

  Future<ChatListItemModel> goToChat(DBUser withUser) async {
    User currentUser = _authenticationService.currentUser;
    QuerySnapshot chattedUserSnapshot;
    if (currentUser.displayName == withUser.displayName) {
      return null;
    }

    DocumentSnapshot chatRoomSnapshot =
        await _databaseService.createChatRoom(withUser, currentUser);

    String user_1 = chatRoomSnapshot.data()['users'][0];
    String user_2 = chatRoomSnapshot.data()['users'][1];
    String chatRoomId = chatRoomSnapshot.data()['chatroom_id'];

    if (user_1 == currentUser.displayName) {
      chattedUserSnapshot = await _databaseService.getUser(user_2);
    } else {
      chattedUserSnapshot = await _databaseService.getUser(user_1);
    }

    DBUser chattedUser = DBUser(
        chattedUserSnapshot.docs[0].data()['displayName'],
        chattedUserSnapshot.docs[0].data()['email'],
        chattedUserSnapshot.docs[0].data()['photoURL']);

    return ChatListItemModel(chatRoomId, chattedUser, []);
  }
}
