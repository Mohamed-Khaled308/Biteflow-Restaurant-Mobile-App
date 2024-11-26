import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.obscureText = false,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
