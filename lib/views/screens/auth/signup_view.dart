import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/view-model/signup_view_model.dart';
import 'package:biteflow/views/screens/auth/components/login_signup_button.dart';
import 'package:biteflow/views/screens/auth/components/divider_with_text.dart';
import 'package:biteflow/views/screens/auth/components/role_button.dart';
import 'package:biteflow/views/screens/auth/components/social_login_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final _viewModel = getIt<SignupViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
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
                        height:
                            _viewModel.selectedRole == 'Client' ? 273.h : 337.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            verticalSpaceRegular,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoleButton(
                                    role: 'Client',
                                    selectedRole: _viewModel.selectedRole,
                                    onPressed: _viewModel.setRole),
                                RoleButton(
                                    role: 'Manager',
                                    selectedRole: _viewModel.selectedRole,
                                    onPressed: _viewModel.setRole)
                              ],
                            ),
                            verticalSpaceMedium,
                            _viewModel.selectedRoleWidget,
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            _viewModel.selectedRole == 'Client' ? 250.h : 186.h,
                        child: Column(
                          children: [
                            CustomButton(
                                text: 'Sign up', onPressed: _viewModel.signUp),
                            _viewModel.selectedRole == 'Client'
                                ? Column(
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
                                  )
                                : SizedBox(),
                            verticalSpaceLarge,
                          ],
                        ),
                      ),
                      _buildRegisterLink(_viewModel.navigateToLogin),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
