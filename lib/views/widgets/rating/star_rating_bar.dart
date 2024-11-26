
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';
 
class StarRatingBar extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;

  const StarRatingBar({
    required this.initialRating,
    required this.onRatingUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            onRatingUpdate(index + 1.0);
          },
          child: Icon(
            Icons.star,
            size: 40.0,
            color: index < initialRating
                ? ThemeConstants.warningColor
                : ThemeConstants.greyColor,
          ),
        );
      }),
    );
  }
}
