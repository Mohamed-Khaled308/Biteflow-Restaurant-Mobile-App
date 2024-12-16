import 'package:biteflow/viewmodels/login_view_model.dart';
import 'package:biteflow/views/widgets/auth/components/custom_textfield.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:provider/provider.dart';

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
    final viewModel = context.watch<LoginViewModel>();

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          verticalSpaceLarge,
          CustomTextField(
            controller: emailController,
            labelText: 'Email *',
            hintText: 'Enter your email',
            validator: (value) => viewModel.validateEmail(value ?? ''),
            errorText: viewModel.emailError,
            focusNode: emailFocusNode,
          ),
          verticalSpaceRegular,
          CustomTextField(
            controller: passwordController,
            labelText: 'Password *',
            hintText: 'Enter your password',
            validator: (value) => viewModel.validatePassword(value ?? ''),
            errorText: viewModel.passwordError,
            obscureText: true,
            focusNode: passwordFocusNode,
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child:
                 Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                'Forgot Password?',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
