import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/dialog_helper.dart';
import 'package:ci.nsu.chat/ui/views/base_view.dart';
import 'package:ci.nsu.chat/ui/widgets/models/user_search_tile_model.dart';
import 'package:flutter/material.dart';

import 'models/dialog_content.dart';

class UserSearchTile extends StatelessWidget {
  final dbUser user;
  const UserSearchTile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return BaseView<UserSearchTileModel>(
      builder: (context, model, child) => Container(
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: CachedNetworkImage(
                  imageUrl: user.photoURL != null
                      ? user.photoURL
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
                      user.displayName != null ? user.displayName : "anonimous",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      user.email != null ? user.email : "@mer.ci.nsu.ru",
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
                onTap: () async {
                  var isChatCreated = await model.goToChat(user);
                  if (!isChatCreated) {
                    DialogHelper.warning(
                        context,
                        DialogContent(
                          text: 'Тут ещё нельзя создавать чат с сами собой.',
                          title: 'Послушай...',
                        ));
                  }
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    height: 40.0,
                    width: 40.0,
                    child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: AppColors.secondColor,
                        elevation: 7.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Icon(
                                Icons.message,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ))),
              ),
            ],
          )),
    );
  }
}