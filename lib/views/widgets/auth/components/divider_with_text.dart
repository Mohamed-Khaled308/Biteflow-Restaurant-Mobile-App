import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: ThemeConstants.greyColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: ThemeConstants.greyColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
