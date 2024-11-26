import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          backgroundColor: ThemeConstants.whiteColor,
          side: const BorderSide(color: ThemeConstants.greyColor),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstants.defaultBorderRadious),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 16.h,
              width: 16.w,
            ),
            SizedBox(width: 20.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeConstants.blackColor80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
