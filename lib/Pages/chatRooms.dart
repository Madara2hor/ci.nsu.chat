import 'package:flutter/material.dart';

class ChatRoomsPage extends StatefulWidget {
  ChatRoomsPage({Key key}) : super(key: key);

  @override
  _ChatRoomsPageState createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
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
