import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12.h),
        backgroundColor: onPressed == null
            ? ThemeConstants.greyColor.withOpacity(0.5)
            : ThemeConstants.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ThemeConstants.defaultBorderRadious),
        ),
        side: const BorderSide(color: ThemeConstants.greyColor),
      ),
      child: SvgPicture.asset(
        icon,
        height: 24.h,
        width: 24.w,
      ),
    );
  }
}
