import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _gooleSignIn = GoogleSignIn();
  final DatabaseService _databaseService = locator<DatabaseService>();
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;

  Future<User> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = _firebaseAuth.currentUser;
      _databaseService.uploadUserInfo(user);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }

  Future<User> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _gooleSignIn.signIn();
    if (googleSignInAccount != null &&
        googleSignInAccount.email.contains('mer.ci.nsu.ru')) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      // ignore: unused_local_variable
      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);

      User user = _firebaseAuth.currentUser;

      if (result.additionalUserInfo.isNewUser) {
        await _databaseService.uploadUserInfo(user);
      }

      return user;
    } else {
      print('Authentification failed');

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
