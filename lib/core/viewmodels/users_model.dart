import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../locator.dart';

class UsersModel extends BaseModel {
  final DatabaseService _databaseService = locator<DatabaseService>();

  static List<dbUser> _filtredUsers = [];
  static List<dbUser> _users = [];

  UsersModel() {
    getUsers();
  }

  refreshUsers() {
    _filtredUsers = _users;
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
              .toLowerCase()
              .contains(displayName.toLowerCase().trim())) {
        _filtredUsers.add(_users[i]);
      }
    }

    setState(ViewState.Idle);
  }

  getUsers() async {
    setState(ViewState.Busy);

    QuerySnapshot querySnapshot = await _databaseService.getUsers();
    if (querySnapshot.docs.length > _users.length) {
      _users = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        _users.add(dbUser(
            querySnapshot.docs[i].data()['displayName'],
            querySnapshot.docs[i].data()['email'],
            querySnapshot.docs[i].data()['photoURL']));
      }
    }
    _filtredUsers = _users;

    setState(ViewState.Idle);
  }

  List<dbUser> get users => _filtredUsers;
}
