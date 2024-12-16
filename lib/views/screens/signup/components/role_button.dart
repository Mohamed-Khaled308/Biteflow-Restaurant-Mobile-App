import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleButton extends StatelessWidget {
  final String role;
  final String selectedRole;
  final ValueChanged<String> onPressed;

  const RoleButton({
    super.key,
    required this.role,
    required this.selectedRole,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = role == selectedRole;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ThemeConstants.blackColor.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: OutlinedButton(
          onPressed: () => onPressed(role),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).secondaryHeaderColor,
            side: isSelected
                ? BorderSide.none
                : const BorderSide(color: ThemeConstants.greyColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      ),
    );
  }
}
