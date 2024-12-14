import 'package:biteflow/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                userProvider.logout(), // Call the logout function when pressed
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => userProvider.logout(),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
