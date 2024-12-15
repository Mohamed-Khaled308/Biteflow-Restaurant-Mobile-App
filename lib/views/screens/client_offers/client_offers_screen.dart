import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/offer_notification.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientOffersScreen extends StatefulWidget {
  const ClientOffersScreen({super.key});

  @override
  State<ClientOffersScreen> createState() => _ClientOffersScreenState();
}

class _ClientOffersScreenState extends State<ClientOffersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if (user != null) {
        final updatedUser = Client(
          id: user.id,
          name: user.name,
          email: user.email,
          fcmToken: user.fcmToken,
          orderIds: (user as Client).orderIds,
          unseenOfferCount: 0,
        );
        await UserService().updateUser(updatedUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.offerNotificationCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No offers available.'));
          }

          final offers = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OfferNotification.fromData(data);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Number of columns
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio:
                  4 / 1, // Adjusted ratio for better content layout
            ),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Offer Title'),
                        content: Text(offer.title),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Valid Until:',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(offer.endDate),
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
