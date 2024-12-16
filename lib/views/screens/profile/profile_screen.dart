import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/mode_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/viewmodels/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.authenticatedUser;
    final modeViewModel = context.watch<ModeViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeConstants.primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: ThemeConstants.blackColor40,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.whiteColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Profile', style: TextStyle(fontSize: 20, color: ThemeConstants.whiteColor)),
          ],
        ),
        actions: [
           IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_sharp
                  : Icons.dark_mode_sharp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              modeViewModel.toggleThemeMode();
            },
          ),
          

          IconButton(
            icon: const Icon(Icons.logout),
            color: ThemeConstants.whiteColor,
            onPressed: () {
              viewModel.logout();
            },
          ),
        ],
      ),
      body: 
      Stack(
        children: [
          // Decorative shapes
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color:  ThemeConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ThemeConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: ThemeConstants.primaryColor.withOpacity(0.8),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: ThemeConstants.whiteColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.blackColor40,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: ThemeConstants.blackColor40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 20,
                        color: ThemeConstants.blackColor40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Motivational quote
                const Text(
                  '"The best way to predict the future is to create it."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: ThemeConstants.blackColor60,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => viewModel.logout(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
