import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final DBUser user;
  final Function onTap;

  const ChatListTile({@required this.user, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: CachedNetworkImage(
                  imageUrl: user != null
                      ? user.photoURL != null
                          ? user.photoURL
                          : 'https://cdn.pixabay.com/photo/2016/04/15/18/05/computer-1331579_960_720.png'
                      : 'https://cdn.pixabay.com/photo/2016/04/15/18/05/computer-1331579_960_720.png',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageBuilder: (context, imageProvider) => Container(
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 25.0,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        user != null
                            ? user.displayName != null
                                ? user.displayName
                                : "anonimous"
                            : "anonimous",
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Очень длинное сообщение от очень хорошего человека по имени ${user.displayName}",
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}