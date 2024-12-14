import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  _SplitScreenState createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  String? _selectedMethod = 'equally';

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Splitting Method',
          style: TextStyle(color: ThemeConstants.whiteColor),
        ),
        backgroundColor: ThemeConstants.primaryColor,
        iconTheme: const IconThemeData(
          color: ThemeConstants.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose splitting method',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceMedium,

            ListTile(
              title: const Text('Split Equally'),
              leading: Radio<String>(
                value: 'equally',
                groupValue: _selectedMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMethod = value;
                  });
                  print('Split Equally selected');
                },
              ),
            ),
            verticalSpaceMedium,

            // Option for Item-based Splitting
            ListTile(
              title: const Text('Item Based Splitting'),
              leading: Radio<String>(
                value: 'item_based',
                groupValue: _selectedMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMethod = value;
                  });
                  print('Item Based Splitting selected');
                },
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                viewModel.placeOrder();
                print('Order Placed');
              },
              child: const Text('Place Order'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
