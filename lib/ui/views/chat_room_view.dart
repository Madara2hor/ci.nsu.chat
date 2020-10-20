import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ChatRoomView extends StatefulWidget {
  ChatRoomView({Key key}) : super(key: key);

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width - 30,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: AppColors.secondColor,
            boxShadow: kElevationToShadow[6],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: AppColors.textColor),
                      onSubmitted: null,
                      decoration: InputDecoration(
                          hintText: 'Сообщение...',
                          hintStyle: TextStyle(color: AppColors.textColor),
                          border: InputBorder.none),
                    )),
              ),
              Container(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image(
                          color: AppColors.textColor,
                          height: 24,
                          width: 24,
                          image: AssetImage('assets/icons/chat.png')),
                    ),
                    onTap: null,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(left: 12.0, top: 40.0, right: 12.0),
                    child: Image(
                        color: AppColors.textColor,
                        height: 24,
                        width: 24,
                        image: AssetImage('assets/icons/back.png')),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.only(top: 40.0, right: 12.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ФИО самого прекрасного человека на свете',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
