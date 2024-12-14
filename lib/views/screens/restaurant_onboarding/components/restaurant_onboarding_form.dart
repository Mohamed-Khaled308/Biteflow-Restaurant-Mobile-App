import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart';
import 'package:biteflow/views/widgets/auth/components/custom_textfield.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantOnboardingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController imageUrlController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;

  const RestaurantOnboardingForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.imageUrlController,
    required this.locationController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RestaurantOnboardingViewModel>();

    return Form(
      key: formKey,
      child: Column(
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
          CustomTextField(
            controller: imageUrlController,
            labelText: 'Image URL *',
            hintText: 'Enter image URL',
            obscureText: false,
            validator: (value) => viewModel.validateImageUrl(value ?? ''),
            errorText: viewModel.imageUrlError,
          ),
          verticalSpaceSmall,
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
            labelText: 'Describtion *',
            hintText: 'Enter a short description',
            obscureText: false,
            validator: (value) => viewModel.validateDescription(value ?? ''),
            errorText: viewModel.descriptionError,
          ),
        ],
      ),
    );
  }
}
