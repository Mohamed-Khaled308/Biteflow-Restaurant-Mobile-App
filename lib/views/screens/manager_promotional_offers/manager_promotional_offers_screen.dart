import 'package:biteflow/locator.dart';
import 'package:biteflow/models/offer_notification.dart';
import 'package:biteflow/services/firestore/offer_notification_service.dart';
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
  final TextEditingController _offerController = TextEditingController();
  final OfferNotificationService _offerService =
      getIt<OfferNotificationService>();

    DateTime? _endDate;

   @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
  }

  Future<void> _addOffer() async {
    if (_offerController.text.isNotEmpty) {
      String id = _offerService.generateofferNotificationId();
      OfferNotification offer = OfferNotification(
                        id: id,
                        title: _offerController.text,
                        endDate: _endDate!, // Use the selected endDate
                      );
      final result = await _offerService.createOfferNotification(offer);

      if (result.error == null) {
        _offerController.clear();
        setState(() {
          _endDate = null; // Reset the end date after successful submission
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Offer notification sent successfully!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the modal card
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.error}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  void _showOfferInputModal() {
    const String initialTitle = ''; 
    const DateTime? initialEndDate = null;

    // Reset the controller's text and the end date
    _offerController.text = initialTitle;
    _endDate = initialEndDate;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Send Offer Notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _offerController,
                      decoration:  InputDecoration(
                        labelText: 'Offer Title',
                        border: const OutlineInputBorder(),
                        fillColor: Theme.of(context).secondaryHeaderColor, // Background color of the input
                        filled: true, // Enables the background color
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () async {
                        // Show Date Picker
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setModalState(() {
                            _endDate =
                                pickedDate; // Update end date in modal state
                          });
                        }
                      },
                      child: Text(
                        _endDate == null
                            ? 'Pick End Date'
                            : 'End Date: ${DateFormat('MMM dd, yyyy').format(_endDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Reset fields to their original state
                            _offerController.text = initialTitle;
                            _endDate = initialEndDate;

                            Navigator.pop(context); // Close the modal
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).secondaryHeaderColor, // Text color
                            backgroundColor: Colors.red, // Background color
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_offerController.text.isEmpty ||
                                _endDate == null) {
                              // Show error if inputs are missing
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              _addOffer();
                              _offerController.text = initialTitle;
                              _endDate = initialEndDate;
                              // Navigator.pop(context);
                              // getIt<NavigationService>().pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).secondaryHeaderColor, // Text color
                            backgroundColor: Colors.green, // Background color
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                          ),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerPromotionalOffersViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotional Offers'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.local_offer),
            tooltip: 'Send Offer Notification',
            onPressed: _showOfferInputModal,
          ),
        ],
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
