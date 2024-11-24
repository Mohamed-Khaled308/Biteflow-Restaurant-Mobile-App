import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/login_view_model.dart';
import 'package:biteflow/views/screens/auth/components/login_signup_button.dart';
import 'package:biteflow/views/screens/auth/components/custom_textfield.dart';
import 'package:biteflow/views/screens/auth/components/divider_with_text.dart';
import 'package:biteflow/views/screens/auth/components/social_login_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic> getInfo() {
    Map<String, dynamic> info = {};
    info['email'] = _emailController.text;
    info['password'] = _passwordController.text;
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                verticalSpaceMedium,
                _buildTitle(),
                verticalSpaceSmall,
                _buildSubtitle(),
                SizedBox(
                  height: 225.h,
                  child: Column(
                    children: <Widget>[
                      verticalSpaceLarge,
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        obscureText: false,
                      ),
                      verticalSpaceRegular,
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                      ),
                      _buildForgetPassword(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Log in',
                        onPressed: () {
                          viewModel.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        },
                      ),
                      verticalSpaceRegular,
                      const DividerWithText(text: 'Or'),
                      verticalSpaceRegular,
                      SocialLoginButton(
                          icon: 'assets/icons/google.svg',
                          text: 'Continue with Google',
                          onPressed: () {}),
                      verticalSpaceSmall,
                      SocialLoginButton(
                          icon: 'assets/icons/facebook.svg',
                          text: 'Continue with Facebook',
                          onPressed: () {}),
                      verticalSpaceLarge,
                    ],
                  ),
                ),
                _buildRegisterLink(viewModel.navigateToSignup),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTitle() {
  return Center(
    child: Text(
      'Hello Again!',
      style: TextStyle(
        color: ThemeConstants.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
    ),
  );
}

Widget _buildSubtitle() {
  return Center(
    child: SizedBox(
      width: 280.w,
      child: Text(
        'Welcome back you\'ve been missed!',
        style: TextStyle(
          color: ThemeConstants.blackColor60,
          fontSize: 22.sp,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildForgetPassword() {
  return Padding(
    padding: EdgeInsets.all(8.w),
    child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        'Forgot Password?',
        style: TextStyle(color: ThemeConstants.blackColor60),
      ),
    ]),
  );
}

Widget _buildRegisterLink(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(color: ThemeConstants.blackColor60),
        ),
        SizedBox(
          width: 4.w,
        ),
        const Text(
          'Sign Up',
          style: TextStyle(
              color: ThemeConstants.blueColor, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
