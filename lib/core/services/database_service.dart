import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  getUsers() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  getUser(String displayName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isEqualTo: displayName)
        .get();
  }

  uploadUserInfo(User user) async {
    Map<String, String> userInfo = {
      "displayName": user.displayName,
      "email": user.email,
      "photoURL": user.photoURL,
    };
    await FirebaseFirestore.instance.collection('users').add(userInfo);
  }

  createChatRoom(DBUser withUser, User currentUser) async {
    // if (isChatRoomExist(currentUser.email, withUser.email)) {

    // }
    String chatRoomId = '${currentUser.email}_${withUser.email}'
        .replaceAll("@mer.ci.nsu.ru", "");

    Map<String, dynamic> chatRoomMap = {
      "chatroom_id": chatRoomId,
      "users": [currentUser.displayName, withUser.displayName]
    };
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  getChatRooms() async {
    return await FirebaseFirestore.instance.collection('chat_rooms').get();
  }

  sendMessage(String chatRoomId, MessageModel message) async {
    Map<String, dynamic> messageMap = {
      "message": message.message,
      "send_by": message.sendBy
    };

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chat')
        .add(messageMap);
  }

  getMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chat')
        .get();
  }

  Future<bool> isChatRoomExist(String firstUser, String secondUser) async {
    QuerySnapshot querySnapshot = await getChatRooms();

    String chatRoomId =
        '${firstUser}_$secondUser'.replaceAll("@mer.ci.nsu.ru", "");
    String reverseChatRoomId =
        '${secondUser}_$firstUser'.replaceAll("@mer.ci.nsu.ru", "");
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      String idFromQuery = querySnapshot.docs[i].data()['chatroom_id'];
      if (idFromQuery == chatRoomId || idFromQuery == reverseChatRoomId) {
        return true;
      }
    }
    return false;
  }
}
