import 'package:biteflow/viewmodels/signup_view_model.dart';
import 'package:biteflow/views/widgets/auth/components/custom_textfield.dart';
import 'package:biteflow/views/screens/signup/components/role_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoleButton(
                role: 'Client',
                selectedRole: viewModel.selectedRole,
                onPressed: viewModel.setRole,
              ),
              RoleButton(
                role: 'Manager',
                selectedRole: viewModel.selectedRole,
                onPressed: viewModel.setRole,
              ),
            ],
          ),
          verticalSpaceMedium,
          CustomTextField(
            controller: nameController,
            hintText: 'Enter your name',
            obscureText: false,
            validator: (value) => viewModel.validateName(value ?? ''),
            errorText: viewModel.nameError,
            focusNode: nameFocusNode,
          ),
          verticalSpaceSmall,
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            obscureText: false,
            validator: (value) => viewModel.validateEmail(value ?? ''),
            errorText: viewModel.emailError,
            focusNode: emailFocusNode,
          ),
          verticalSpaceSmall,
          CustomTextField(
            controller: passwordController,
            hintText: 'Enter your password',
            obscureText: true,
            validator: (value) => viewModel.validatePassword(value ?? ''),
            errorText: viewModel.passwordError,
            focusNode: passwordFocusNode,
          ),
        ],
      ),
    );
  }
}
