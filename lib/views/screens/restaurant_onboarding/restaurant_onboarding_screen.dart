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
    final userProvider = context.watch<UserProvider>();

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
                    onPressed: viewModel.busy
                        ? null
                        : _handleSaveRestaurant(viewModel),
                    child: viewModel.busy
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child:  CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                          )
                        : const Text('Save and Continue'),
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
