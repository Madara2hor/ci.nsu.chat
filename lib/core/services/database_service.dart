import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<QuerySnapshot> getUsers() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .orderBy('displayName')
        .get();
  }

  Future<QuerySnapshot> getUser(String displayName) async {
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

  Future<DocumentSnapshot> createChatRoom(
      DBUser withUser, User currentUser) async {
    Future<DocumentSnapshot> chatRoomDocument =
        tryGetExistChatRoom(currentUser.email, withUser.email);
    if (chatRoomDocument == null) {
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

      return getChatRoomById(chatRoomId);
    } else {
      return chatRoomDocument;
    }
  }

  Future<QuerySnapshot> getChatRooms() async {
    return await FirebaseFirestore.instance.collection('chat_rooms').get();
  }

  Stream<QuerySnapshot> getChatRoomsStream() {
    return FirebaseFirestore.instance.collection('chat_rooms').snapshots();
  }

  Future<DocumentSnapshot> getChatRoomById(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .get();
  }

  Future<QuerySnapshot> getMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chat')
        .orderBy('date_time')
        .get();
  }

  Stream<QuerySnapshot> getMessagesStream(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chat')
        .orderBy('date_time')
        .snapshots();
  }

  sendMessage(String chatRoomId, MessageModel message) async {
    Map<String, dynamic> messageMap = {
      "message": message.message,
      "send_by": message.sendBy,
      "date_time": message.dateTime
    };

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chat')
        .add(messageMap);
  }

  Future<DocumentSnapshot> tryGetExistChatRoom(
      String firstUser, String secondUser) async {
    String chatRoomId =
        '${firstUser}_$secondUser'.replaceAll("@mer.ci.nsu.ru", "");
    String reverseChatRoomId =
        '${secondUser}_$firstUser'.replaceAll("@mer.ci.nsu.ru", "");

    DocumentSnapshot chatRoomQuery = await getChatRoomById(chatRoomId);
    DocumentSnapshot reverseChatRoomQuery =
        await getChatRoomById(reverseChatRoomId);

    if (chatRoomQuery.exists) {
      return chatRoomQuery;
    } else if (reverseChatRoomQuery.exists) {
      return reverseChatRoomQuery;
    }

    return null;
  }
}
