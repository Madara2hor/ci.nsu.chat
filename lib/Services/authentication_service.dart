import 'package:ci.nsu.chat/Helpers/dialog_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final _gooleSignIn = GoogleSignIn();

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = _firebaseAuth.currentUser;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }

  Future<User> googleSignIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _gooleSignIn.signIn();
    if (googleSignInAccount != null &&
        googleSignInAccount.email.contains('mer.ci.nsu.ru')) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);

      User user = _firebaseAuth.currentUser;

      return user;
    } else {
      print('Authentification failed');
      DialogHelper.warning(
          context,
          DialogContent(
            text: 'Для входа в чат нужен аккаунта колледжа.',
            title: 'Попался!',
          ));
      signOutUser();

      return null;
    }
  }

  Future<bool> signOutUser([bool delete]) async {
    delete ??= false;
    User firebaseUser = _firebaseAuth.currentUser;
    GoogleSignInAccount googleUser = _gooleSignIn.currentUser;

    if (googleUser != null) {
      await _gooleSignIn.disconnect();
    }
    if (firebaseUser != null) {
      if (delete) {
        await _firebaseAuth.currentUser.delete();
      } else {
        await _firebaseAuth.signOut();
      }
    }

    return Future.value(true);
  }
}
