import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/signup_view_model.dart';
import 'package:biteflow/views/screens/auth/components/login_signup_button.dart';
import 'package:biteflow/views/screens/auth/components/divider_with_text.dart';
import 'package:biteflow/views/screens/auth/components/role_button.dart';
import 'package:biteflow/views/screens/auth/components/social_login_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/views/screens/auth/components/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                verticalSpaceSmall,
                _buildTitle(),
                verticalSpaceTiny,
                _buildSubtitle(),
                SizedBox(
                  height: 358,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoleButton(
                              role: 'Client',
                              selectedRole: viewModel.selectedRole,
                              onPressed: viewModel.setRole),
                          RoleButton(
                              role: 'Manager',
                              selectedRole: viewModel.selectedRole,
                              onPressed: viewModel.setRole)
                        ],
                      ),
                      verticalSpaceSmall,
                      verticalSpaceMedium,
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter your name',
                        obscureText: false,
                      ),
                      verticalSpaceSmall,
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        obscureText: false,
                      ),
                      verticalSpaceSmall,
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250.h,
                  child: Column(
                    children: [
                      CustomButton(
                          text: 'Sign up',
                          onPressed: () => viewModel.signUp(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                              )),
                      Column(
                        children: [
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
                        ],
                      ),
                      verticalSpaceLarge,
                    ],
                  ),
                ),
                _buildRegisterLink(viewModel.navigateToLogin),
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
      'Sign Up',
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
    child: Text(
      'Create an account',
      style: TextStyle(
        color: ThemeConstants.blackColor60,
        fontSize: 22.sp,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildRegisterLink(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(color: ThemeConstants.blackColor60),
        ),
        SizedBox(
          width: 4.w,
        ),
        const Text(
          'Login',
          style: TextStyle(
              color: ThemeConstants.blueColor, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
