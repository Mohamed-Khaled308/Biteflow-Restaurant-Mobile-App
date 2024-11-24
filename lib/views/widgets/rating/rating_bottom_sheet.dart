
import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/models/item.dart';
import 'package:biteflow/views/widgets/rating/star_rating_bar.dart';
import 'package:flutter/material.dart'; 

class RatingBottomSheet extends StatefulWidget {
  final Item item;
  final ValueChanged<double> onRatingSubmitted;

  const RatingBottomSheet({
    required this.item,
    required this.onRatingSubmitted,
    super.key,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();


}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double _currentRating = 0.0;


  @override
  void initState() {
    super.initState();
    _currentRating = widget.item.rating;
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.only(
          top: ThemeConstants.defaultPadding,
          left: ThemeConstants.defaultPadding,
          right: ThemeConstants.defaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              ThemeConstants.defaultPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rate ${widget.item.title}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.item.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              StarRatingBar(
                initialRating: _currentRating,
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                    widget.onRatingSubmitted(_currentRating);
                  });
                },
              ),
              
             
            ],
          ),
        ),
      );
    
  }
}
