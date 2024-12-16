import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart';
import 'package:biteflow/views/widgets/auth/components/custom_textfield.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantOnboardingForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;

  const RestaurantOnboardingForm({
    super.key,
    required this.nameController,
    required this.locationController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RestaurantOnboardingViewModel>();

    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          hintText: 'Enter restaurant name',
          labelText: 'Restaurant Name *',
          obscureText: false,
          validator: (value) => viewModel.validateName(value ?? ''),
          errorText: viewModel.nameError,
        ),
        verticalSpaceSmall,
        // Removed Image URL field
        CustomTextField(
          controller: locationController,
          labelText: 'Location *',
          hintText: 'Enter location',
          obscureText: false,
          validator: (value) => viewModel.validateLocation(value ?? ''),
          errorText: viewModel.locationError,
        ),
        verticalSpaceSmall,
        CustomTextField(
          controller: descriptionController,
          labelText: 'Description *',
          hintText: 'Enter a short description',
          obscureText: false,
          validator: (value) => viewModel.validateDescription(value ?? ''),
          errorText: viewModel.descriptionError,
        ),
      ],
    );
  }
}
