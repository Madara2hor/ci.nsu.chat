import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../locator.dart';

class UserSearchTileModel extends BaseModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future<bool> goToChat(dbUser withUser) async {
    User currentUser = _authenticationService.currentUser;

    if (currentUser.displayName == withUser.displayName) {
      return false;
    }

    await _databaseService.createChatRoom(withUser, currentUser);

    return true;
  }
}
