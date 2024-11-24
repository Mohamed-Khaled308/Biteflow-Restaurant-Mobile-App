import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/entry_point_view_model.dart';
import 'entry_point_screen.dart';

class EntryPointView extends StatelessWidget {
  const EntryPointView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<EntryPointViewModel>(),
      child: const EntryPointScreen(),
    );
  }
}
