import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:biteflow/views/screens/manager_promotional_offers/add_promotional_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManagerPromotionalOffersScreen extends StatefulWidget {
  ManagerPromotionalOffersScreen({super.key});

  final navservice = getIt<NavigationService>();

  @override
  State<ManagerPromotionalOffersScreen> createState() =>
      _ManagerPromotionalOffersScreenState();
}

class _ManagerPromotionalOffersScreenState
    extends State<ManagerPromotionalOffersScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerPromotionalOffersViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotional Offers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: viewModel,
                child: const AddPromotionalOfferScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.offers.isEmpty
              ? const Center(child: Text('No offers available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.offers.length,
                  itemBuilder: (context, index) {
                    final offer = viewModel.offers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (offer.imageUrl.isNotEmpty)
                            Image.network(
                              offer.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(offer.description),
                                const SizedBox(height: 8),
                                Text(
                                  'Discount: ${offer.discount}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Valid: ${DateFormat('MMM dd').format(offer.startDate)} - ${DateFormat('MMM dd, yyyy').format(offer.endDate)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
