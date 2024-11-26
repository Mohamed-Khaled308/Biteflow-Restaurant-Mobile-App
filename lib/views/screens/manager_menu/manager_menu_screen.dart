import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/views/screens/manager_menu/components/categories_list.dart';
import 'package:biteflow/views/screens/manager_menu/components/create_menu_item_category/create_menu_main.dart';
import 'package:biteflow/views/screens/manager_menu/components/items_list.dart';

class ManagerMenuScreen extends StatefulWidget {
  const ManagerMenuScreen({super.key});

  @override
  State<ManagerMenuScreen> createState() => _ManagerMenuScreenState();
}

class _ManagerMenuScreenState extends State<ManagerMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerMenuViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(viewModel.restaurantName,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.whiteColor,
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          CategoriesList(),
          SizedBox(height: 10),
          ItemsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const CreateMenuMain(),
                );
              });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: ThemeConstants.whiteColor),
      ),
    );
  }
}
