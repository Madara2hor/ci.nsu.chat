import 'package:ci.nsu.chat/core/viewmodels/chat_rooms_model.dart';
import 'package:ci.nsu.chat/ui/views/base_view.dart';
import 'package:flutter/material.dart';

class ChatRoomsView extends StatefulWidget {
  @override
  _ChatRoomsViewState createState() => _ChatRoomsViewState();
}

class _ChatRoomsViewState extends State<ChatRoomsView> {
  //TextEditingController _searchController = TextEditingController();
  //bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatRoomsModel>(
        builder: (context, model, child) => Scaffold(
                body: Center(
              child: Text(
                'Чат',
                style: TextStyle(
                    color: Color(0xffd7d7d7),
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            )));
  }
}
