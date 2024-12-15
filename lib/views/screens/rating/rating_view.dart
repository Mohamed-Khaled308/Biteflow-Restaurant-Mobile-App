import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/rating_view_model.dart';
import 'package:biteflow/views/screens/rating/rating_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<RatingViewModel>(),
      child: const RatingScreen(restaurantId: 'MmpiWXTcEvi2s8hd9TUf',),
    );
  }
}
