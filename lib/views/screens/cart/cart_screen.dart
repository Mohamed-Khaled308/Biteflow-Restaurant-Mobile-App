import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    viewModel.onItemRemoved = (index) {
      final removedItem = viewModel.cart.items[index];

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: CartItemCard(removedItem),
        ),
        duration: const Duration(milliseconds: 300),
      );
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
              icon: const Icon(Icons.qr_code_2_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Scan this QR Code to be added to the order',
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      child: QrImageView(
                        data: viewModel.cart.id,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
      body: StreamBuilder<Cart>(
        stream: viewModel.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          viewModel.setCart = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: viewModel.cart.items.length,
                  itemBuilder: (ctx, index, animation) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: CartItemCard(viewModel.cart.items[index]),
                    );
                  },
                ),
              ),
              PaymentSummary(viewModel.totalAmount),
            ],
          );
        },
      ),
    );
  }
}
