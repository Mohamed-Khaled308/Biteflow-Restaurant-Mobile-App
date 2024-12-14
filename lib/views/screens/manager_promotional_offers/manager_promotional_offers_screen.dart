import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:biteflow/views/screens/manager_promotional_offers/add_promotional_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManagerPromotionalOffersScreen extends StatefulWidget {
  const ManagerPromotionalOffersScreen({super.key});

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
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: offer.isActive ? Colors.green : Colors.grey,
                          width: offer.isActive ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (offer.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                offer.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        offer.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (offer.isActive)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'ACTIVE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(offer.description),
                                const SizedBox(height: 8),
                                Text(
                                  'Discount: ${offer.discount.toStringAsFixed(2)}%',
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
