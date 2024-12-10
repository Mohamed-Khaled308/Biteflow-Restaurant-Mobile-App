import 'package:biteflow/services/firestore/offer_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/models/offer_notification.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';

class ManagerOffersScreen extends StatefulWidget {
  const ManagerOffersScreen({super.key});

  @override
  State<ManagerOffersScreen> createState() => _ManagerOffersScreenState();
}

class _ManagerOffersScreenState extends State<ManagerOffersScreen> {
  final TextEditingController _offerController = TextEditingController();
  final OfferNotificationService _offerService =
      getIt<OfferNotificationService>();

  @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
  }

  Future<void> _addOffer() async {
    if (_offerController.text.isNotEmpty) {
      String id = _offerService.generateofferNotificationId();
      OfferNotification offer =
          OfferNotification(id: id, title: _offerController.text);

      final result = await _offerService.createOfferNotification(offer);

      if (result.error == null) {
        _offerController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offer added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manager Offers',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.whiteColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _offerController,
              decoration: const InputDecoration(
                labelText: 'Offer Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOffer,
              child: const Text('Add Offer'),
            ),
          ],
        ),
      ),
    );
  }
}
