import 'package:ci.nsu.chat/core/enums/viewState.dart';
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

  Future<bool> goToChat(DBUser withUser) async {
    User currentUser = _authenticationService.currentUser;

    if (currentUser.displayName == withUser.displayName) {
      return false;
    }

    await _databaseService.createChatRoom(withUser, currentUser);

    return true;
  }
}
