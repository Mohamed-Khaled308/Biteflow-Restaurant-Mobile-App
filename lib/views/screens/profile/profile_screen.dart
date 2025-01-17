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
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
             Text('Profile', style: TextStyle(fontSize: 20, color: Theme.of(context).secondaryHeaderColor)),
          ],
        ),
        actions: [
           IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_sharp
                  : Icons.dark_mode_sharp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).secondaryHeaderColor,
            ),
            onPressed: () {
              modeViewModel.toggleThemeMode();
            },
          ),
          

          IconButton(
            icon: const Icon(Icons.logout),
            color: Theme.of(context).secondaryHeaderColor,
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
                color:  Theme.of(context).primaryColor.withOpacity(0.1),
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
                color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style:  TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style:  TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(
                      Icons.email,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.email,
                      style:  TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Motivational quote
                 Text(
                  '"The best way to predict the future is to create it."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => viewModel.logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
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
