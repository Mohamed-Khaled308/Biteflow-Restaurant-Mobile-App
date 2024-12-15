import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  SplitScreenState createState() => SplitScreenState();
}

class SplitScreenState extends State<SplitScreen> {
  String? _selectedMethod = 'equally';

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Splitting Options',
          style: TextStyle(
            color: ThemeConstants.whiteColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ThemeConstants.primaryColor,
        iconTheme: const IconThemeData(
          color: ThemeConstants.whiteColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How would you like to split the bill?',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: ThemeConstants.blackColor,
              ),
            ),
            verticalSpaceLarge,

            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = 'equally';
                });
              },
              child: ListTile(
                leading: const Icon(
                  Icons.group,
                  color: ThemeConstants.primaryColor,
                ),
                title: Text(
                  'Split Equally',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Everyone pays the same.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ThemeConstants.blackColor60,
                  ),
                ),
                trailing: Radio<String>(
                  value: 'equally',
                  groupValue: _selectedMethod,
                  activeColor: ThemeConstants.primaryColor,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMethod = value;
                    });
                  },
                ),
              ),
            ),
            verticalSpaceMedium,

            // Item-Based Splitting Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = 'item_based';
                });
              },
              child: ListTile(
                leading: const Icon(
                  Icons.pie_chart,
                  color: ThemeConstants.primaryColor,
                ),
                title: Text(
                  'Item-Based Splitting',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Each item is split equally among the people sharing it.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ThemeConstants.blackColor60,
                  ),
                ),
                trailing: Radio<String>(
                  value: 'item_based',
                  groupValue: _selectedMethod,
                  activeColor: ThemeConstants.primaryColor,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMethod = value;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),

            // Place Order Button
            ElevatedButton(
              onPressed: () {
                viewModel.placeOrder(_selectedMethod);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.primaryColor,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ThemeConstants.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
