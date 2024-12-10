import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/cart/card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Scan QR Code to be added to cart',
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.normal,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (Barcode barcode in barcodes) {
                            if (barcode.rawValue != null) {
                              print("barcode value is ${barcode.rawValue}");
                              getIt<NavigationService>().pop();// todo redirect to the new cart
                            }
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt_rounded)),
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
                        data: '1234567890',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                );
             
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: viewModel.listKey,
              itemBuilder: (ctx, index, animation) =>
                  OrderItemCard(viewModel.cartItems[index]),
              // not using animation as an animation is done in the view model
              initialItemCount: viewModel.cartItems.length,
            ),
          ),
          PaymentSummary(viewModel.totalAmount),
        ],
      ),
    );
  }
}
