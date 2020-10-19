import 'package:ci.nsu.chat/core/viewmodels/chat_list_model.dart';
import 'package:ci.nsu.chat/ui/views/base_view.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  //TextEditingController _searchController = TextEditingController();
  //bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatListModel>(
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