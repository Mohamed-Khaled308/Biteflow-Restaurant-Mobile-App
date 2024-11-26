import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/views/screens/restaurant_onboarding/components/restaurant_onboarding_form.dart';
import 'package:biteflow/views/widgets/auth/components/auth_subtitle.dart';
import 'package:biteflow/views/widgets/auth/components/auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart';
import 'package:biteflow/views/widgets/auth/components/custom_button.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class RestaurantOnboardingScreen extends StatelessWidget {
  RestaurantOnboardingScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RestaurantOnboardingViewModel>();
    final userProvider = getIt<UserProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 320.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceRegular,
                  AuthTitle(title: 'Welcome ${userProvider.user!.name}!'),
                  verticalSpaceSmall,
                  const AuthSubtitle(
                      subtitle: 'Let\'s set up your restaurant profile'),
                  verticalSpaceLarge,
                  RestaurantOnboardingForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      imageUrlController: _imageUrlController,
                      locationController: _locationController,
                      descriptionController: _descriptionController),
                  verticalSpaceLarge,
                  CustomButton(
                    text: viewModel.busy ? 'Saving...' : 'Save and Continue',
                    onPressed: viewModel.busy
                        ? null
                        : _handleSaveRestaurant(viewModel),
                  ),
                  verticalSpaceRegular,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _handleSaveRestaurant(RestaurantOnboardingViewModel viewModel) {
    return () {
      if (_formKey.currentState!.validate()) {
        viewModel.saveRestaurantData(
            name: _nameController.text,
            location: _locationController.text,
            imageUrl: _imageUrlController.text,
            description: _descriptionController.text);
      }
    };
  }
}