import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:ci.nsu.chat/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel extends BaseModel {
  final DatabaseService _databaseService = locator<DatabaseService>();

  Future<List<dbUser>> searchUser(String displayName) async {
    setState(ViewState.Busy);
    QuerySnapshot querySnapshot = await _databaseService.getUsers();
    List<dbUser> users = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      users.add(dbUser(
          querySnapshot.docs[i].data()['displayName'],
          querySnapshot.docs[i].data()['email'],
          querySnapshot.docs[i].data()['photoURL']));
    }
    setState(ViewState.Idle);
    return users;
  }
}
