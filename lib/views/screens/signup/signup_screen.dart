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

  void _dismissKeyboard() {
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
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
                          ? Column(
                              children: [
                                const AuthTitle(title: 'Sign up'),
                                verticalSpaceTiny,
                              ],
                            )
                          : verticalSpaceSmall,
                    ),
                    const AuthSubtitle(subtitle: 'Create a new account'),
                    verticalSpaceMedium,
                    SignupForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        nameFocusNode: _nameFocusNode,
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: viewModel.isInputActive ? 10.h : 60.h,
                      child: _buildErrorBanner(viewModel.errorMessage),
                    ),
                    CustomButton(
                      onPressed:
                          viewModel.busy ? null : _handleSignup(viewModel),
                      child: viewModel.busy
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                color: ThemeConstants.primaryColor,
                              ),
                            )
                          : const Text('Sign up'),
                    ),
                    verticalSpaceMassive,
                    verticalSpaceSmall,
                    verticalSpaceTiny,
                    GestureDetector(
                      onTap: viewModel.navigateToLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style:
                                TextStyle(color: ThemeConstants.blackColor60),
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
      ),
    );
  }

  VoidCallback _handleSignup(SignupViewModel viewModel) {
    return () {
      _dismissKeyboard();
      if (_formKey.currentState!.validate()) {
        viewModel.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
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
              context.read<SignupViewModel>().clearError();
            },
            child: const Icon(Icons.close, color: ThemeConstants.errorColor),
          ),
        ],
      ),
    );
  }
}
