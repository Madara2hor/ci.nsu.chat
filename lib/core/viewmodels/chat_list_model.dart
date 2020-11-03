import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/core/models/message_model.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:ci.nsu.chat/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel extends BaseModel {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  static List<ChatListItemModel> _filtredChatList = [];
  static List<ChatListItemModel> _chatList = [];

  List<ChatListItemModel> get chatList => _filtredChatList;

  ChatListModel() {
    if (_filtredChatList.length == 0) {
      setState(ViewState.Busy);
    }
  }

  onStream() {
    if (state == ViewState.Busy) {
      setState(ViewState.Idle);
    }
  }

  Stream<QuerySnapshot> chatRoomsStream() {
    return _databaseService.getChatRoomsStream();
  }

  parseChatRoomsSnapshot(QuerySnapshot chatRoomsSnapshot) async {
    QuerySnapshot chattedUserSnapshot;
    String currentUser = _authenticationService.currentUser.displayName;
    List<ChatListItemModel> _tempChatList = [];
    for (int i = 0; i < chatRoomsSnapshot.docs.length; i++) {
      String user_1 = chatRoomsSnapshot.docs[i].data()['users'][0];
      String user_2 = chatRoomsSnapshot.docs[i].data()['users'][1];
      String chatRoomId = chatRoomsSnapshot.docs[i].data()['chatroom_id'];

      if (user_1 == currentUser || user_2 == currentUser) {
        if (user_1 == currentUser) {
          chattedUserSnapshot = await _databaseService.getUser(user_2);
        } else {
          chattedUserSnapshot = await _databaseService.getUser(user_1);
        }

        DBUser chattedUser = DBUser(
            chattedUserSnapshot.docs[0].data()['displayName'],
            chattedUserSnapshot.docs[0].data()['email'],
            chattedUserSnapshot.docs[0].data()['photoURL']);

        QuerySnapshot messagesSnapshot =
            await _databaseService.getMessages(chatRoomId);
        List<MessageModel> messages = [];

        String message = messagesSnapshot.docs[messagesSnapshot.docs.length - 1]
            .data()['message'];
        String sendBy = messagesSnapshot.docs[messagesSnapshot.docs.length - 1]
            .data()['send_by'];
        String dateTime = messagesSnapshot
            .docs[messagesSnapshot.docs.length - 1]
            .data()['date_time'];
        messages.add(MessageModel(message, sendBy, dateTime));

        if (messages.length > 0) {
          _tempChatList
              .add(ChatListItemModel(chatRoomId, chattedUser, messages));
        }
      }
    }
    if (_chatList != _tempChatList) {
      _chatList = _tempChatList;
    }

    sortChatList();
    _filtredChatList = _chatList;
    onStream();
  }

  sortChatList() {
    if (_chatList == null || _chatList.length == 0) {
      return;
    }
    _chatList.sort((a, b) => b.messages[b.messages.length - 1].dateTime
        .toString()
        .compareTo(a.messages[a.messages.length - 1].dateTime.toString()));
  }

  refreshChatList() {
    setState(ViewState.Busy);
    _filtredChatList = _chatList;
    setState(ViewState.Idle);
  }

  searchChatRoom(String displayName) async {
    setState(ViewState.Busy);

    String currentUser = _authenticationService.currentUser.displayName;
    _filtredChatList = [];
    for (int i = 0; i < _chatList.length; i++) {
      if (_chatList[i]
              .chattedUser
              .displayName
              .toLowerCase()
              .contains(displayName.toLowerCase().trim()) &&
          !currentUser
              .toLowerCase()
              .contains(displayName.toLowerCase().trim())) {
        _filtredChatList.add(_chatList[i]);
      }
    }

    setState(ViewState.Idle);
  }
}
