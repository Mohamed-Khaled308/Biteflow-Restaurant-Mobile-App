import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSubtitle extends StatelessWidget {
  final String subtitle;

  const AuthSubtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 280.w,
        child: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 22.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
