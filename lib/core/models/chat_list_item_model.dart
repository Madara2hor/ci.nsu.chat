import 'db_user_model.dart';
import 'message_model.dart';

class ChatListItemModel {
  final String chatId;
  final DBUser chattedUser;
  List<MessageModel> messages;

  ChatListItemModel(this.chatId, this.chattedUser, this.messages);
}
