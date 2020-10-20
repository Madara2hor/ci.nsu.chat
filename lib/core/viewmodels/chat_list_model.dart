import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/models/chat_list_item_model.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
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
    getChatList();
  }

  getChatList() async {
    setState(ViewState.Busy);
    QuerySnapshot chattedUserSnapshot;
    QuerySnapshot chatRoomsSnapshot = await _databaseService.getChatRooms();
    String currentUser = _authenticationService.currentUser.displayName;

    if (chatRoomsSnapshot.docs.length > _chatList.length) {
      _chatList = [];

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

          _chatList.add(ChatListItemModel(chatRoomId, chattedUser));
        }
      }
    }
    refreshChatList();

    setState(ViewState.Idle);
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
