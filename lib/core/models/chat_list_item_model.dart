import 'db_user_model.dart';

class ChatListItemModel {
  final String chatId;
  final DBUser chattedUser;

  ChatListItemModel(this.chatId, this.chattedUser);
}
