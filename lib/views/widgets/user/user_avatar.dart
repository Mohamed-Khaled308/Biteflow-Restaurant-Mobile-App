import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  final String userId, userName;
  const UserAvatar({super.key, required this.userId, required this.userName});
  Color _getAvatarColor(String userId) {
    var bytes = utf8.encode(userId);
    var digest = sha256.convert(bytes);

    String hexColor = digest.toString().substring(0, 6);

    return Color(int.parse('0xFF$hexColor'));
  }

  String _getAvatarText(String name) {
    String str = name[0].toUpperCase();
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      str += parts[1][0].toUpperCase();
    } else if (parts[0].length > 1) {
      str += parts[0][1].toUpperCase();
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColor(userId);
    final avatarText = _getAvatarText(userName);
    return SizedBox(
      width: 30.w,
      height: 30.h,
      child: CircleAvatar(
        radius: 15.r,
        backgroundColor: avatarColor,
        child: Text(
          avatarText,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );
  }
}
