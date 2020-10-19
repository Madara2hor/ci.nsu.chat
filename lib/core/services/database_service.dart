import 'package:ci.nsu.chat/core/models/db_user_model.dart';
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

  createChatRoom(dbUser withUser, User currentUser) async {
    String chatRoomId = '${currentUser.email}_${withUser.email}'
        .replaceAll("@mer.ci.nsu.ru", "");

    Map<String, dynamic> chatRoomMap = {
      "chatroom_id": chatRoomId,
      "users": [currentUser.displayName, withUser.displayName]
    };
    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }
}
