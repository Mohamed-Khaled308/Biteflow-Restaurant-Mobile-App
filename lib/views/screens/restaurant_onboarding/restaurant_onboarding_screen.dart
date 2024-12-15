import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart'; 
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/viewmodels/image_view_model.dart'; // Import ImageViewModel
import 'package:biteflow/views/widgets/auth/components/custom_button.dart';
import 'package:biteflow/views/widgets/auth/components/auth_subtitle.dart';
import 'package:biteflow/views/widgets/auth/components/auth_title.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart'; // Import GetIt 
import 'package:biteflow/views/screens/restaurant_onboarding/components/restaurant_onboarding_form.dart';
import 'package:biteflow/core/providers/user_provider.dart';

class RestaurantOnboardingScreen extends StatefulWidget {
  const RestaurantOnboardingScreen({super.key});

  @override
  State<RestaurantOnboardingScreen> createState() => _RestaurantOnboardingScreenState();
}

class _RestaurantOnboardingScreenState extends State<RestaurantOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // Removed the imageUrlController
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  // ImageViewModel instance
  late final ImageViewModel _imageViewModel;

  // Loading state for image uploading
  bool _isImageLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize ImageViewModel using GetIt
    _imageViewModel = GetIt.I<ImageViewModel>();
    _imageViewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    _imageViewModel.removeListener(_updateUI);
    _nameController.dispose();
    // Removed the imageUrlController
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  // Method to handle image picking
  Future<void> _pickImage() async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      await _imageViewModel.pickAndUploadImage();

      if (!mounted) return;

      if (_imageViewModel.imageUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    }
  }

  // Updated form submission handler
  VoidCallback _handleSaveRestaurant(RestaurantOnboardingViewModel viewModel) {
    return () {
      if (_formKey.currentState!.validate()) {
        if (_imageViewModel.imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add an image')),
          );
          return;
        }
        viewModel.saveRestaurantData(
          name: _nameController.text,
          location: _locationController.text,
          imageUrl: _imageViewModel.imageUrl!,
          description: _descriptionController.text,
        );
      }
    };
  }

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
              child: Form(
                key: _formKey,
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
                      nameController: _nameController,
                      // Removed the imageUrlController
                      locationController: _locationController,
                      descriptionController: _descriptionController,
                    ),
                    const SizedBox(height: 24),
                    // Image Picker
                    Text(
                      'Restaurant Image',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            if (_imageViewModel.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _imageViewModel.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 48),
                                    SizedBox(height: 8),
                                    Text('Tap to add image'),
                                  ],
                                ),
                              ),
                            if (_imageViewModel.imageUrl != null)
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Change Image',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            if (_isImageLoading)
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: viewModel.busy
                          ? null
                          : _handleSaveRestaurant(viewModel),
                      child: viewModel.busy
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                color: ThemeConstants.primaryColor,
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
      ),
    );
  }
}
