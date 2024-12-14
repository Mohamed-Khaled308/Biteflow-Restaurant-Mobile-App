import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String id;

  const UserCard({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          UserAvatar(userId: id, userName: name),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
