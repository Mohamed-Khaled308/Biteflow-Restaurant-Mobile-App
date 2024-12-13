import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child; // Use Widget instead of text
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.child, // Replace text with child
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
