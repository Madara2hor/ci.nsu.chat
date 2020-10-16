import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  getUsers() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  uploadUserInfo(User user) async {
    Map<String, String> userInfo = {
      "displayName": user.displayName,
      "email": user.email,
      "photoURL": user.photoURL,
    };
    await FirebaseFirestore.instance.collection('users').add(userInfo);
  }
}
