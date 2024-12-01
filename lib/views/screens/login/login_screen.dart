import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/login_view_model.dart';
import 'package:biteflow/views/screens/login/components/login_form.dart';
import 'package:biteflow/views/widgets/auth/components/auth_subtitle.dart';
import 'package:biteflow/views/widgets/auth/components/auth_title.dart';
import 'package:biteflow/views/widgets/auth/components/custom_button.dart';
import 'package:biteflow/views/widgets/auth/components/divider_with_text.dart';
import 'package:biteflow/views/widgets/auth/components/social_login_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final viewModel = context.read<LoginViewModel>();
    viewModel.updateFocusState(
      _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus,
    );
  }

  void _dismissKeyboard() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return GestureDetector(
      onTap: _dismissKeyboard, // Dismiss keyboard on tap outside
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 320.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: !viewModel.isInputActive
                          ? Column(
                              children: [
                                verticalSpaceMedium,
                                const AuthTitle(title: 'Hello Again!'),
                                verticalSpaceTiny,
                                const AuthSubtitle(
                                    subtitle:
                                        'Welcome back you\'ve been missed!'),
                              ],
                            )
                          : Column(
                              children: [
                                verticalSpaceMedium,
                                const AuthSubtitle(
                                    subtitle: 'Login with email'),
                                verticalSpaceSmall,
                              ],
                            ),
                    ),
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                    ),
                    SizedBox(
                      height: 60.h,
                      child: _buildErrorBanner(viewModel.errorMessage),
                    ),
                    CustomButton(
                      text: viewModel.busy ? 'Logging in...' : 'Log in',
                      onPressed:
                          viewModel.busy ? null : _handleLogin(viewModel),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: viewModel.isInputActive
                          ? verticalSpaceLarge
                          : verticalSpaceSmall,
                    ),
                    const DividerWithText(text: 'Or'),
                    verticalSpaceSmall,
                    SocialLoginButton(
                      icon: 'assets/icons/google.svg',
                      text: 'Continue with Google',
                      onPressed: () {},
                    ),
                    verticalSpaceSmall,
                    SocialLoginButton(
                      icon: 'assets/icons/facebook.svg',
                      text: 'Continue with Facebook',
                      onPressed: () {},
                    ),
                    verticalSpaceMedium,
                    verticalSpaceTiny,
                    _buildRegisterLink(viewModel.navigateToSignup),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  VoidCallback _handleLogin(LoginViewModel viewModel) {
    return () {
      _dismissKeyboard();
      viewModel.clearError();
      if (_formKey.currentState!.validate()) {
        viewModel.login(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    };
  }

  Widget _buildErrorBanner(String errorMessage) {
    if (errorMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ThemeConstants.errorColor.withOpacity(0.1),
        border: Border.all(color: ThemeConstants.errorColor),
        borderRadius:
            BorderRadius.circular(ThemeConstants.defaultBorderRadious),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: ThemeConstants.errorColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: ThemeConstants.errorColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<LoginViewModel>().clearError();
            },
            child: const Icon(Icons.close, color: ThemeConstants.errorColor),
          ),
        ],
      ),
    );
  }
}
