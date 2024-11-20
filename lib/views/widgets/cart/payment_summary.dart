import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:  const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                 SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '1000 EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}