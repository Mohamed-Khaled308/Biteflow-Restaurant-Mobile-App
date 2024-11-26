import 'package:biteflow/views/widgets/auth/components/custom_textfield.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/core/constants/theme_constants.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          verticalSpaceLarge,
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            focusNode: emailFocusNode,
          ),
          verticalSpaceRegular,
          CustomTextField(
            controller: passwordController,
            hintText: 'Enter your password',
            obscureText: true,
            focusNode: passwordFocusNode,
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child:
                const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                'Forgot Password?',
                style: TextStyle(color: ThemeConstants.blackColor60),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
