import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';

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
      child: OutlinedButton(
        onPressed: () => onPressed(role),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? ThemeConstants.primaryColor
              : ThemeConstants.whiteColor,
          side: const BorderSide(color: ThemeConstants.greyColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          role,
          style: TextStyle(
            color: isSelected
                ? ThemeConstants.whiteColor
                : ThemeConstants.blackColor,
          ),
        ),
      ),
    );
  }
}
