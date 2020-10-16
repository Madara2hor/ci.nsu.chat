import 'package:flutter/material.dart';

class ChatRoomsView extends StatefulWidget {
  ChatRoomsView({Key key}) : super(key: key);

  @override
  _ChatRoomsViewState createState() => _ChatRoomsViewState();
}

class _ChatRoomsViewState extends State<ChatRoomsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Text(
            'Home Page',
            style: TextStyle(
                color: Color(0xffd7d7d7),
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
  }
}
