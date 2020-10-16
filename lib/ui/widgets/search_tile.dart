import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/core/models/db_user_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final dbUser user;
  const SearchTile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: user != null
                        ? user.photoURL
                        : "https://i.stack.imgur.com/uFPpM.png?s=328&g=1",
                    imageBuilder: (context, imageProvider) => Container(
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 25.0,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user != null ? user.displayName : "anonimous",
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      user != null ? user.email : "@mer.ci.nsu.ru",
                      style: TextStyle(
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
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
          ],
        ));
  }
}
