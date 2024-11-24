import 'package:biteflow/views/screens/auth/components/custom_textfield.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';

class ManagerSignupView extends StatelessWidget {
  ManagerSignupView({super.key});

  final _nameController = TextEditingController();
  final _restaurantController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Map<String, dynamic> getInfo() {
    Map<String, dynamic> info = {};
    info['name'] = _nameController.value.text;
    info['email'] = _emailController.value.text;
    info['restaurantName'] = _restaurantController.value.text;
    info['password'] = _passwordController.value.text;
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextField(
          controller: _nameController,
          hintText: 'Enter your name',
          obscureText: false,
        ),
        verticalSpaceRegular,
        CustomTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          obscureText: false,
        ),
        verticalSpaceRegular,
        CustomTextField(
          controller: _restaurantController,
          hintText: 'Enter your Restaurant name',
          obscureText: false,
        ),
        verticalSpaceRegular,
        CustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          obscureText: true,
        ),
      ],
    );
  }
}
