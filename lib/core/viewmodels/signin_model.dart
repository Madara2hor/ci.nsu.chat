import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';

import '../../locator.dart';

class SignInModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future<bool> login() async {
    setState(ViewState.Busy);

    var user = await _authenticationService.googleSignIn();

    setState(ViewState.Idle);

    if (user == null) {
      return false;
    }

    return true;
  }
}
