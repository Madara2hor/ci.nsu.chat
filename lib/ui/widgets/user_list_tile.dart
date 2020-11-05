import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final DBUser user;
  final Function onTap;

  const UserListTile({@required this.user, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 8.0, right: 4.0),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user != null
                        ? user.displayName != null
                            ? user.displayName
                            : "anonimous"
                        : "anonimous",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textColor, fontSize: 14),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user != null
                        ? user.email != null
                            ? user.email
                            : "@mer.ci.nsu.ru"
                        : "@mer.ci.nsu.ru",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.thirdColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                color: AppColors.mainColor,
                alignment: Alignment.center,
                height: 50.0,
                width: 50.0,
                child: Image(
                    color: AppColors.textColor,
                    height: 24,
                    width: 24,
                    image: AssetImage('assets/icons/chat.png')),
              ),
            ),
          ],
        ));
  }
}