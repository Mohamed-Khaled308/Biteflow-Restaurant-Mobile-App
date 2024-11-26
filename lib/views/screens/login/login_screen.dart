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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
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
                              const AuthSubtitle(subtitle: 'Login with email'),
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
                  verticalSpaceLarge,
                  CustomButton(
                    text: viewModel.busy ? 'Logging in...' : 'Log in',
                    onPressed: viewModel.busy
                        ? null
                        : () => viewModel.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
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
}
