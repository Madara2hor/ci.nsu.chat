import 'package:cached_network_image/cached_network_image.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDescriptionTile extends StatelessWidget {
  final User user;

  const UserDescriptionTile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        CachedNetworkImage(
          imageUrl: user != null
              ? user.photoURL
              : "https://i.stack.imgur.com/uFPpM.png?s=328&g=1",
          placeholder: (context, url) => CircularProgressIndicator(),
          imageBuilder: (context, imageProvider) => Container(
            child: CircleAvatar(
              backgroundImage: imageProvider,
              radius: 45.0,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          user != null ? user.displayName : "anonimous",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          user != null ? user.email : "@mer.ci.nsu.ru",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.thirdColor,
            fontSize: 16,
          ),
        ),
        Divider(
          height: 20,
          thickness: 0.5,
          color: Colors.white.withOpacity(0.5),
          indent: 5,
          endIndent: 5,
        ),
      ],
    );
  }
}
