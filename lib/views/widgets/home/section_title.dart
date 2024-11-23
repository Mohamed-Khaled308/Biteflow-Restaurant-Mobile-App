// views/widgets/home/section_title.dart

import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionTitle({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'See all',
            style: TextStyle(color: Color(0xFFC62828)), // Ruby Red
          ),
        ),
      ],
    );
  }
}
