//  import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
 

class SectionTitle extends StatelessWidget {
  final String title;
  // final VoidCallback onSeeAll;

  const SectionTitle({
    required this.title,
    // required this.onSeeAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        // TextButton(
        //   onPressed: onSeeAll,
        //   child: const Text(
        //     'See all',
        //     style: TextStyle(color: ThemeConstants.primaryColor),
        //   ),
        // ),
      ],
    );
  }
}
