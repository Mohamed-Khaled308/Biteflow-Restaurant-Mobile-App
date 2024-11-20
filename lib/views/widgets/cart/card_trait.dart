import 'package:flutter/material.dart';

class OrderItemCardTrait extends StatelessWidget {
  const OrderItemCardTrait(
    this.icon, 
    this.iconColor, 
    this.data, 
    this.dataColor, 
    {super.key}
  );

  final IconData icon;
  final Color iconColor;
  final String data;
  final Color dataColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            data,
            style: TextStyle(
              color: dataColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}