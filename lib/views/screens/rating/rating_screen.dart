import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/rating_view_model.dart';
import 'package:biteflow/views/screens/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class RatingScreen extends StatefulWidget {
  final String restaurantId;

  const RatingScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RatingViewModel>().loadRestaurant(widget.restaurantId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_rating > 0 || _commentController.text.isNotEmpty) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Rating?'),
          content: const Text('Are you sure you want to discard your rating?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: ThemeConstants.errorColor,
              ),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return shouldDiscard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RatingViewModel>();
    final userProvider = context.watch<UserProvider>();

    if (!userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rate Restaurant'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: const Center(
          child: Text('Please login to rate restaurants'),
        ),
      );
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rate Restaurant'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            TextButton.icon(
              onPressed: () => _onWillPop().then((shouldPop) {
                if (shouldPop) {
                  getIt<NavigationService>().pop();
                }
              }),
              icon:  Icon(Icons.close, color: Theme.of(context).secondaryHeaderColor),
              label: Text(
                'Discard',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
            ),
          ],
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (viewModel.restaurant != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          viewModel.restaurant!.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Thank you for ordering from ${viewModel.restaurant!.name}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please rate your experience',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32),
                    Center(
                      child: RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 40,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: ThemeConstants.warningColor,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: 'Leave a comment (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ThemeConstants.defaultBorderRadious,
                          ),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    if (viewModel.error != null)
                      Text(
                        viewModel.error!,
                        style:
                            const TextStyle(color: ThemeConstants.errorColor),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.isLoading || _rating == 0
                          ? null
                          : () async {
                              final success = await viewModel.submitRating(
                                widget.restaurantId,
                                _rating,
                                _commentController.text,
                              );
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thank you for your rating!'),
                                    backgroundColor:
                                        ThemeConstants.successColor,
                                  ),
                                );
                                // Navigator.popUntil(context, (route) => route.isFirst);
                                getIt<NavigationService>().popUntil(HomeView);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ThemeConstants.defaultBorderRadious,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: viewModel.isLoading
                          ?  CircularProgressIndicator(
                              color: Theme.of(context).secondaryHeaderColor)
                          :  Text(
                              'Submit Rating',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
