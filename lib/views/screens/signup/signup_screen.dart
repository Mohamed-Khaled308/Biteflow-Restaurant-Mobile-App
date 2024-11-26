import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/signup_view_model.dart';
import 'package:biteflow/views/screens/signup/components/signup_form.dart';
import 'package:biteflow/views/widgets/auth/components/auth_subtitle.dart';
import 'package:biteflow/views/widgets/auth/components/auth_title.dart';
import 'package:biteflow/views/widgets/auth/components/custom_button.dart';
import 'package:biteflow/views/widgets/auth/components/divider_with_text.dart';
import 'package:biteflow/views/widgets/auth/components/social_login_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleFocusChange);
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final viewModel = context.read<SignupViewModel>();
    
    viewModel.updateFocusState(
      _nameFocusNode.hasFocus ||
          _emailFocusNode.hasFocus ||
          _passwordFocusNode.hasFocus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
          child: Center(
            child: SizedBox(
              width: 320.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !viewModel.isInputActive
                        ? const AuthTitle(title: 'Sign up')
                        : const SizedBox.shrink(),
                  ),
                  const AuthSubtitle(subtitle: 'Create an account'),
                  verticalSpaceMedium,
                  SignupForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      nameFocusNode: _nameFocusNode,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode),
                  verticalSpaceMedium,
                  CustomButton(
                    text: viewModel.busy ? 'Signing up...' : 'Sign up',
                    onPressed: viewModel.busy ? null : _handleSignup(viewModel),
                  ),
                  verticalSpaceSmall,
                  const DividerWithText(text: 'Or'),
                  verticalSpaceSmall,
                  SocialLoginButton(
                    icon: 'assets/icons/google.svg',
                    text: 'Continue with Google',
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  verticalSpaceSmall,
                  SocialLoginButton(
                    icon: 'assets/icons/facebook.svg',
                    text: 'Continue with Facebook',
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                  verticalSpaceMedium,
                  verticalSpaceTiny,
                  GestureDetector(
                    onTap: viewModel.navigateToLogin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: ThemeConstants.blackColor60),
                        ),
                        SizedBox(width: 4.w),
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: ThemeConstants.blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _handleSignup(SignupViewModel viewModel) {
    return () {
      if (_formKey.currentState!.validate()) {
        viewModel.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
      }
    };
  }
}
