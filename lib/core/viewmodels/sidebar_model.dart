import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../locator.dart';

class SideBarModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future<bool> signOut([bool delete]) async {
    delete ??= false;
    setState(ViewState.Busy);

    var isSignOut = await _authenticationService.signOutUser(delete);

    setState(ViewState.Idle);
    if (!isSignOut) {
      return false;
    }

    return true;
  }

  User get currentUser => _authenticationService.currentUser;
}
