import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/views/screens/manager_menu/components/categories_list.dart';
import 'package:biteflow/views/screens/manager_menu/components/create_item_category.dart';
import 'package:biteflow/views/screens/manager_menu/components/items_list.dart';
import 'package:biteflow/locator.dart';

class ManagerMenuScreen extends StatefulWidget {
  const ManagerMenuScreen({super.key});

  @override
  State<ManagerMenuScreen> createState() => _ManagerMenuScreenState();
}

class _ManagerMenuScreenState extends State<ManagerMenuScreen> {
  @override
  // ignore: must_call_super
  void dispose() {
    // don't call super
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerMenuViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: viewModel.busy
            ? const Text('Loading...')
            : Text(viewModel.authenticatedManagerRestaurant!.name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.whiteColor,
                )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: viewModel.busy
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: ThemeConstants.blackColor40,
              color: ThemeConstants.blackColor80,
            ))
          : viewModel.categories!.isEmpty
              ? const Center(child: Text('No items yet'))
              : const Column(
                  children: [
                    SizedBox(height: 10),
                    CategoriesList(),
                    SizedBox(height: 10),
                    ItemsList(),
                  ],
                ),
      floatingActionButton: viewModel.busy
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return ChangeNotifierProvider(
                        create: (_) => getIt<ManagerCreateItemViewModel>(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: CreateItemCategory(
                              categories: viewModel.categories),
                        ),
                      );
                    });
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: ThemeConstants.whiteColor),
            ),
    );
  }
}
